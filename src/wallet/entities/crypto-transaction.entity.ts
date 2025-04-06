import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('crypto_transactions')
export class CryptoTransaction {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'user_id' })
  user_id: number;

  @Column()
  type: string;

  @Column('decimal', { precision: 10, scale: 2 })
  amount: number;

  @Column({ nullable: true })
  description: string;

  @Column({ name: 'reference_id', nullable: true })
  reference_id: string;

  @CreateDateColumn({ name: 'created_at' })
  created_at: Date;

  @Column({ name: 'wallet_id' })
  wallet_id: number;

  @Column()
  status: string;

  @Column({ name: 'user_id_from', nullable: true })
  user_id_from: number;

  @Column({ name: 'user_id_to', nullable: true })
  user_id_to: number;

  @Column({ name: 'address_from', nullable: true })
  address_from: string;

  @Column({ name: 'transaction_hash', nullable: true })
  transaction_hash: string;

  @Column({ name: 'address_to', nullable: true })
  address_to: string;

  @Column({ name: 'token_type' })
  token_type: string;
}
