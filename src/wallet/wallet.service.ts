import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import {
  Wallet,
  WalletType,
  WalletStatus,
  TokenType,
} from './entities/wallet.entity';
import { ConnectWalletDto } from './dto/connect-wallet.dto';
import { TransactionDto } from './dto/transaction.dto';
import { UserRole } from '../auth/enums/user-role.enum';
import { Transaction } from './entities/transaction.entity';
import { CryptoTransaction } from './entities/crypto-transaction.entity';
import {
  CryptoTransactionDto,
  TransactionType,
  TransactionStatus,
} from './dto/crypto-transaction.dto';
import { ethers } from 'ethers';
import { EthereumWalletDto } from './dto/ethereum-wallet.dto';
import * as crypto from 'crypto';

@Injectable()
export class WalletService {
  constructor(
    @InjectRepository(Wallet)
    private walletRepository: Repository<Wallet>,
    @InjectRepository(Transaction)
    private transactionRepository: Repository<Transaction>,
    @InjectRepository(CryptoTransaction)
    private cryptoTransactionRepository: Repository<CryptoTransaction>,
  ) {}

  async createEthereumWallet(userId: number): Promise<EthereumWalletDto> {
    console.log('createEthereumWallet userId', userId);
    // Check if user already has an ETH wallet
    const existingWallet = await this.walletRepository.findOne({
      where: {
        userId,
        type: WalletType.ETH,
      },
    });

    if (existingWallet) {
      throw new BadRequestException('User already has an Ethereum wallet');
    }

    // Generate a new Ethereum wallet using ethers.js
    const wallet = ethers.Wallet.createRandom();
    console.log('createEthereumWallet wallet', wallet);

    // Encrypt the private key before storing
    const encryptedPrivateKey = this.encryptPrivateKey(wallet.privateKey);

    // Create a new wallet entity
    const newWallet = this.walletRepository.create({
      userId,
      type: WalletType.ETH,
      tokenType: TokenType.USDT,
      address: wallet.address,
      balance: 0,
      status: WalletStatus.ACTIVE,
      lastConnectedAt: new Date(),
      privateKey: encryptedPrivateKey, // Store encrypted private key
    });

    // Save the wallet to the database
    const savedWallet = await this.walletRepository.save(newWallet);

    // Return the wallet with the private key as EthereumWalletDto
    const ethereumWalletDto: EthereumWalletDto = {
      id: savedWallet.id,
      type: savedWallet.type,
      address: savedWallet.address,
      balance: savedWallet.balance,
      // privateKey: wallet.privateKey, // Return the original private key only during creation
      createdAt: savedWallet.createdAt,
      updatedAt: savedWallet.updatedAt,
    };

    return ethereumWalletDto;
  }

  // Method to retrieve the private key for a wallet
  async getPrivateKey(userId: number, walletId: number): Promise<string> {
    const wallet = await this.walletRepository.findOne({
      where: {
        id: walletId,
        userId,
        type: WalletType.ETH,
      },
    });

    if (!wallet) {
      throw new NotFoundException('Ethereum wallet not found');
    }

    if (!wallet.privateKey) {
      throw new BadRequestException(
        'Private key not available for this wallet',
      );
    }

    // Decrypt the private key
    return this.decryptPrivateKey(wallet.privateKey);
  }

  async getPublicKey(userId: number, walletId: number): Promise<string> {
    const wallet = await this.walletRepository.findOne({
      where: {
        id: walletId,
        userId,
        type: WalletType.ETH,
      },
    });

    if (!wallet) {
      throw new NotFoundException('Ethereum wallet not found');
    }

    // For Ethereum, the public key is the same as the address
    return wallet.address;
  }

  // Helper method to encrypt private key
  private encryptPrivateKey(privateKey: string): string {
    // In a production environment, use a secure key management service
    // This is a simplified example using a fixed encryption key
    const encryptionKey = process.env.ENCRYPTION_KEY;

    console.log('encryptPrivateKey privateKey', privateKey);
    console.log('encryptPrivateKey encryptionKey', encryptionKey);
    if (!encryptionKey) {
      throw new Error('ENCRYPTION_KEY environment variable is not set');
    }

    // Convert base64 key to Buffer and ensure it's exactly 32 bytes
    const keyBuffer = Buffer.from(encryptionKey, 'base64');
    if (keyBuffer.length !== 32) {
      throw new Error(
        'Encryption key must be exactly 32 bytes when decoded from base64',
      );
    }

    const iv = crypto.randomBytes(16);
    const cipher = crypto.createCipheriv('aes-256-gcm', keyBuffer, iv);

    let encrypted = cipher.update(privateKey, 'utf8', 'base64');
    encrypted += cipher.final('base64');

    const authTag = cipher.getAuthTag();

    // Return IV, encrypted data, and auth tag as a single string
    return `${iv.toString('base64')}:${encrypted}:${authTag.toString('base64')}`;
  }

