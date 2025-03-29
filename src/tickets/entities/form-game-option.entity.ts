import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('form_game_options')
export class FormGameOption {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  game_name: string;

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
