import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import { DashboardService } from './dashboard.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { WalletRoleGuard } from '../wallet/guards/wallet-role.guard';
import { Roles } from '../wallet/decorators/roles.decorator';
import { UserRole } from '../auth/enums/user-role.enum';
import { ConnectWalletDto } from '../wallet/dto/connect-wallet.dto';
import { TransactionDto } from '../wallet/dto/transaction.dto';
import { WalletType } from '../wallet/entities/wallet.entity';

@Controller('dashboard')
@UseGuards(JwtAuthGuard, WalletRoleGuard)
export class DashboardController {
  constructor(private readonly dashboardService: DashboardService) {}

  @Get('customer')
  @Roles(UserRole.CUSTOMER)
  async getCustomerDashboard(@Request() req) {
    return this.dashboardService.getCustomerDashboard(req.user.userId);
  }

  @Get('fulfiller')
  @Roles(UserRole.FULFILLER)
  async getFulfillerDashboard(@Request() req) {
    return this.dashboardService.getFulfillerDashboard(req.user.userId);
  }

  // Wallet-related endpoints
  @Post('wallet/connect')
  @Roles(UserRole.CUSTOMER, UserRole.FULFILLER)
  async connectWallet(
    @Request() req,
    @Body() connectWalletDto: ConnectWalletDto,
  ) {
    return this.dashboardService.connectWallet(
      req.user.userId,
      connectWalletDto,
    );
  }

  @Post('wallet/deposit')
  @Roles(UserRole.CUSTOMER)
  async deposit(@Request() req, @Body() transactionDto: TransactionDto) {
    return this.dashboardService.deposit(req.user.userId, transactionDto);
  }

  @Post('wallet/withdraw')
  @Roles(UserRole.FULFILLER)
  async withdraw(@Request() req, @Body() transactionDto: TransactionDto) {
    return this.dashboardService.withdraw(req.user.userId, transactionDto);
  }

  @Get('wallet/balance/:type')
  @Roles(UserRole.CUSTOMER, UserRole.FULFILLER)
  async getWalletBalance(@Request() req, @Param('type') type: WalletType) {
    return this.dashboardService.getWalletBalance(req.user.userId, type);
  }
}
