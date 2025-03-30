import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Ticket, TicketStatus } from '../tickets/entities/ticket.entity';
import {
  Wallet,
  WalletStatus,
  WalletType,
} from '../wallet/entities/wallet.entity';
import { User } from '../users/entities/user.entity';
import { UserRole } from '../users/entities/user.entity';
import { ConnectWalletDto } from '../wallet/dto/connect-wallet.dto';
import { TransactionDto } from '../wallet/dto/transaction.dto';

@Injectable()
export class DashboardService {
  constructor(
    @InjectRepository(Ticket)
    private ticketRepository: Repository<Ticket>,
    @InjectRepository(Wallet)
    private walletRepository: Repository<Wallet>,
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  async getCustomerDashboard(userId: string) {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    const [wallets, recentTickets, ticketStats] = await Promise.all([
      this.walletRepository.find({ where: { userId } }),
      this.getRecentCustomerTickets(userId),
      this.getCustomerTicketStats(userId),
    ]);

    return {
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        balance: user.balance,
      },
      wallets: wallets.map((wallet) => ({
        type: wallet.type,
        balance: wallet.balance,
        status: wallet.status,
        lastConnectedAt: wallet.lastConnectedAt,
      })),
      ticketStats,
      recentTickets,
      totalSpent: await this.calculateTotalSpent(userId),
      activeOrders: await this.getActiveOrders(userId),
    };
  }

