// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract TicketManagement is Ownable, ReentrancyGuard {
    struct Fulfiller {
        address accountAddress;
        string[] supportedPaymentMethods;
        uint256 totalCompletedTickets;
        uint256 totalEarnings;
        bool isActive;
    }

    struct Ticket {
        uint256 id;
        address customerAddress;
        address fulfillerAddress;
        uint256 amount;
        string paymentMethod;
        bool isCompleted;
        uint256 createdAt;
        uint256 completedAt;
    }

    struct Batch {
        uint256 id;
        address[] fulfillers;
        uint256[] ticketIds;
        uint256 totalAmount;
        bool isActive;
    }

    // State variables
    IERC20 public token;
    mapping(address => Fulfiller) public fulfillers;
    mapping(uint256 => Ticket) public tickets;
    mapping(uint256 => Batch) public batches;
    mapping(string => address[]) public paymentMethodToFulfillers;
    mapping(address => uint256) public customerBalances;
    mapping(address => uint256) public fulfillerBalances;
    
    uint256 public nextTicketId;
    uint256 public nextBatchId;
    uint256 public constant FEE_PERCENTAGE = 5; // 5% fee for platform

    // Events
    event TicketCreated(uint256 indexed ticketId, address indexed customer, uint256 amount);
    event TicketAssigned(uint256 indexed ticketId, address indexed fulfiller);
    event TicketCompleted(uint256 indexed ticketId, address indexed fulfiller);
    event BatchCreated(uint256 indexed batchId, uint256[] ticketIds);
    event DepositReceived(address indexed customer, uint256 amount);
    event WithdrawalProcessed(address indexed fulfiller, uint256 amount);

    constructor(address _token) {
        token = IERC20(_token);
    }

    // Register a new fulfiller
    function registerFulfiller(
        address _accountAddress,
        string[] memory _supportedPaymentMethods
    ) external onlyOwner {
        require(!fulfillers[_accountAddress].isActive, "Fulfiller already registered");
        
        fulfillers[_accountAddress] = Fulfiller({
            accountAddress: _accountAddress,
            supportedPaymentMethods: _supportedPaymentMethods,
            totalCompletedTickets: 0,
            totalEarnings: 0,
            isActive: true
        });

        // Update payment method mappings
        for (uint i = 0; i < _supportedPaymentMethods.length; i++) {
            paymentMethodToFulfillers[_supportedPaymentMethods[i]].push(_accountAddress);
        }
    }

    // Create a new ticket
    function createTicket(
        address _customerAddress,
        uint256 _amount,
        string memory _paymentMethod
    ) external onlyOwner returns (uint256) {
        require(_amount > 0, "Amount must be greater than 0");
        
        uint256 ticketId = nextTicketId++;
        tickets[ticketId] = Ticket({
            id: ticketId,
            customerAddress: _customerAddress,
            fulfillerAddress: address(0),
            amount: _amount,
            paymentMethod: _paymentMethod,
            isCompleted: false,
            createdAt: block.timestamp,
            completedAt: 0
        });

        emit TicketCreated(ticketId, _customerAddress, _amount);
        return ticketId;
    }

    // Create a new batch of tickets
    function createBatch(uint256[] memory _ticketIds) external onlyOwner returns (uint256) {
        require(_ticketIds.length > 0, "Batch must contain at least one ticket");
        
        uint256 batchId = nextBatchId++;
        uint256 totalAmount = 0;
        
        for (uint i = 0; i < _ticketIds.length; i++) {
            require(!tickets[_ticketIds[i]].isCompleted, "Ticket already completed");
            totalAmount += tickets[_ticketIds[i]].amount;
        }

        batches[batchId] = Batch({
            id: batchId,
            fulfillers: getEligibleFulfillers(_ticketIds),
            ticketIds: _ticketIds,
            totalAmount: totalAmount,
            isActive: true
        });

        emit BatchCreated(batchId, _ticketIds);
        return batchId;
    }

    // Assign tickets to fulfillers
    function assignTickets(uint256 _batchId) external onlyOwner {
        Batch storage batch = batches[_batchId];
        require(batch.isActive, "Batch not active");

        for (uint i = 0; i < batch.ticketIds.length; i++) {
            Ticket storage ticket = tickets[batch.ticketIds[i]];
            if (ticket.fulfillerAddress == address(0)) {
                address eligibleFulfiller = findEligibleFulfiller(
                    ticket.paymentMethod,
                    batch.fulfillers
                );
                if (eligibleFulfiller != address(0)) {
                    ticket.fulfillerAddress = eligibleFulfiller;
                    emit TicketAssigned(ticket.id, eligibleFulfiller);
                }
            }
        }
    }

    // Complete a ticket
    function completeTicket(uint256 _ticketId) external nonReentrant {
        Ticket storage ticket = tickets[_ticketId];
        require(!ticket.isCompleted, "Ticket already completed");
        require(msg.sender == ticket.fulfillerAddress, "Not authorized");

        uint256 platformFee = (ticket.amount * FEE_PERCENTAGE) / 100;
        uint256 fulfillerAmount = ticket.amount - platformFee;

        // Update balances
        fulfillerBalances[ticket.fulfillerAddress] += fulfillerAmount;
        customerBalances[owner()] += platformFee;

        // Update ticket status
        ticket.isCompleted = true;
        ticket.completedAt = block.timestamp;

        // Update fulfiller stats
        fulfillers[ticket.fulfillerAddress].totalCompletedTickets++;
        fulfillers[ticket.fulfillerAddress].totalEarnings += fulfillerAmount;

        emit TicketCompleted(_ticketId, ticket.fulfillerAddress);
    }

    // Deposit tokens for a customer
    function deposit(uint256 _amount) external nonReentrant {
        require(_amount > 0, "Amount must be greater than 0");
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        
        customerBalances[msg.sender] += _amount;
        emit DepositReceived(msg.sender, _amount);
    }

    // Withdraw tokens for a fulfiller
    function withdraw(uint256 _amount) external nonReentrant {
        require(_amount > 0, "Amount must be greater than 0");
        require(fulfillerBalances[msg.sender] >= _amount, "Insufficient balance");
        
        fulfillerBalances[msg.sender] -= _amount;
        require(token.transfer(msg.sender, _amount), "Transfer failed");
        
        emit WithdrawalProcessed(msg.sender, _amount);
    }

    // Helper functions
    function getEligibleFulfillers(uint256[] memory _ticketIds) internal view returns (address[] memory) {
        address[] memory eligibleFulfillers = new address[](100); // Temporary size
        uint256 count = 0;

        for (uint i = 0; i < _ticketIds.length; i++) {
            string memory paymentMethod = tickets[_ticketIds[i]].paymentMethod;
            address[] memory methodFulfillers = paymentMethodToFulfillers[paymentMethod];
            
            for (uint j = 0; j < methodFulfillers.length; j++) {
                if (fulfillers[methodFulfillers[j]].isActive) {
                    eligibleFulfillers[count++] = methodFulfillers[j];
                }
            }
        }

        // Resize array to actual count
        address[] memory result = new address[](count);
        for (uint i = 0; i < count; i++) {
            result[i] = eligibleFulfillers[i];
        }
        return result;
    }

    function findEligibleFulfiller(
        string memory _paymentMethod,
        address[] memory _fulfillers
    ) internal view returns (address) {
        for (uint i = 0; i < _fulfillers.length; i++) {
            Fulfiller storage fulfiller = fulfillers[_fulfillers[i]];
            if (fulfiller.isActive) {
                for (uint j = 0; j < fulfiller.supportedPaymentMethods.length; j++) {
                    if (keccak256(bytes(fulfiller.supportedPaymentMethods[j])) == 
                        keccak256(bytes(_paymentMethod))) {
                        return _fulfillers[i];
                    }
                }
            }
        }
        return address(0);
    }

    // View functions
    function getFulfillerInfo(address _fulfiller) external view returns (Fulfiller memory) {
        return fulfillers[_fulfiller];
    }

    function getTicketInfo(uint256 _ticketId) external view returns (Ticket memory) {
        return tickets[_ticketId];
    }

    function getBatchInfo(uint256 _batchId) external view returns (Batch memory) {
        return batches[_batchId];
    }

    function getCustomerBalance(address _customer) external view returns (uint256) {
        return customerBalances[_customer];
    }

    function getFulfillerBalance(address _fulfiller) external view returns (uint256) {
        return fulfillerBalances[_fulfiller];
    }
} 