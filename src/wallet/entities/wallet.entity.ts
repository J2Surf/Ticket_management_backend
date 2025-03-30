import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

export enum WalletStatus {
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE',
  PENDING = 'PENDING',
}

export enum WalletType {
  ETH = 'ETH',
  BTC = 'BTC',
  USDT = 'USDT',
}

@Entity()
export class Wallet {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User)
  @JoinColumn()
  user: User;

  @Column()
  userId: string;

  @Column({
    type: 'enum',
    enum: WalletType,
    default: WalletType.USDT,
  })
  type: WalletType;

  @Column('decimal', { precision: 18, scale: 8, default: 0 })
  balance: number;

  @Column({ nullable: true })
  walletAddress: string;

  @Column({
    type: 'enum',
    enum: WalletStatus,
    default: WalletStatus.PENDING,
  })
  status: WalletStatus;

  @Column({ nullable: true })
  lastConnectedAt: Date;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
