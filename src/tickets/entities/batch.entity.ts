import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
} from 'typeorm';
import { BatchTicket } from './batch-ticket.entity';

export enum BatchStatus {
  PENDING = 'pending',
  PROCESSING = 'processing',
  COMPLETED = 'completed',
  FAILED = 'failed',
}

@Entity('batches')
export class Batch {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  batch_id: string;

  @Column({
    type: 'enum',
    enum: BatchStatus,
    default: BatchStatus.PENDING,
  })
  status: BatchStatus;

  @CreateDateColumn()
  created_at: Date;

  @Column({ nullable: true })
  completed_at: Date;

  @Column()
  fulfiller_id: number;

  @Column()
  payment_method: string;

  @Column()
  total_tickets: number;

  @Column({ default: 0 })
  completed_tickets: number;

  @Column('decimal', { precision: 10, scale: 2 })
  batch_amount: number;

  @Column({ nullable: true })
  processing_started_at: Date;

  @Column({ nullable: true })
  deleted_at: Date;

  @OneToMany(() => BatchTicket, (batchTicket) => batchTicket.batch)
  batchTickets: BatchTicket[];
}
