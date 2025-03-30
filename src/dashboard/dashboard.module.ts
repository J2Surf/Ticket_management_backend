import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DashboardController } from './dashboard.controller';
import { DashboardService } from './dashboard.service';
import { Ticket } from '../tickets/entities/ticket.entity';
import { Wallet } from '../wallet/entities/wallet.entity';
import { User } from '../users/entities/user.entity';
import { ContractModule } from '../contracts/contract.module';

@Module({
  imports: [TypeOrmModule.forFeature([Ticket, Wallet, User]), ContractModule],
  controllers: [DashboardController],
  providers: [DashboardService],
  exports: [DashboardService],
})
export class DashboardModule {}
