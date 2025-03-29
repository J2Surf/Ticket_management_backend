import { Injectable, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Ticket, TicketStatus } from '../entities/ticket.entity';
import { Batch, BatchStatus } from '../entities/batch.entity';
import { BatchTicket } from '../entities/batch-ticket.entity';
import { Fulfiller } from '../entities/fulfiller.entity';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class BatchProcessingService {
  constructor(
    @InjectRepository(Ticket)
    private ticketRepository: Repository<Ticket>,
    @InjectRepository(Batch)
    private batchRepository: Repository<Batch>,
    @InjectRepository(BatchTicket)
    private batchTicketRepository: Repository<BatchTicket>,
    @InjectRepository(Fulfiller)
    private fulfillerRepository: Repository<Fulfiller>,
  ) {}

  async createBatch(paymentMethod: string): Promise<Batch> {
    // Get all active fulfillers that can handle this payment method
    const fulfillers = await this.fulfillerRepository.find({
      where: {
        status: 'active',
        payment_methods: paymentMethod,
      },
    });

    if (fulfillers.length === 0) {
      throw new BadRequestException(
        `No active fulfillers found for payment method: ${paymentMethod}`,
      );
    }

    // Get validated tickets for this payment method
    const tickets = await this.ticketRepository.find({
      where: {
        status: TicketStatus.VALIDATED,
        payment_method: paymentMethod,
      },
      order: {
        created_at: 'ASC',
      },
    });

    if (tickets.length === 0) {
      throw new BadRequestException(
        `No validated tickets found for payment method: ${paymentMethod}`,
      );
    }

    // Create a new batch
    const batch = new Batch();
    batch.batch_id = uuidv4();
    batch.status = BatchStatus.PENDING;
    batch.payment_method = paymentMethod;
    batch.total_tickets = tickets.length;
    batch.batch_amount = tickets.reduce(
      (sum, ticket) => sum + ticket.amount,
      0,
    );

    // Save the batch
    const savedBatch = await this.batchRepository.save(batch);

    // Assign tickets to fulfillers in a round-robin fashion
    const batchTickets = tickets.map((ticket, index) => {
      const fulfiller = fulfillers[index % fulfillers.length];
      const batchTicket = new BatchTicket();
      batchTicket.batch_id = savedBatch.id;
      batchTicket.ticket_id = ticket.id;
      batchTicket.amount = ticket.amount;
      batchTicket.status = 'pending';
      return batchTicket;
    });

    await this.batchTicketRepository.save(batchTickets);

    return savedBatch;
  }

  async getFulfillerBatches(fulfillerId: number): Promise<Batch[]> {
    return this.batchRepository.find({
      where: {
        fulfiller_id: fulfillerId,
        status: BatchStatus.PENDING,
      },
      relations: ['batchTickets'],
    });
  }

  async startBatchProcessing(
    batchId: number,
    fulfillerId: number,
  ): Promise<Batch> {
    const batch = await this.batchRepository.findOne({
      where: { id: batchId },
      relations: ['batchTickets'],
    });

    if (!batch) {
      throw new BadRequestException(`Batch with ID ${batchId} not found`);
    }

    if (batch.fulfiller_id !== fulfillerId) {
      throw new BadRequestException('This batch is not assigned to you');
    }

    if (batch.status !== BatchStatus.PENDING) {
      throw new BadRequestException('This batch is not in pending status');
    }

    batch.status = BatchStatus.PROCESSING;
    batch.processing_started_at = new Date();
    return this.batchRepository.save(batch);
  }

  async completeBatchTicket(
    batchId: number,
    ticketId: number,
    fulfillerId: number,
    paymentImageUrl: string,
  ): Promise<BatchTicket> {
    const batchTicket = await this.batchTicketRepository.findOne({
      where: {
        batch_id: batchId,
        ticket_id: ticketId,
      },
      relations: ['batch'],
    });

    if (!batchTicket) {
      throw new BadRequestException('Batch ticket not found');
    }

    if (batchTicket.batch.fulfiller_id !== fulfillerId) {
      throw new BadRequestException('This ticket is not assigned to you');
    }

    if (batchTicket.status !== 'pending') {
      throw new BadRequestException('This ticket is not in pending status');
    }

    // Update ticket status
    const ticket = await this.ticketRepository.findOne({
      where: { id: ticketId },
    });

    if (!ticket) {
      throw new BadRequestException('Ticket not found');
    }

    ticket.status = TicketStatus.COMPLETED;
    ticket.completed_at = new Date();
    ticket.completed_by = fulfillerId;
    ticket.image_path = paymentImageUrl;
    await this.ticketRepository.save(ticket);

    // Update batch ticket
    batchTicket.status = 'completed';
    batchTicket.completed_at = new Date();
    const completedBatchTicket =
      await this.batchTicketRepository.save(batchTicket);

    // Update batch completion count
    const batch = await this.batchRepository.findOne({
      where: { id: batchId },
      relations: ['batchTickets'],
    });

    if (!batch) {
      throw new BadRequestException('Batch not found');
    }

    batch.completed_tickets = batch.batchTickets.filter(
      (bt) => bt.status === 'completed',
    ).length;

    if (batch.completed_tickets === batch.total_tickets) {
      batch.status = BatchStatus.COMPLETED;
      batch.completed_at = new Date();
    }

    await this.batchRepository.save(batch);

    return completedBatchTicket;
  }

  async getFulfillerMetrics(fulfillerId: number): Promise<any> {
    const batches = await this.batchRepository.find({
      where: {
        fulfiller_id: fulfillerId,
        status: BatchStatus.COMPLETED,
      },
      relations: ['batchTickets'],
    });

    const metrics = {
      total_batches: batches.length,
      total_tickets: batches.reduce(
        (sum, batch) => sum + batch.total_tickets,
        0,
      ),
      completed_tickets: batches.reduce(
        (sum, batch) => sum + batch.completed_tickets,
        0,
      ),
      total_amount: batches.reduce((sum, batch) => sum + batch.batch_amount, 0),
      average_completion_time: 0,
      error_rate: 0,
    };

    // Calculate average completion time
    const completionTimes = batches.map((batch) => {
      const startTime = new Date(batch.processing_started_at).getTime();
      const endTime = new Date(batch.completed_at).getTime();
      return endTime - startTime;
    });

    if (completionTimes.length > 0) {
      metrics.average_completion_time =
        completionTimes.reduce((sum, time) => sum + time, 0) /
        completionTimes.length;
    }

    // Calculate error rate
    const totalErrors = batches.reduce((sum, batch) => {
      return (
        sum +
        batch.batchTickets.reduce(
          (ticketSum, ticket) => ticketSum + ticket.error_count,
          0,
        )
      );
    }, 0);

    const totalTickets = batches.reduce(
      (sum, batch) => sum + batch.total_tickets,
      0,
    );
    if (totalTickets > 0) {
      metrics.error_rate = (totalErrors / totalTickets) * 100;
    }

    return metrics;
  }
}
