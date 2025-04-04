import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Wallet, WalletType } from './entities/wallet.entity';
import { ConnectWalletDto } from './dto/connect-wallet.dto';
import { TransactionDto } from './dto/transaction.dto';
import { UserRole } from '../auth/enums/user-role.enum';
import { Transaction } from './entities/transaction.entity';

@Injectable()
export class WalletService {
  constructor(
    @InjectRepository(Wallet)
    private walletRepository: Repository<Wallet>,
    @InjectRepository(Transaction)
    private transactionRepository: Repository<Transaction>,
  ) {}

  async connectWallet(
    userId: number,
    userRole: UserRole,
    connectWalletDto: ConnectWalletDto,
  ): Promise<Wallet> {
    const existingWallet = await this.walletRepository.findOne({
      where: {
        userId,
        type: connectWalletDto.type,
        address: connectWalletDto.walletAddress,
      },
    });

    if (!existingWallet) {
      throw new NotFoundException('Wallet not found');
    }

    return existingWallet;
  }

  async deposit(
    userId: number,
    userRole: UserRole,
    transactionDto: TransactionDto,
  ): Promise<Wallet> {
    const wallet = await this.walletRepository.findOne({
      where: {
        userId,
        type: transactionDto.type,
      },
    });

    if (!wallet) {
      throw new NotFoundException('Wallet not found');
    }

    // Only CUSTOMER and USER can deposit
    // if (userRole !== UserRole.CUSTOMER && userRole !== UserRole.USER) {
    //   throw new ForbiddenException('Only customers and users can deposit');
    // }

    wallet.balance = Number(wallet.balance) + Number(transactionDto.amount);

    // Save the updated wallet
    const updatedWallet = await this.walletRepository.save(wallet);

    // Create and save the transaction record
    const transaction = this.transactionRepository.create({
      user_id: userId,
      amount: transactionDto.amount,
      type: 'DEPOSIT',
      description: `Deposit to ${transactionDto.type} wallet`,
    });

    await this.transactionRepository.save(transaction);

    return updatedWallet;
  }

  async withdraw(
    userId: number,
    userRole: UserRole,
    transactionDto: TransactionDto,
  ): Promise<Wallet> {
    console.log('userId', userId);
    const wallet = await this.walletRepository.findOne({
      where: {
        // userId,
        type: transactionDto.type,
      },
    });

    console.log('wallet', wallet);
    if (!wallet) {
      throw new NotFoundException('Wallet not found');
    }

    // CUSTOMER, ADMIN, and FULFILLER can withdraw
    // if (
    //   userRole !== UserRole.CUSTOMER &&
    //   userRole !== UserRole.ADMIN &&
    //   userRole !== UserRole.FULFILLER
    // ) {
    //   throw new ForbiddenException(
    //     'Only customers, admins, and fulfillers can withdraw',
    //   );
    // }

    console.log('transactionDto', transactionDto);
    if (Number(wallet.balance) < Number(transactionDto.amount)) {
      throw new BadRequestException('Insufficient balance');
    }

    wallet.balance = Number(wallet.balance) - Number(transactionDto.amount);

    // Save the updated wallet
    const updatedWallet = await this.walletRepository.save(wallet);

    console.log('userId', userId);
    // Create and save the transaction record
    const transaction = this.transactionRepository.create({
      user_id: userId,
      amount: transactionDto.amount,
      type: 'WITHDRAWAL',
      description: `Withdrawal from ${transactionDto.type} wallet`,
    });

    await this.transactionRepository.save(transaction);

    return updatedWallet;
  }

  async getWallet(userId: number, type: WalletType): Promise<Wallet> {
    const wallet = await this.walletRepository.findOne({
      where: {
        userId,
        type,
      },
    });

    if (!wallet) {
      throw new NotFoundException('Wallet not found');
    }

    return wallet;
  }

  async getAllWallets(userId: number): Promise<Wallet[]> {
    return this.walletRepository.find({
      where: { userId },
    });
  }

  // Admin-specific methods
  async getAllWalletsForAdmin(): Promise<Wallet[]> {
    return this.walletRepository.find({
      relations: ['user'],
    });
  }

  async getBalance(userId: number, type: WalletType) {
    const wallet = await this.walletRepository.findOne({
      where: {
        userId,
        type,
      },
    });

    if (!wallet) {
      throw new NotFoundException(`Wallet of type ${type} not found`);
    }

    return {
      balance: wallet.balance,
      lastUpdated: wallet.updatedAt,
    };
  }
}
