import {
  IsEnum,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  IsPositive,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { TokenType } from '../entities/wallet.entity';

export enum TransactionType {
  DEPOSIT = 'DEPOSIT',
  WITHDRAW = 'WITHDRAW',
}

export enum TransactionStatus {
  PENDING = 'PENDING',
  COMPLETED = 'COMPLETED',
  FAILED = 'FAILED',
}

export class CryptoTransactionDto {
  @ApiProperty({
    description: 'User ID associated with the transaction',
    example: 1,
  })
  @IsNumber()
  @IsNotEmpty()
  user_id: number;

  @ApiProperty({
    description: 'Type of transaction',
    enum: TransactionType,
    example: TransactionType.DEPOSIT,
  })
  @IsEnum(TransactionType)
  @IsNotEmpty()
  transaction_type: TransactionType;

  @ApiProperty({
    description: 'Transaction amount',
    example: 100.5,
  })
  @IsNumber()
  @IsPositive()
  @IsNotEmpty()
  amount: number;

  @ApiProperty({
    description: 'Transaction description',
    example: 'Deposit to ETH wallet',
  })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiProperty({
    description: 'Unique reference ID for the transaction',
    example: 'DEP-1234567890-abc123',
  })
  @IsString()
  @IsOptional()
  reference_id?: string;

  @ApiProperty({
    description: 'Wallet ID associated with the transaction',
    example: 1,
  })
  @IsNumber()
  @IsNotEmpty()
  wallet_id: number;

  @ApiProperty({
    description: 'Transaction status',
    enum: TransactionStatus,
    example: TransactionStatus.COMPLETED,
  })
  @IsEnum(TransactionStatus)
  @IsNotEmpty()
  status: TransactionStatus;

  @ApiProperty({
    description: 'User ID of the sender',
    example: 1,
  })
  @IsNumber()
  @IsOptional()
  user_id_from?: number;

  @ApiProperty({
    description: 'User ID of the recipient',
    example: 2,
  })
  @IsNumber()
  @IsOptional()
  user_id_to?: number;

  @ApiProperty({
    description: 'Source wallet address',
    example: '0x742d35Cc6634C0532925a3b844Bc454e4438f44e',
  })
  @IsString()
  @IsOptional()
  address_from?: string;

  @ApiProperty({
    description: 'Transaction hash',
    example: '0x123...abc',
  })
  @IsString()
  @IsOptional()
  transaction_hash?: string;

  @ApiProperty({
    description: 'Destination wallet address',
    example: '0x742d35Cc6634C0532925a3b844Bc454e4438f44e',
  })
  @IsString()
  @IsOptional()
  address_to?: string;

  @ApiProperty({
    description: 'Type of token',
    enum: TokenType,
    example: TokenType.USDT,
  })
  @IsEnum(TokenType)
  @IsNotEmpty()
  token_type: TokenType;
}
