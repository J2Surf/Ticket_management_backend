import { ethers } from 'ethers';

export const TicketManagement = {
  abi: [
    // Add your contract ABI here
    'function registerFulfiller(address accountAddress, string[] memory supportedPaymentMethods) external',
    'function createTicket(address customerAddress, uint256 amount, string memory paymentMethod) external returns (uint256)',
    'function createBatch(uint256[] memory ticketIds) external returns (uint256)',
    'function assignTickets(uint256 batchId) external',
    'function completeTicket(uint256 ticketId) external',
    'function deposit(uint256 amount) external',
    'function withdraw(uint256 amount) external',
    'function getFulfillerInfo(address fulfillerAddress) external view returns (tuple(address accountAddress, string[] supportedPaymentMethods, uint256 totalCompletedTickets, uint256 totalEarnings, bool isActive))',
    'function getTicketInfo(uint256 ticketId) external view returns (tuple(uint256 id, address customerAddress, address fulfillerAddress, uint256 amount, string paymentMethod, bool isCompleted, uint256 createdAt, uint256 completedAt))',
    'function getBatchInfo(uint256 batchId) external view returns (tuple(uint256 id, address[] fulfillers, uint256[] ticketIds, uint256 totalAmount, bool isActive))',
    'function getCustomerBalance(address customerAddress) external view returns (uint256)',
    'function getFulfillerBalance(address fulfillerAddress) external view returns (uint256)',
  ],
};
