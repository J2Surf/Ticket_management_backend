import {
  Controller,
  Post,
  Body,
  Get,
  Param,
  UseGuards,
  Request,
  Query,
  BadRequestException,
  Patch,
} from '@nestjs/common';
import { WalletService } from './wallet.service';
import { ConnectWalletDto } from './dto/connect-wallet.dto';
import { TransactionDto } from './dto/transaction.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { WalletRoleGuard } from './guards/wallet-role.guard';
import { Roles } from './decorators/roles.decorator';
import { WalletType } from './entities/wallet.entity';
import { UserRole } from '../auth/enums/user-role.enum';
import { EthereumWalletDto } from './dto/ethereum-wallet.dto';
import {
  CryptoTransactionDto,
  TransactionType,
  TransactionStatus,
} from './dto/crypto-transaction.dto';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiQuery,
} from '@nestjs/swagger';

@ApiTags('wallet')
@ApiBearerAuth()
@Controller('wallet')
@UseGuards(JwtAuthGuard, WalletRoleGuard)
export class WalletController {
  constructor(private readonly walletService: WalletService) {}

  @Post('connect')
  @Roles(UserRole.USER, UserRole.ADMIN, UserRole.FULFILLER)
  @ApiOperation({ summary: 'Connect a new wallet' })
  @ApiResponse({
    status: 201,
    description: 'Wallet connected successfully',
    schema: {
      example: {
        id: 1,
        type: 'USDT',
        address: '0x123...abc',
        balance: 0.0,
        createdAt: '2024-02-20T10:00:00Z',
        updatedAt: '2024-02-20T10:00:00Z',
      },
    },
  })
  @ApiResponse({ status: 400, description: 'Invalid wallet data' })
  @ApiResponse({
    status: 403,
    description: 'Forbidden - Admin access required',
  })
  async connectWallet(
    @Request() req,
    @Body() connectWalletDto: ConnectWalletDto,
  ) {
    return await this.walletService.connectWallet(
      req.user.userId,
      req.user.role,
      connectWalletDto,
    );
  }

  @Post('deposit')
  @Roles(UserRole.USER)
  @ApiOperation({ summary: 'Deposit funds to wallet' })
  @ApiResponse({
    status: 201,
    description: 'Deposit successful',
    schema: {
      example: {
        id: 1,
        type: TransactionType.DEPOSIT,
        amount: 100.0,
        balance: 100.0,
        status: TransactionStatus.COMPLETED,
        token_type: 'USDT',
        reference_id: 'DEP-1234567890-abc123',
        timestamp: '2024-02-20T10:00:00Z',
      },
    },
  })
  @ApiResponse({ status: 400, description: 'Invalid transaction data' })
  @ApiResponse({
    status: 403,
    description: 'Forbidden - User access required',
  })
  async deposit(
    @Request() req,
    @Body() cryptoTransactionDto: CryptoTransactionDto,
  ) {
    console.log('deposit', req);

    // Set required fields for deposit
    cryptoTransactionDto.user_id = req.user.userId;
    cryptoTransactionDto.transaction_type = TransactionType.DEPOSIT;
    cryptoTransactionDto.status = TransactionStatus.COMPLETED;
    cryptoTransactionDto.reference_id = `DEP-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;

    return this.walletService.deposit(
      req.user.userId,
      req.user.role,
      cryptoTransactionDto,
    );
  }

  @Post('withdraw')
  @Roles(UserRole.USER, UserRole.FULFILLER)
  @ApiOperation({ summary: 'Withdraw funds from wallet' })
  @ApiResponse({
    status: 201,
    description: 'Withdrawal successful',
    schema: {
      example: {
        id: 1,
        type: TransactionType.WITHDRAW,
        amount: 50.0,
        balance: 50.0,
        status: TransactionStatus.COMPLETED,
        token_type: 'USDT',
        reference_id: 'WD-1234567890-abc123',
        timestamp: '2024-02-20T10:00:00Z',
      },
    },
  })
  @ApiResponse({ status: 400, description: 'Invalid transaction data' })
  @ApiResponse({
    status: 403,
    description: 'Forbidden - Insufficient permissions',
  })
  async withdraw(
    @Request() req,
    @Body() cryptoTransactionDto: CryptoTransactionDto,
  ) {
    // Set required fields for withdrawal
    cryptoTransactionDto.user_id = req.user.userId;
    cryptoTransactionDto.transaction_type = TransactionType.WITHDRAW;
    cryptoTransactionDto.status = TransactionStatus.PENDING;
    cryptoTransactionDto.reference_id = `WD-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;

    return this.walletService.withdraw(
      req.user.userId,
      req.user.role,
      cryptoTransactionDto,
    );
  }

