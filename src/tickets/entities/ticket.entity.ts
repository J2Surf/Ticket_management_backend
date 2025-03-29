import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
} from 'typeorm';

export enum TicketStatus {
  NEW = 'new',
  VALIDATED = 'validated',
  DECLINED = 'declined',
  COMPLETED = 'completed',
  ERROR = 'error',
  SENT = 'sent',
}

@Entity('tickets')
export class Ticket {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ nullable: true })
  domain_id: number;

  @Column({ nullable: true })
  facebook_name: string;

  @Column()
  ticket_id: string;

  @Column()
  user_id: number;

  @Column()
  payment_method: string;

  @Column({ nullable: true })
  payment_tag: string;

  @Column({ nullable: true })
  account_name: string;

  @Column('decimal', { precision: 10, scale: 2 })
  amount: number;

  @Column({ nullable: true })
  game: string;

  @Column({ nullable: true })
  game_id: string;

  @Column({ nullable: true })
  image_path: string;

  @Column({
    type: 'enum',
    enum: TicketStatus,
    default: TicketStatus.NEW,
  })
  status: TicketStatus;

  @Column({ nullable: true })
  chat_group_id: string;

  @CreateDateColumn()
  created_at: Date;

  @Column({ nullable: true })
  completion_time: Date;

  @Column({ nullable: true })
  completed_at: Date;

  @Column({ nullable: true })
  completed_by: number;

  @Column({ nullable: true })
  error_type: string;

  @Column({ nullable: true })
  error_details: string;

  @Column({ nullable: true })
  error_reported_at: Date;

  @Column({ nullable: true })
  error_reported_by: number;
}