  // Helper method to decrypt private key
  private decryptPrivateKey(encryptedData: string): string {
    const encryptionKey = process.env.ENCRYPTION_KEY;

    if (!encryptionKey) {
      throw new Error('ENCRYPTION_KEY environment variable is not set');
    }

    const [ivBase64, encrypted, authTagBase64] = encryptedData.split(':');
    const iv = Buffer.from(ivBase64, 'base64');
    const authTag = Buffer.from(authTagBase64, 'base64');
    const keyBuffer = Buffer.from(encryptionKey, 'base64');

    const decipher = crypto.createDecipheriv('aes-256-gcm', keyBuffer, iv);
    decipher.setAuthTag(authTag);

    let decrypted = decipher.update(encrypted, 'base64', 'utf8');
    decrypted += decipher.final('utf8');

    return decrypted;
  }

  async connectWallet(
    userId: number,
    userRole: UserRole,
    connectWalletDto: ConnectWalletDto,
  ): Promise<Wallet> {
    // Check if wallet already exists
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
    cryptoTransactionDto: CryptoTransactionDto,
  ): Promise<Wallet> {
    const wallet = await this.walletRepository.findOne({
      where: {
        userId,
        type: WalletType.ETH, // Assuming ETH wallet type for crypto transactions
        tokenType: cryptoTransactionDto.token_type,
      },
    });

    if (!wallet) {
      throw new NotFoundException('Wallet not found');
    }

    // Start a transaction
    const queryRunner =
      this.walletRepository.manager.connection.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // Update wallet balance
      wallet.balance =
        Number(wallet.balance) + Number(cryptoTransactionDto.amount);
      const updatedWallet = await queryRunner.manager.save(wallet);

      // Create and save the crypto transaction record
      const cryptoTransaction =
        this.cryptoTransactionRepository.create(cryptoTransactionDto);
      await queryRunner.manager.save(cryptoTransaction);

      // Commit the transaction
      await queryRunner.commitTransaction();
      return updatedWallet;
    } catch (error) {
      // Rollback the transaction in case of error
      await queryRunner.rollbackTransaction();
      throw error;
    } finally {
      // Release the query runner
      await queryRunner.release();
    }
  }

  async withdraw(
    userId: number,
    userRole: UserRole,
    cryptoTransactionDto: CryptoTransactionDto,
  ): Promise<Wallet> {
    const wallet = await this.walletRepository.findOne({
      where: {
        userId,
        type: WalletType.ETH, // Assuming ETH wallet type for crypto transactions
        tokenType: cryptoTransactionDto.token_type,
      },
    });

    if (!wallet) {
      throw new NotFoundException('Wallet not found');
    }

    if (Number(wallet.balance) < Number(cryptoTransactionDto.amount)) {
      throw new BadRequestException('Insufficient balance');
    }

    // Start a transaction
    const queryRunner =
      this.walletRepository.manager.connection.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // Update wallet balance
      wallet.balance =
        Number(wallet.balance) - Number(cryptoTransactionDto.amount);
      const updatedWallet = await queryRunner.manager.save(wallet);

      // Create and save the crypto transaction record
      const cryptoTransaction =
        this.cryptoTransactionRepository.create(cryptoTransactionDto);
      await queryRunner.manager.save(cryptoTransaction);

      // Commit the transaction
      await queryRunner.commitTransaction();
      return updatedWallet;
    } catch (error) {
      // Rollback the transaction in case of error
      await queryRunner.rollbackTransaction();
      throw error;
    } finally {
      // Release the query runner
      await queryRunner.release();
    }
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
    return this.walletRepository
      .createQueryBuilder('wallet')
      .innerJoin('wallet.user', 'user')
      .innerJoin('user.roles', 'role')
      .where('role.id = :roleId', { roleId: 2 })
      .getMany();
  }

  async getAllWalletsForFulfiller(): Promise<Wallet[]> {
    return this.walletRepository
      .createQueryBuilder('wallet')
      .innerJoin('wallet.user', 'user')
      .innerJoin('user.roles', 'role')
      .where('role.id = :roleId', { roleId: 3 })
      .getMany();
  }

  async getAllWalletsForUser(): Promise<Wallet[]> {
    return this.walletRepository
      .createQueryBuilder('wallet')
      .innerJoin('wallet.user', 'user')
      .innerJoin('user.roles', 'role')
      .where('role.id = :roleId', { roleId: 4 })
      .getMany();
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
