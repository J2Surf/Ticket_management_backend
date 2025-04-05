import { ApiProperty } from '@nestjs/swagger';
import { WalletType } from '../entities/wallet.entity';

export class EthereumWalletDto {
  @ApiProperty({
    description: 'Wallet ID',
    example: 1,
  })
  id: number;

  @ApiProperty({
    description: 'Wallet type',
    enum: WalletType,
    example: WalletType.ETH,
  })
  type: WalletType;

  @ApiProperty({
    description: 'Ethereum wallet address',
    example: '0x742d35Cc6634C0532925a3b844Bc454e4438f44e',
  })
  address: string;

  @ApiProperty({
    description: 'Wallet balance',
    example: 0.0,
  })
  balance: number;

  // @ApiProperty({
  //   description: 'Ethereum wallet private key (only provided during creation)',
  //   example: '0x123...abc',
  // })
  // privateKey: string;

  @ApiProperty({
    description: 'Wallet creation timestamp',
    example: '2024-02-20T10:00:00Z',
  })
  createdAt: Date;

  @ApiProperty({
    description: 'Wallet last update timestamp',
    example: '2024-02-20T10:00:00Z',
  })
  updatedAt: Date;
}
