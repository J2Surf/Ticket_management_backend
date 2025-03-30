import { IsEnum, IsNotEmpty, IsString } from 'class-validator';
import { WalletType } from '../entities/wallet.entity';

export class ConnectWalletDto {
  @IsEnum(WalletType)
  type: WalletType;

  @IsString()
  @IsNotEmpty()
  walletAddress: string;
}
