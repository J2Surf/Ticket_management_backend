import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
} from 'typeorm';

export enum FormSubmissionStatus {
  PENDING_VALIDATION = 'pending_validation',
  VALIDATED = 'validated',
  DECLINED = 'declined',
  COMPLETED = 'completed',
}

@Entity('form_submissions')
export class FormSubmission {
  @PrimaryGeneratedColumn()
  id: number;

  @Column('decimal', { precision: 10, scale: 2 })
  amount: number;

  @Column()
  game: string;

  @Column()
  game_id: string;

  @Column()
  facebook_name: string;

  @Column()
  transaction_number: string;

  @Column()
  group_id: number;

  @Column({
    type: 'enum',
    enum: FormSubmissionStatus,
    default: FormSubmissionStatus.PENDING_VALIDATION,
  })
  status: FormSubmissionStatus;

  @Column({ nullable: true })
  validator_id: number;

  @Column({ nullable: true })
  fulfiller_id: number;

  @Column()
  created_at: Date;

  @Column({ nullable: true })
  validated_at: Date;

  @Column({ nullable: true })
  completed_at: Date;

  @Column({ default: false })
  telegram_notification_sent: boolean;

  @Column({ nullable: true })
  telegram_message_id: number;

  @Column({ nullable: true })
  telegram_chat_id: number;
}
