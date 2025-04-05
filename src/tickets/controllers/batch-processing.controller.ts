import {
  Controller,
  Post,
  Get,
  Body,
  Param,
  UseGuards,
  Req,
} from '@nestjs/common';
import { BatchProcessingService } from '../services/batch-processing.service';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { Roles } from '../../auth/decorators/roles.decorator';
import { UserRole } from '../../auth/enums/user-role.enum';

@Controller('batch-processing')
@UseGuards(JwtAuthGuard, RolesGuard)
export class BatchProcessingController {
  constructor(
    private readonly batchProcessingService: BatchProcessingService,
  ) {}

  @Post('create')
  @Roles(UserRole.ADMIN)
  async createBatch(@Body('paymentMethod') paymentMethod: string) {
    return this.batchProcessingService.createBatch(paymentMethod);
  }

  @Get('fulfiller/:fulfillerId/batches')
  @Roles(UserRole.FULFILLER)
  async getFulfillerBatches(@Param('fulfillerId') fulfillerId: string) {
    return this.batchProcessingService.getFulfillerBatches(Number(fulfillerId));
  }

  @Post('batch/:batchId/start')
  @Roles(UserRole.FULFILLER)
  async startBatchProcessing(@Param('batchId') batchId: string, @Req() req) {
    return this.batchProcessingService.startBatchProcessing(
      Number(batchId),
      req.user.userId,
    );
  }

  @Post('batch/:batchId/ticket/:ticketId/complete')
  @Roles(UserRole.FULFILLER)
  async completeBatchTicket(
    @Param('batchId') batchId: string,
    @Param('ticketId') ticketId: string,
    @Body('paymentImageUrl') paymentImageUrl: string,
    @Req() req,
  ) {
    return this.batchProcessingService.completeBatchTicket(
      Number(batchId),
      Number(ticketId),
      req.user.userId,
      paymentImageUrl,
    );
  }

  @Get('fulfiller/:fulfillerId/metrics')
  @Roles(UserRole.FULFILLER)
  async getFulfillerMetrics(@Param('fulfillerId') fulfillerId: string) {
    return this.batchProcessingService.getFulfillerMetrics(Number(fulfillerId));
  }
}
