import { IsEmail, IsString, MinLength, IsOptional } from 'class-validator';

export class RegisterDto {
  @IsString()
  username: string;

  @IsEmail()
  @IsOptional()
  email?: string;

  @IsString()
  @MinLength(6)
  password: string;

  @IsString()
  @IsOptional()
  roleName?: string;

  @IsString()
  @IsOptional()
  phone?: string;
}
