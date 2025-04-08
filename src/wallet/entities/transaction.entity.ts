import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('transactions')
export class Transaction {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'user_id' })
  user_id: number;

  @Column('decimal', { precision: 10, scale: 2 })
  amount: number;

  @Column({
    name: 'transaction_type',
    type: 'enum',
    enum: ['DEPOSIT', 'WITHDRAW'],
    default: 'DEPOSIT',
  })
  type: 'DEPOSIT' | 'WITHDRAW';

  @Column({ nullable: true })
  description: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;
}
