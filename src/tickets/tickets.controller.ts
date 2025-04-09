import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Request,
  Put,
  Query,
} from '@nestjs/common';
import { TicketsService } from './tickets.service';
import { CreateTicketDto } from './dto/create-ticket.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { UserRole } from '../auth/enums/user-role.enum';
import { TicketStatus } from './entities/ticket.entity';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiQuery,
  ApiParam,
  ApiBody,
} from '@nestjs/swagger';

@ApiTags('tickets')
@ApiBearerAuth()
@Controller('tickets')
@UseGuards(JwtAuthGuard, RolesGuard)
export class TicketsController {
  constructor(private readonly ticketsService: TicketsService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new ticket' })
  @ApiResponse({
    status: 201,
    description: 'Ticket successfully created',
    schema: {
      example: {
        id: 1,
        facebook_name: 'John Doe',
        amount: 100.5,
        game: 'Mobile Legends',
        game_id: 'ML123456',
        payment_method: 'GCash',
        payment_tag: 'GCASH123',
        account_name: 'JohnDoe123',
        payment_qr_code: 'https://example.com/qr/123456',
        status: 'new',
        created_at: '2024-03-20T10:30:00Z',
      },
    },
  })
  async create(@Body() createTicketDto: CreateTicketDto, @Request() req) {
    const clientId = req.user.userId;
    return this.ticketsService.create(createTicketDto, req.user, {
      id: clientId,
    } as any);
  }

  @Get()
  @Roles(UserRole.ADMIN, UserRole.USER, UserRole.FULFILLER)
  @ApiOperation({ summary: 'Get all tickets' })
  @ApiQuery({ name: 'status', required: false, enum: TicketStatus })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiResponse({
    status: 200,
    description: 'List of tickets retrieved successfully',
    schema: {
      example: {
        data: [
          {
            id: 1,
            facebook_name: 'John Doe',
            amount: 100.5,
            game: 'Mobile Legends',
            status: 'new',
            created_at: '2024-03-20T10:30:00Z',
          },
        ],
        meta: {
          total: 1,
          page: 1,
          limit: 10,
          totalPages: 1,
        },
      },
    },
  })
  findAll(
    @Query('status') status?: TicketStatus,
    @Query('page') page: number = 1,
    @Query('limit') limit: number = 10,
  ) {
    return this.ticketsService.findAll(status, page, limit);
  }

  @Get(':id')
  @Roles(UserRole.ADMIN, UserRole.USER, UserRole.FULFILLER)
  @ApiOperation({ summary: 'Get ticket by ID' })
  @ApiParam({ name: 'id', description: 'Ticket ID' })
  @ApiResponse({
    status: 200,
    description: 'Ticket retrieved successfully',
    schema: {
      example: {
        id: 1,
        facebook_name: 'John Doe',
        amount: 100.5,
        game: 'Mobile Legends',
        game_id: 'ML123456',
        payment_method: 'GCash',
        payment_tag: 'GCASH123',
        account_name: 'JohnDoe123',
        payment_qr_code: 'https://example.com/qr/123456',
        status: 'new',
        created_at: '2024-03-20T10:30:00Z',
      },
    },
  })
  findOne(@Param('id') id: string) {
    return this.ticketsService.findOne(id);
  }

  @Put(':id/validate')
  @Roles(UserRole.USER, UserRole.FULFILLER)
  @ApiOperation({ summary: 'Validate a ticket' })
  @ApiParam({ name: 'id', description: 'Ticket ID' })
  @ApiResponse({
    status: 200,
    description: 'Ticket validated successfully',
    schema: {
      example: {
        id: 1,
        status: 'validated',
        validated_at: '2024-03-20T11:00:00Z',
      },
    },
  })
  validateTicket(@Param('id') id: string, @Request() req) {
    return this.ticketsService.validateTicket(id, req.user);
  }

  @Put(':id/decline')
  @Roles(UserRole.USER)
  @ApiOperation({ summary: 'Decline a ticket' })
  @ApiParam({ name: 'id', description: 'Ticket ID' })
  @ApiResponse({
    status: 200,
    description: 'Ticket declined successfully',
    schema: {
      example: {
        id: 1,
        status: 'declined',
        declined_at: '2024-03-20T11:00:00Z',
      },
    },
  })
  declineTicket(@Param('id') id: string, @Request() req) {
    return this.ticketsService.declineTicket(id, req.user);
  }

  @Put(':id/complete')
  @Roles(UserRole.FULFILLER)
  @ApiOperation({ summary: 'Complete a ticket' })
  @ApiParam({ name: 'id', description: 'Ticket ID' })
  @ApiBody({
    schema: {
      type: 'object',
      required: ['paymentImageUrl', 'transactionId', 'user_id'],
      properties: {
        paymentImageUrl: {
          type: 'string',
          description: 'URL of the payment image',
          example: 'https://example.com/payment/123456.jpg',
        },
        transactionId: {
          type: 'string',
          description: 'Transaction ID',
          example: 'TRX123456',
        },
        user_id: {
          type: 'number',
          description: 'User ID',
          example: 1,
        },
      },
    },
  })
  @ApiResponse({
    status: 200,
    description: 'Ticket completed successfully',
    schema: {
      example: {
        id: 1,
        status: 'completed',
        completed_at: '2024-03-20T11:30:00Z',
        paymentImageUrl: 'https://example.com/payment/123456.jpg',
        transactionId: 'TRX123456',
        user_id: 1,
      },
    },
  })
  @ApiResponse({
    status: 400,
    description: 'Bad Request - Ticket must be validated before completion',
  })
  @ApiResponse({
    status: 404,
    description: 'Not Found - Ticket not found',
  })
  @ApiResponse({
    status: 401,
    description: 'Unauthorized - Invalid or missing token',
  })
  @ApiResponse({
    status: 403,
    description: 'Forbidden - User does not have FULFILLER role',
  })
  completeTicket(
    @Param('id') id: string,
    @Request() req,
    @Body()
    body: { paymentImageUrl: string; transactionId: string; user_id: number },
  ) {
    return this.ticketsService.completeTicket(
      id,
      req.user.userId,
      body.paymentImageUrl,
      body.transactionId,
      body.user_id,
    );
  }

  @Get('status/:status')
  @Roles(UserRole.ADMIN, UserRole.USER, UserRole.FULFILLER)
  @ApiOperation({ summary: 'Get tickets by status' })
  @ApiParam({
    name: 'status',
    enum: TicketStatus,
    description: 'Ticket status',
  })
  @ApiResponse({
    status: 200,
    description: 'Tickets retrieved successfully',
    schema: {
      example: [
        {
          id: 1,
          facebook_name: 'John Doe',
          amount: 100.5,
          game: 'Mobile Legends',
          status: 'new',
          created_at: '2024-03-20T10:30:00Z',
        },
      ],
    },
  })
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