  @Get('wallets')
  @Roles(UserRole.ADMIN, UserRole.FULFILLER, UserRole.USER)
  async getAllWallets(@Request() req) {
    if (req.user.role === UserRole.ADMIN) {
      return this.walletService.getAllWalletsForAdmin();
    }
    if (req.user.role === UserRole.FULFILLER) {
      return this.walletService.getAllWalletsForFulfiller();
    }

    return this.walletService.getAllWallets(req.user.userId);
  }

  @Get('wallets/admin')
  @Roles(UserRole.ADMIN, UserRole.USER, UserRole.FULFILLER)
  async getAllWalletsForAdmin(@Request() req) {
    return this.walletService.getAllWalletsForAdmin();
  }

  @Get('wallets/fulfiller')
  @Roles(UserRole.USER, UserRole.FULFILLER)
  async getAllWalletsForFulfiller(@Request() req) {
    console.log('getAllWalletsForFulfiller', req.user);
    return this.walletService.getAllWalletsForFulfiller();
  }

  @Get('wallets/user')
  @Roles(UserRole.USER, UserRole.FULFILLER)
  async getAllWalletsForUser(@Request() req) {
    console.log('getAllWalletsForUser', req.user);
    return this.walletService.getAllWalletsForUser();
  }

  @Get('transactions')
  @Roles(UserRole.USER, UserRole.ADMIN, UserRole.FULFILLER)
  @ApiOperation({ summary: 'Get crypto transactions for the user' })
  @ApiResponse({
    status: 200,
    description: 'Transactions retrieved successfully',
    schema: {
      example: {
        transactions: [
          {
            id: 1,
            type: 'DEPOSIT',
            amount: 100.5,
            description: 'Deposit to ETH wallet',
            reference_id: 'DEP-1234567890-abc123',
            created_at: '2024-02-20T10:00:00Z',
            status: 'COMPLETED',
            token_type: 'USDT',
            transaction_hash: '0x123...abc',
          },
        ],
      },
    },
  })
  async getTransactions(@Request() req) {
    console.log('getTransactions', req.user);
    return this.walletService.getTransactions(req.user.userId);
  }

  @Get(':type')
  async getWallet(@Request() req, @Param('type') type: WalletType) {
    return this.walletService.getWallet(req.user.userId, type);
  }

  @Get('balance/:type')
  @Roles(UserRole.USER, UserRole.ADMIN, UserRole.FULFILLER)
  @ApiOperation({ summary: 'Get wallet balance' })
  @ApiResponse({
    status: 200,
    description: 'Wallet balance retrieved successfully',
    schema: {
      example: {
        balance: 1000.0,
        lastUpdated: '2024-02-20T10:00:00Z',
      },
    },
  })
  @ApiResponse({ status: 404, description: 'Wallet not found' })
  async getBalance(@Request() req, @Param('type') type: WalletType) {
    try {
      console.log('getBalance called with:', {
        userId: req.user?.userId,
        type,
      });

      if (!req.user || !req.user.userId) {
        throw new BadRequestException('User information is missing');
      }

      if (!type) {
        throw new BadRequestException('Wallet type is required');
      }

      return await this.walletService.getBalance(req.user.userId, type);
    } catch (error) {
      console.error('Error in getBalance:', error);
      throw error;
    }
  }

