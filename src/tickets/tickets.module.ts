import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TicketsService } from './tickets.service';
import { TicketsController } from './tickets.controller';
import { Ticket } from './entities/ticket.entity';
import { User } from '../users/entities/user.entity';
import { FormGameOption } from './entities/form-game-option.entity';
import { FormPaymentMethod } from './entities/form-payment-method.entity';
import { FormSubmission } from './entities/form-submission.entity';
import { Fulfiller } from './entities/fulfiller.entity';
import { Permission } from './entities/permission.entity';
import { Transaction } from './entities/transaction.entity';
import { Batch } from './entities/batch.entity';
import { BatchTicket } from './entities/batch-ticket.entity';
import { BatchProcessingService } from './services/batch-processing.service';
import { BatchProcessingController } from './controllers/batch-processing.controller';
import { AuthModule } from '../auth/auth.module';
import { JwtService } from '@nestjs/jwt';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Ticket,
      User,
      FormGameOption,
      FormPaymentMethod,
      FormSubmission,
      Fulfiller,
      Permission,
      Transaction,
      Batch,
      BatchTicket,
    ]),
    AuthModule,
  ],
  controllers: [TicketsController, BatchProcessingController],
  providers: [TicketsService, BatchProcessingService, JwtService],
  exports: [TicketsService, BatchProcessingService],
})
export class TicketsModule {}
