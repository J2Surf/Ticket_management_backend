import { IsEmail, IsString, MinLength, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class LoginDto {
  @ApiPropertyOptional({
    description: 'Email address for login',
    example: 'john.doe@example.com',
  })
  @IsEmail()
  @IsOptional()
  email?: string;

  @ApiPropertyOptional({
    description: 'Username for login',
    example: 'john_doe',
  })
  @IsString()
  @IsOptional()
  username?: string;

  @ApiProperty({
    description: 'Password for login (minimum 6 characters)',
    example: 'secure123',
    minLength: 6,
  })
  @IsString()
  @MinLength(6)
  password: string;
}
