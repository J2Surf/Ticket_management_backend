import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Request,
  Put,
} from '@nestjs/common';
import { TicketsService } from './tickets.service';
import { CreateTicketDto } from './dto/create-ticket.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { UserRole } from '../users/entities/user.entity';
import { TicketStatus } from './entities/ticket.entity';

@Controller('tickets')
@UseGuards(JwtAuthGuard, RolesGuard)
export class TicketsController {
  constructor(private readonly ticketsService: TicketsService) {}

  @Post()
  // @Roles(UserRole.CUSTOMER)
  async create(@Body() createTicketDto: CreateTicketDto, @Request() req) {
    // In a real application, you would get the client ID from the request or based on some business logic
    const clientId = req.body.clientId; // This should be validated and secured
    return this.ticketsService.create(createTicketDto, req.user, {
      id: clientId,
    } as any);
  }

  @Get()
  @Roles(UserRole.ADMIN)
  findAll() {
    return this.ticketsService.findAll();
  }

  @Get(':id')
  @Roles(UserRole.ADMIN, UserRole.USER, UserRole.FULFILLER)
  findOne(@Param('id') id: string) {
    console.log('findOne', id);
    return this.ticketsService.findOne(id);
  }

  @Put(':id/validate')
  @Roles(UserRole.USER)
  validateTicket(@Param('id') id: string, @Request() req) {
    return this.ticketsService.validateTicket(id, req.user);
  }

  @Put(':id/decline')
  @Roles(UserRole.USER)
  declineTicket(@Param('id') id: string, @Request() req) {
    return this.ticketsService.declineTicket(id, req.user);
  }

  @Put(':id/complete')
  @Roles(UserRole.FULFILLER)
  completeTicket(
    @Param('id') id: string,
    @Request() req,
    @Body() body: { paymentImageUrl: string; transactionId: string },
  ) {
    return this.ticketsService.completeTicket(
      id,
      req.user,
      body.paymentImageUrl,
      body.transactionId,
    );
  }

  @Get('status/:status')
  @Roles(UserRole.ADMIN, UserRole.USER, UserRole.FULFILLER)
  getTicketsByStatus(@Param('status') status: TicketStatus) {
    return this.ticketsService.getTicketsByStatus(status);
  }

  @Get('user/:userId')
  @Roles(UserRole.ADMIN)
  getTicketsByUser(
    @Param('userId') userId: string,
    @Body() body: { role: string },
  ) {
    return this.ticketsService.getTicketsByUser(Number(userId), body.role);
  }
}
