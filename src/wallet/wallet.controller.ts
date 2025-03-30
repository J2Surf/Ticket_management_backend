import {
  Controller,
  Post,
  Body,
  Get,
  Param,
  UseGuards,
  Request,
  Patch,
} from '@nestjs/common';
import { WalletService } from './wallet.service';
import { ConnectWalletDto } from './dto/connect-wallet.dto';
import { TransactionDto } from './dto/transaction.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { WalletRoleGuard } from './guards/wallet-role.guard';
import { Roles } from './decorators/roles.decorator';
import { WalletType, WalletStatus } from './entities/wallet.entity';
import { UserRole } from '../users/entities/user.entity';

@Controller('wallet')
@UseGuards(JwtAuthGuard, WalletRoleGuard)
export class WalletController {
  constructor(private readonly walletService: WalletService) {}

  @Post('connect')
  @Roles(UserRole.CUSTOMER, UserRole.ADMIN, UserRole.FULFILLER)
  async connectWallet(
    @Request() req,
    @Body() connectWalletDto: ConnectWalletDto,
  ) {
    return this.walletService.connectWallet(
      req.user.id,
      req.user.role,
      connectWalletDto,
    );
  }

  @Post('deposit')
  @Roles(UserRole.CUSTOMER, UserRole.ADMIN)
  async deposit(@Request() req, @Body() transactionDto: TransactionDto) {
    return this.walletService.deposit(
      req.user.id,
      req.user.role,
      transactionDto,
    );
  }

  @Post('withdraw')
  @Roles(UserRole.CUSTOMER, UserRole.ADMIN, UserRole.FULFILLER)
  async withdraw(@Request() req, @Body() transactionDto: TransactionDto) {
    return this.walletService.withdraw(
      req.user.id,
      req.user.role,
      transactionDto,
    );
  }

  @Get()
  async getAllWallets(@Request() req) {
    if (req.user.role === UserRole.ADMIN) {
      return this.walletService.getAllWalletsForAdmin();
    }
    return this.walletService.getAllWallets(req.user.id);
  }

  @Get(':type')
  async getWallet(@Request() req, @Param('type') type: WalletType) {
    return this.walletService.getWallet(req.user.id, type);
  }

  // Admin-only endpoints
  @Patch(':id/status')
  @Roles(UserRole.ADMIN)
  async updateWalletStatus(
    @Param('id') id: string,
    @Body('status') status: WalletStatus,
  ) {
    return this.walletService.updateWalletStatus(id, status);
  }
}
