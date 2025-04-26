import { IsString, IsNumber, IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateTicketDto {
  @ApiProperty({
    description: 'Facebook name of the user',
    example: 'John Doe',
  })
  @IsString()
  @IsNotEmpty()
  facebook_name: string;

  @ApiProperty({
    description: 'Amount for the ticket',
    example: 100.5,
  })
  @IsNumber()
  @IsNotEmpty()
  amount: number;

  @ApiProperty({
    description: 'Game name',
    example: 'Mobile Legends',
  })
  @IsString()
  @IsNotEmpty()
  game: string;

  @ApiProperty({
    description: 'Game ID',
    example: 'ML123456',
  })
  @IsString()
  @IsNotEmpty()
  game_id: string;

  @ApiProperty({
    description: 'Payment method',
    example: 'GCash',
  })
  @IsString()
  @IsNotEmpty()
  payment_method: string;

  @ApiProperty({
    description: 'Payment tag',
    example: 'GCASH123',
  })
  @IsString()
  @IsNotEmpty()
  payment_tag: string;

  @ApiProperty({
    description: 'Account name',
    example: 'JohnDoe123',
  })
  @IsString()
  @IsNotEmpty()
  account_name: string;

  @ApiProperty({
    description: 'Payment QR code URL',
    example: 'https://example.com/qr/123456',
  })
  @IsString()
  @IsNotEmpty()
  payment_qr_code: string;

  @ApiProperty({
    description: 'Telegram chat id',
    example: '-1002324697837',
  })
  @IsNumber()
  @IsNotEmpty()
  telegram_chat_id: string;
}
