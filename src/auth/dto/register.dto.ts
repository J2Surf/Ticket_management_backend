import { IsEmail, IsString, MinLength, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class RegisterDto {
  @ApiProperty({
    description: 'Username for the account',
    example: 'john_doe',
  })
  @IsString()
  username: string;

  @ApiPropertyOptional({
    description: 'Email address for the account',
    example: 'john.doe@example.com',
  })
  @IsEmail()
  @IsOptional()
  email?: string;

  @ApiProperty({
    description: 'Password for the account (minimum 6 characters)',
    example: 'secure123',
    minLength: 6,
  })
  @IsString()
  @MinLength(6)
  password: string;

  @ApiPropertyOptional({
    description: 'Role for the user (defaults to "user")',
    example: 'customer',
  })
  @IsString()
  @IsOptional()
  role?: string;

  @ApiPropertyOptional({
    description: 'Phone number for the account',
    example: '+1234567890',
  })
  @IsString()
  @IsOptional()
  phone?: string;
}
