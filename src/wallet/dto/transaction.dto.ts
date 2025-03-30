import { IsEnum, IsNotEmpty, IsNumber, IsPositive } from 'class-validator';
import { WalletType } from '../entities/wallet.entity';

export class TransactionDto {
  @IsEnum(WalletType)
  type: WalletType;

  @IsNumber()
  @IsPositive()
  @IsNotEmpty()
  amount: number;
}
