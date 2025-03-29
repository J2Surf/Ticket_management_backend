import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
} from 'typeorm';

export enum TransactionType {
  CREDIT = 'credit',
  DEBIT = 'debit',
  FEE = 'fee',
}

@Entity('transactions')
export class Transaction {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  user_id: number;

  @Column('decimal', { precision: 10, scale: 2 })
  amount: number;

  @Column({
    type: 'enum',
    enum: TransactionType,
  })
  transaction_type: TransactionType;

  @Column({ nullable: true })
  description: string;

  @Column({ nullable: true })
  reference_id: string;

  @CreateDateColumn()
  created_at: Date;
}
