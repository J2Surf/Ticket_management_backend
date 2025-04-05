import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  OneToMany,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Transaction } from './transaction.entity';

export enum WalletStatus {
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE',
  PENDING = 'PENDING',
}

export enum WalletType {
  ETH = 'ETH',
}

export enum TokenType {
  ETH = 'ETH',
  BTC = 'BTC',
  USDT = 'USDT',
  THB = 'THB',
}

@Entity('wallets')
export class Wallet {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'user_id' })
  user: User;

  @Column({ name: 'user_id' })
  userId: number;

  @Column({
    type: 'enum',
    enum: WalletType,
    default: WalletType.ETH,
    name: 'type',
  })
  type: WalletType;

  @Column({
    type: 'enum',
    enum: TokenType,
    default: TokenType.USDT,
    name: 'token_type',
  })
  tokenType: TokenType;

  @Column('decimal', { precision: 10, scale: 2, default: 0 })
  balance: number;

  @Column({ name: 'address' })
  address: string;

  @Column({
    type: 'enum',
    enum: WalletStatus,
    default: WalletStatus.PENDING,
  })
  status: WalletStatus;

  @Column({ name: 'last_connected_at', nullable: true })
  lastConnectedAt: Date;

  @Column({ name: 'private_key', nullable: true })
  privateKey: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
