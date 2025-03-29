import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Ticket, TicketStatus } from './entities/ticket.entity';
import {
  FormSubmission,
  FormSubmissionStatus,
} from './entities/form-submission.entity';
import { Transaction, TransactionType } from './entities/transaction.entity';
import { User } from '../users/entities/user.entity';
import { CreateTicketDto } from './dto/create-ticket.dto';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class TicketsService {
  constructor(
    @InjectRepository(Ticket)
    private ticketRepository: Repository<Ticket>,
    @InjectRepository(FormSubmission)
    private formSubmissionRepository: Repository<FormSubmission>,
    @InjectRepository(Transaction)
    private transactionRepository: Repository<Transaction>,
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  async create(
    createTicketDto: CreateTicketDto,
    customer: User,
    client: User,
  ): Promise<Ticket> {
    // Create form submission
    const formSubmission = new FormSubmission();
    formSubmission.amount = createTicketDto.amount;
    formSubmission.game = createTicketDto.game;
    formSubmission.game_id = createTicketDto.game_id;
    formSubmission.facebook_name = createTicketDto.facebook_name;
    formSubmission.transaction_number = uuidv4();
    formSubmission.group_id = Number(client.id);
    formSubmission.status = FormSubmissionStatus.PENDING_VALIDATION;
    formSubmission.created_at = new Date();
    await this.formSubmissionRepository.save(formSubmission);

    // Create ticket
    const ticket = new Ticket();
    ticket.domain_id = Number(client.id);
    ticket.facebook_name = createTicketDto.facebook_name;
    ticket.ticket_id = formSubmission.transaction_number;
    ticket.user_id = Number(customer.id);
    ticket.payment_method = createTicketDto.payment_method;
    ticket.payment_tag = createTicketDto.payment_tag;
    ticket.account_name = createTicketDto.account_name;
    ticket.amount = createTicketDto.amount;
    ticket.game = createTicketDto.game;
    ticket.game_id = createTicketDto.game_id;
    ticket.image_path = createTicketDto.payment_qr_code;
    ticket.status = TicketStatus.NEW;
    ticket.chat_group_id = client.id.toString();

    return this.ticketRepository.save(ticket);
  }

  async findAll(): Promise<Ticket[]> {
    return this.ticketRepository.find();
  }

  async findOne(id: string): Promise<Ticket> {
    // Try to find by numeric ID first
    const ticketById = await this.ticketRepository.findOne({
      where: { id: Number(id) },
    });
    if (!ticketById) {
      throw new NotFoundException(`Ticket with ID ${id} not found`);
    }

    return ticketById;
  }

  async validateTicket(id: string, client: User): Promise<Ticket> {
    const ticket = await this.findOne(id);
    if (ticket.status !== TicketStatus.NEW) {
      throw new BadRequestException('Ticket is not in new status');
    }

    // Update form submission
    const formSubmission = await this.formSubmissionRepository.findOne({
      where: { transaction_number: ticket.ticket_id },
    });
    if (formSubmission) {
      formSubmission.status = FormSubmissionStatus.VALIDATED;
      formSubmission.validator_id = Number(client.id);
      formSubmission.validated_at = new Date();
      await this.formSubmissionRepository.save(formSubmission);
    }

    // Update ticket
    ticket.status = TicketStatus.VALIDATED;
    return this.ticketRepository.save(ticket);
  }

  async declineTicket(id: string, client: User): Promise<Ticket> {
    const ticket = await this.findOne(id);
    if (ticket.status !== TicketStatus.NEW) {
      throw new BadRequestException('Ticket is not in new status');
    }

    // Update form submission
    const formSubmission = await this.formSubmissionRepository.findOne({
      where: { transaction_number: ticket.ticket_id },
    });
    if (formSubmission) {
      formSubmission.status = FormSubmissionStatus.DECLINED;
      formSubmission.validator_id = Number(client.id);
      formSubmission.validated_at = new Date();
      await this.formSubmissionRepository.save(formSubmission);
    }

    // Update ticket
    ticket.status = TicketStatus.DECLINED;
    return this.ticketRepository.save(ticket);
  }

  async completeTicket(
    id: string,
    fulfiller: User,
    paymentImageUrl: string,
    transactionId: string,
  ): Promise<Ticket> {
    const ticket = await this.findOne(id);
    if (ticket.status !== TicketStatus.VALIDATED) {
      throw new BadRequestException(
        'Ticket must be validated before completion',
      );
    }

    console.log('completeTicket', ticket);

    // Calculate fees
    const fulfillerFee = ticket.amount * 0.03; // 3% for fulfiller
    const ownerFee = ticket.amount * 0.01; // 1% for owner

    // Create transactions
    const transactions = [
      {
        user_id: Number(id),
        amount: ticket.amount,
        transaction_type: TransactionType.CREDIT,
        description: 'Ticket completion payment',
        reference_id: ticket.ticket_id,
      },
      {
        user_id: Number(fulfiller.id),
        amount: fulfillerFee,
        transaction_type: TransactionType.CREDIT,
        description: 'Fulfiller fee',
        reference_id: ticket.ticket_id,
      },
      {
        user_id: Number(ticket.user_id),
        amount: ownerFee,
        transaction_type: TransactionType.FEE,
        description: 'Owner fee',
        reference_id: ticket.ticket_id,
      },
    ];

    await this.transactionRepository.save(transactions);

    // Update form submission
    const formSubmission = await this.formSubmissionRepository.findOne({
      where: { transaction_number: ticket.ticket_id },
    });
    if (formSubmission) {
      formSubmission.status = FormSubmissionStatus.COMPLETED;
      formSubmission.fulfiller_id = Number(fulfiller.id);
      formSubmission.completed_at = new Date();
      await this.formSubmissionRepository.save(formSubmission);
    }

    // Update ticket
    ticket.status = TicketStatus.COMPLETED;
    ticket.completed_at = new Date();
    ticket.completed_by = Number(fulfiller.id);
    ticket.image_path = paymentImageUrl;
    return this.ticketRepository.save(ticket);
  }

  async getTicketsByStatus(status: TicketStatus): Promise<Ticket[]> {
    return this.ticketRepository.find({
      where: { status },
    });
  }

  async getTicketsByUser(userId: number, role: string): Promise<Ticket[]> {
    const where = {};
    switch (role) {
      case 'CUSTOMER':
        where['user_id'] = userId;
        break;
      case 'USER':
        where['domain_id'] = userId;
        break;
      case 'FULFILLER':
        where['completed_by'] = userId;
        break;
      default:
        throw new BadRequestException('Invalid role');
    }
    return this.ticketRepository.find({ where });
  }
}
