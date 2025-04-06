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
    return this.walletService.connectWallet(
      req.user.userId,
      req.user.role,
      connectWalletDto,
    );
  }

  @Post('deposit')
  @Roles(UserRole.CUSTOMER, UserRole.USER)
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
    console.log('deposit', req.user);

    // Set required fields for deposit
    cryptoTransactionDto.user_id = req.user.userId;
    cryptoTransactionDto.user_id_from = req.user.userId;
    cryptoTransactionDto.type = TransactionType.DEPOSIT;
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
        type: TransactionType.WITHDRAWAL,
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
    console.log('withdraw', req.user);

    // Set required fields for withdrawal
    cryptoTransactionDto.user_id = req.user.userId;
    cryptoTransactionDto.type = TransactionType.WITHDRAWAL;
    cryptoTransactionDto.status = TransactionStatus.COMPLETED;
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
    console.log('getAllWallets', req.user);
    if (req.user.role === UserRole.ADMIN) {
      return this.walletService.getAllWalletsForAdmin();
    }
    if (req.user.role === UserRole.FULFILLER) {
      return this.walletService.getAllWalletsForFulfiller();
    }

    console.log('getAllWallets', req.user.userId);
    return this.walletService.getAllWallets(req.user.userId);
  }

  @Get('wallets/admin')
  @Roles(UserRole.ADMIN)
  async getAllWalletsForAdmin(@Request() req) {
    console.log('getAllWalletsForAdmin', req.user);
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

  @Get(':type')
  async getWallet(@Request() req, @Param('type') type: WalletType) {
    return this.walletService.getWallet(req.user.userId, type);
  }

  @Get('balance/:type')
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
  getBalance(@Request() req, @Param('type') type: WalletType) {
    console.log('getBalance called with:', {
      userId: req.user?.id,
      type,
    });

    return this.walletService.getBalance(req.user.userId, type);
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

  @Get('private-key/:walletId')
  @Roles(UserRole.USER, UserRole.ADMIN, UserRole.FULFILLER)
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
  async getPrivateKey(@Request() req, @Param('walletId') walletId: number) {
    const privateKey = await this.walletService.getPrivateKey(
      req.user.userId,
      walletId,
    );
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
}
