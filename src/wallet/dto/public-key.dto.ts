import { ApiProperty } from '@nestjs/swagger';

export class PublicKeyResponse {
  @ApiProperty({
    description: 'Ethereum wallet public key',
    example: '0x742d35Cc6634C0532925a3b844Bc454e4438f44e',
  })
  publicKey: string;
}
