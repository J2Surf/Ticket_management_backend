import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
} from 'typeorm';
import { Batch } from './batch.entity';

@Entity('batch_tickets')
export class BatchTicket {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  batch_id: number;

  @Column()
  ticket_id: number;

  @Column({
    type: 'enum',
    enum: ['pending', 'processing', 'completed', 'failed'],
    default: 'pending',
  })
  status: string;

  @Column({ nullable: true })
  assigned_at: Date;

  @Column({ nullable: true })
  completed_at: Date;

  @Column('decimal', { precision: 10, scale: 2 })
  amount: number;

  @Column({ nullable: true })
  processing_time: number;

  @Column({ default: 0 })
  error_count: number;

  @Column({ nullable: true })
  last_error: string;

  @Column({ nullable: true })
  deleted_at: Date;

  @ManyToOne(() => Batch, (batch) => batch.batchTickets)
  batch: Batch;
}
