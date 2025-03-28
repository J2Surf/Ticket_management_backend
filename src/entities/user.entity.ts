import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
} from 'typeorm';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  username: string;

  @Column({ nullable: true })
  email: string;

  @Column()
  password: string;

  @CreateDateColumn()
  created_at: Date;

  @Column({
    type: 'enum',
    enum: ['active', 'inactive', 'suspended'],
    default: 'active',
  })
  status: string;

  @Column({ nullable: true })
  last_login: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @Column({ nullable: true })
  last_activity: Date;

  @DeleteDateColumn()
  deleted_at: Date;

  @Column({ nullable: true })
  phone: string;

  @Column({ default: 0 })
  failed_login_attempts: number;

  @Column({ nullable: true })
  last_login_attempt: Date;

  @Column({ nullable: true })
  password_changed_at: Date;
}
