import { Injectable } from '@nestjs/common';
import { ethers } from 'ethers';
import { ConfigService } from '@nestjs/config';
import { TicketManagement } from './TicketManagement';

@Injectable()
export class ContractService {
  private provider: ethers.providers.JsonRpcProvider;
  private contract: ethers.Contract;
  private wallet: ethers.Wallet;
  private readonly feePercentage: number;

  constructor(private configService: ConfigService) {
    const rpcUrl = this.configService.get<string>('ETHEREUM_RPC_URL');
    const contractAddress = this.configService.get<string>('CONTRACT_ADDRESS');
    const privateKey = this.configService.get<string>('PRIVATE_KEY');
    const tokenAddress = this.configService.get<string>(
      'CONTRACT_TOKEN_ADDRESS',
    );
    this.feePercentage =
      this.configService.get<number>('CONTRACT_FEE_PERCENTAGE') || 5;

    if (!rpcUrl || !contractAddress || !privateKey || !tokenAddress) {
      throw new Error('Missing required environment variables');
    }

    this.provider = new ethers.providers.JsonRpcProvider(rpcUrl);
    this.wallet = new ethers.Wallet(privateKey, this.provider);
    this.contract = new ethers.Contract(
      contractAddress,
      TicketManagement.abi,
      this.wallet,
    );
  }

  // Register a new fulfiller
  async registerFulfiller(
    accountAddress: string,
    supportedPaymentMethods: string[],
  ): Promise<ethers.ContractTransaction> {
    return this.contract.registerFulfiller(
      accountAddress,
      supportedPaymentMethods,
    );
  }

  // Create a new ticket
  async createTicket(
    customerAddress: string,
    amount: ethers.BigNumber,
    paymentMethod: string,
  ): Promise<ethers.ContractTransaction> {
    return this.contract.createTicket(customerAddress, amount, paymentMethod);
  }

  // Create a new batch of tickets
  async createBatch(ticketIds: number[]): Promise<ethers.ContractTransaction> {
    return this.contract.createBatch(ticketIds);
  }

  // Assign tickets to fulfillers
  async assignTickets(batchId: number): Promise<ethers.ContractTransaction> {
    return this.contract.assignTickets(batchId);
  }

  // Complete a ticket
  async completeTicket(ticketId: number): Promise<ethers.ContractTransaction> {
    return this.contract.completeTicket(ticketId);
  }

  // Deposit tokens for a customer
  async deposit(amount: ethers.BigNumber): Promise<ethers.ContractTransaction> {
    return this.contract.deposit(amount);
  }

  // Withdraw tokens for a fulfiller
  async withdraw(
    amount: ethers.BigNumber,
  ): Promise<ethers.ContractTransaction> {
    return this.contract.withdraw(amount);
  }

  // Get fulfiller information
  async getFulfillerInfo(fulfillerAddress: string): Promise<any> {
    return this.contract.getFulfillerInfo(fulfillerAddress);
  }

  // Get ticket information
  async getTicketInfo(ticketId: number): Promise<any> {
    return this.contract.getTicketInfo(ticketId);
  }

  // Get batch information
  async getBatchInfo(batchId: number): Promise<any> {
    return this.contract.getBatchInfo(batchId);
  }

  // Get customer balance
  async getCustomerBalance(customerAddress: string): Promise<ethers.BigNumber> {
    return this.contract.getCustomerBalance(customerAddress);
  }

  // Get fulfiller balance
  async getFulfillerBalance(
    fulfillerAddress: string,
  ): Promise<ethers.BigNumber> {
    return this.contract.getFulfillerBalance(fulfillerAddress);
  }

  // Helper function to convert ETH to Wei
  toWei(amount: string): ethers.BigNumber {
    return ethers.utils.parseEther(amount);
  }

  // Helper function to convert Wei to ETH
  fromWei(amount: ethers.BigNumber): string {
    return ethers.utils.formatEther(amount);
  }
}