  async getFulfillerDashboard(userId: string) {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    const [wallets, recentTickets, ticketStats, earnings] = await Promise.all([
      this.walletRepository.find({ where: { userId } }),
      this.getRecentFulfillerTickets(userId),
      this.getFulfillerTicketStats(userId),
      this.calculateFulfillerEarnings(userId),
    ]);

    return {
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        balance: user.balance,
      },
      wallets: wallets.map((wallet) => ({
        type: wallet.type,
        balance: wallet.balance,
        status: wallet.status,
        lastConnectedAt: wallet.lastConnectedAt,
      })),
      ticketStats,
      recentTickets,
      earnings,
      availableTasks: await this.getAvailableTasks(),
      performance: await this.getFulfillerPerformance(userId),
    };
  }

  async connectWallet(userId: string, connectWalletDto: ConnectWalletDto) {
    const existingWallet = await this.walletRepository.findOne({
      where: {
        userId,
        type: connectWalletDto.type,
      },
    });

    if (existingWallet) {
      throw new BadRequestException(
        'Wallet of this type already exists for the user',
      );
    }

    const wallet = this.walletRepository.create({
      userId,
      type: connectWalletDto.type,
      walletAddress: connectWalletDto.walletAddress,
      status: WalletStatus.ACTIVE,
      lastConnectedAt: new Date(),
    });

    return this.walletRepository.save(wallet);
  }

  async deposit(userId: string, transactionDto: TransactionDto) {
    const wallet = await this.walletRepository.findOne({
      where: {
        userId,
        type: transactionDto.type,
      },
    });

    if (!wallet) {
      throw new NotFoundException('Wallet not found');
    }

    if (wallet.status !== WalletStatus.ACTIVE) {
      throw new BadRequestException('Wallet is not active');
    }

    wallet.balance = Number(wallet.balance) + Number(transactionDto.amount);
    return this.walletRepository.save(wallet);
  }

  async withdraw(userId: string, transactionDto: TransactionDto) {
    const wallet = await this.walletRepository.findOne({
      where: {
        userId,
        type: transactionDto.type,
      },
    });

    if (!wallet) {
      throw new NotFoundException('Wallet not found');
    }

    if (wallet.status !== WalletStatus.ACTIVE) {
      throw new BadRequestException('Wallet is not active');
    }

    if (Number(wallet.balance) < Number(transactionDto.amount)) {
      throw new BadRequestException('Insufficient balance');
    }

    wallet.balance = Number(wallet.balance) - Number(transactionDto.amount);
    return this.walletRepository.save(wallet);
  }

  async getWalletBalance(userId: string, type: WalletType) {
    const wallet = await this.walletRepository.findOne({
      where: {
        userId,
        type,
      },
    });

    if (!wallet) {
      throw new NotFoundException('Wallet not found');
    }

    return {
      type: wallet.type,
      balance: wallet.balance,
      status: wallet.status,
      lastConnectedAt: wallet.lastConnectedAt,
    };
  }

  private async getRecentCustomerTickets(userId: string) {
    return this.ticketRepository.find({
      where: { user_id: Number(userId) },
      order: { created_at: 'DESC' },
      take: 5,
    });
  }

  private async getRecentFulfillerTickets(userId: string) {
    return this.ticketRepository.find({
      where: { completed_by: Number(userId) },
      order: { completed_at: 'DESC' },
      take: 5,
    });
  }

  private async calculateTotalSpent(userId: string) {
    const result = await this.ticketRepository
      .createQueryBuilder('ticket')
      .select('SUM(ticket.amount)', 'total')
      .where('ticket.user_id = :userId', { userId: Number(userId) })
      .andWhere('ticket.status = :status', { status: TicketStatus.COMPLETED })
      .getRawOne();

    return result.total || 0;
  }

  private async calculateFulfillerEarnings(userId: string) {
    const result = await this.ticketRepository
      .createQueryBuilder('ticket')
      .select('SUM(ticket.amount)', 'total')
      .where('ticket.completed_by = :userId', { userId: Number(userId) })
      .andWhere('ticket.status = :status', { status: TicketStatus.COMPLETED })
      .getRawOne();

    return result.total || 0;
  }

  private async getActiveOrders(userId: string) {
    return this.ticketRepository.find({
      where: {
        user_id: Number(userId),
        status: TicketStatus.SENT,
      },
      order: { created_at: 'DESC' },
    });
  }

  private async getAvailableTasks() {
    return this.ticketRepository.find({
      where: {
        status: TicketStatus.NEW,
      },
      order: { created_at: 'DESC' },
    });
  }

  private async getFulfillerPerformance(userId: string) {
    const [totalCompleted, totalTickets] = await Promise.all([
      this.ticketRepository.count({
        where: {
          completed_by: Number(userId),
          status: TicketStatus.COMPLETED,
        },
      }),
      this.ticketRepository.count({
        where: {
          completed_by: Number(userId),
        },
      }),
    ]);

    return {
      totalCompleted,
      totalTickets,
      completionRate:
        totalTickets > 0 ? (totalCompleted / totalTickets) * 100 : 0,
    };
  }

  private async getCustomerTicketStats(userId: string) {
    const [totalTickets, activeTickets, completedTickets] = await Promise.all([
      this.ticketRepository.count({ where: { user_id: Number(userId) } }),
      this.ticketRepository.count({
        where: { user_id: Number(userId), status: TicketStatus.SENT },
      }),
      this.ticketRepository.count({
        where: { user_id: Number(userId), status: TicketStatus.COMPLETED },
      }),
    ]);

    return {
      totalTickets,
      activeTickets,
      completedTickets,
      pendingTickets: totalTickets - activeTickets - completedTickets,
    };
  }

  private async getFulfillerTicketStats(userId: string) {
    const [totalTickets, activeTickets, completedTickets] = await Promise.all([
      this.ticketRepository.count({ where: { completed_by: Number(userId) } }),
      this.ticketRepository.count({
        where: { completed_by: Number(userId), status: TicketStatus.SENT },
      }),
      this.ticketRepository.count({
        where: { completed_by: Number(userId), status: TicketStatus.COMPLETED },
      }),
    ]);

    return {
      totalTickets,
      activeTickets,
      completedTickets,
      pendingTickets: totalTickets - activeTickets - completedTickets,
    };
  }
}
