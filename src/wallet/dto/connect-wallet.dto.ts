import { IsEnum, IsNotEmpty, IsString } from 'class-validator';
import { WalletType, TokenType } from '../entities/wallet.entity';
import { ApiProperty } from '@nestjs/swagger';

export class ConnectWalletDto {
  @ApiProperty({
    description: 'Type of wallet',
    enum: WalletType,
    example: WalletType.ETH,
  })
  @IsEnum(WalletType)
  type: WalletType;

  @ApiProperty({
    description: 'Token type',
    enum: TokenType,
    example: TokenType.USDT,
  })
  @IsEnum(TokenType)
  tokenType: TokenType;

  @ApiProperty({
    description: 'Wallet address',
    example: '0x742d35Cc6634C0532925a3b844Bc454e4438f44e',
  })
  @IsString()
  @IsNotEmpty()
  walletAddress: string;
}
