import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('form_payment_methods')
export class FormPaymentMethod {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  method_name: string;

  @Column({ nullable: true })
  domain_id: number;

  @Column({ default: 0 })
  display_order: number;

  @Column({ default: true })
  active: boolean;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;
}