  @Post('create/ethereum')
  @Roles(UserRole.USER, UserRole.ADMIN, UserRole.FULFILLER)
  @ApiOperation({ summary: 'Create a new Ethereum wallet' })
  @ApiResponse({
    status: 201,
    description: 'Ethereum wallet created successfully',
    type: EthereumWalletDto,
  })
  @ApiResponse({
    status: 400,
    description: 'User already has an Ethereum wallet',
  })
  @ApiResponse({
    status: 403,
    description: 'Forbidden - Insufficient permissions',
  })
  async createEthereumWallet(@Request() req): Promise<EthereumWalletDto> {
    return this.walletService.createEthereumWallet(req.user.userId);
  }

  @Get('private-key/:userId/:walletId')
  @Roles(UserRole.ADMIN, UserRole.FULFILLER)
  @ApiOperation({ summary: 'Get private key for Ethereum wallet' })
  @ApiResponse({
    status: 200,
    description: 'Private key retrieved successfully',
    schema: {
      example: {
        privateKey: '0x123...abc',
      },
    },
  })
  @ApiResponse({ status: 404, description: 'Wallet not found' })
  @ApiResponse({
    status: 403,
    description: 'Forbidden - Insufficient permissions',
  })
  async getPrivateKey(
    @Request() req,
    @Param('userId') userId: number,
    @Param('walletId') walletId: number,
  ) {
    const privateKey = await this.walletService.getPrivateKey(userId, walletId);
    return { privateKey };
  }

  @Get('public-key/:walletId')
  @Roles(UserRole.USER, UserRole.ADMIN, UserRole.FULFILLER)
  @ApiOperation({ summary: 'Get public key for Ethereum wallet' })
  @ApiResponse({
    status: 200,
    description: 'Public key retrieved successfully',
    schema: {
      example: {
        publicKey: '0x742d35Cc6634C0532925a3b844Bc454e4438f44e',
      },
    },
  })
  @ApiResponse({ status: 404, description: 'Wallet not found' })
  @ApiResponse({
    status: 403,
    description: 'Forbidden - Insufficient permissions',
  })
  async getPublicKey(@Request() req, @Param('walletId') walletId: number) {
    const publicKey = await this.walletService.getPublicKey(
      req.user.userId,
      walletId,
    );
    return { publicKey };
  }

  @Post('send')
  @Roles(UserRole.USER, UserRole.ADMIN, UserRole.FULFILLER)
  @ApiOperation({ summary: 'Send cryptocurrency to another address' })
  @ApiResponse({
    status: 201,
    description: 'Transaction sent successfully',
    schema: {
      example: {
        transaction_hash: '0x123...abc',
        status: TransactionStatus.COMPLETED,
      },
    },
  })
  @ApiResponse({ status: 400, description: 'Invalid transaction data' })
  @ApiResponse({
    status: 403,
    description: 'Forbidden - Insufficient permissions',
  })
  async sendTransaction(
    @Request() req,
    @Body()
    sendTransactionDto: CryptoTransactionDto,
  ) {
    // Validate the request
    if (
      !sendTransactionDto.address_from ||
      !sendTransactionDto.address_to ||
      !sendTransactionDto.user_id_from ||
      !sendTransactionDto.user_id_to ||
      !sendTransactionDto.amount
    ) {
      throw new BadRequestException(
        'Missing required fields: from_wallet_id, to_address, amount',
      );
    }

    // Call the service to send the transaction
    return this.walletService.sendTransaction(
      req.user.userId,
      req.user.role,
      sendTransactionDto,
    );
  }

  @Patch('transactions/:id')
  @Roles(UserRole.USER, UserRole.ADMIN, UserRole.FULFILLER)
  @ApiOperation({ summary: 'Update a transaction' })
  @ApiResponse({
    status: 200,
    description: 'Transaction updated successfully',
  })
  @ApiResponse({ status: 400, description: 'Invalid transaction data' })
  @ApiResponse({
    status: 403,
    description: 'Forbidden - Insufficient permissions',
  })
  async updateTransaction(
    @Request() req,
    @Param('id') id: number,
    @Body() updateData: Partial<CryptoTransactionDto>,
  ) {
    return this.walletService.updateTransaction(
      req.user.userId,
      id,
      updateData,
    );
  }
}
