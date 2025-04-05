import { IsEnum, IsNotEmpty, IsNumber, IsPositive } from 'class-validator';
import { WalletType } from '../entities/wallet.entity';
import { ApiProperty } from '@nestjs/swagger';

export class TransactionDto {
  @ApiProperty({
    description: 'Type of wallet',
    enum: WalletType,
    example: WalletType.ETH,
  })
  @IsEnum(WalletType)
  type: WalletType;

  @ApiProperty({
    description: 'Transaction amount',
    example: 100.5,
    minimum: 0,
  })
  @IsNumber()
  @IsPositive()
  @IsNotEmpty()
  amount: number;
}
