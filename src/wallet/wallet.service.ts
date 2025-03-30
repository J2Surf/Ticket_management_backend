import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Wallet, WalletStatus, WalletType } from './entities/wallet.entity';
import { ConnectWalletDto } from './dto/connect-wallet.dto';
import { TransactionDto } from './dto/transaction.dto';
import { UserRole } from '../users/entities/user.entity';

@Injectable()
export class WalletService {
  constructor(
    @InjectRepository(Wallet)
    private walletRepository: Repository<Wallet>,
  ) {}

  async connectWallet(
    userId: string,
    userRole: UserRole,
    connectWalletDto: ConnectWalletDto,
  ): Promise<Wallet> {
    const existingWallet = await this.walletRepository.findOne({
      where: {
        userId,
        type: connectWalletDto.type,
      },
    });

    if (existingWallet) {
      throw new BadRequestException(
        'Wallet of this type already exists for the user',
      );
    }

    const wallet = this.walletRepository.create({
      userId,
      type: connectWalletDto.type,
      walletAddress: connectWalletDto.walletAddress,
      status: WalletStatus.ACTIVE,
      lastConnectedAt: new Date(),
    });

    return this.walletRepository.save(wallet);
  }

  async deposit(
    userId: string,
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

    if (wallet.status !== WalletStatus.ACTIVE) {
      throw new BadRequestException('Wallet is not active');
    }

    // Only CUSTOMER and ADMIN can deposit
    if (userRole !== UserRole.CUSTOMER && userRole !== UserRole.ADMIN) {
      throw new ForbiddenException('Only customers and admins can deposit');
    }

    wallet.balance = Number(wallet.balance) + Number(transactionDto.amount);
    return this.walletRepository.save(wallet);
  }

  async withdraw(
    userId: string,
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

    if (wallet.status !== WalletStatus.ACTIVE) {
      throw new BadRequestException('Wallet is not active');
    }

    // CUSTOMER, ADMIN, and FULFILLER can withdraw
    if (
      userRole !== UserRole.CUSTOMER &&
      userRole !== UserRole.ADMIN &&
      userRole !== UserRole.FULFILLER
    ) {
      throw new ForbiddenException(
        'Only customers, admins, and fulfillers can withdraw',
      );
    }

    if (Number(wallet.balance) < Number(transactionDto.amount)) {
      throw new BadRequestException('Insufficient balance');
    }

    wallet.balance = Number(wallet.balance) - Number(transactionDto.amount);
    return this.walletRepository.save(wallet);
  }

  async getWallet(userId: string, type: WalletType): Promise<Wallet> {
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

  async getAllWallets(userId: string): Promise<Wallet[]> {
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

  async updateWalletStatus(
    walletId: string,
    status: WalletStatus,
  ): Promise<Wallet> {
    const wallet = await this.walletRepository.findOne({
      where: { id: walletId },
    });

    if (!wallet) {
      throw new NotFoundException('Wallet not found');
    }

    wallet.status = status;
    return this.walletRepository.save(wallet);
  }
}
