import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('fulfillers')
export class Fulfiller {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column()
  email: string;

  @Column()
  phone: string;

  @Column({
    type: 'enum',
    enum: ['active', 'inactive', 'suspended'],
    default: 'active',
  })
  status: string;

  @Column('simple-array')
  payment_methods: string[];

  @Column({ default: 0 })
  total_tickets: number;

  @Column({ default: 0 })
  completed_tickets: number;

  @Column('decimal', { precision: 10, scale: 2, default: 0 })
  total_amount: number;

  @Column({ default: 0 })
  error_count: number;

  @Column({ nullable: true })
  last_error: string;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @Column({ nullable: true })
  deleted_at: Date;
}
