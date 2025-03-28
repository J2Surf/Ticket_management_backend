import {
  Controller,
  Post,
  Body,
  HttpCode,
  HttpStatus,
  UnauthorizedException,
} from '@nestjs/common';
import { AuthService } from './auth.service';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  async register(
    @Body()
    createUserDto: {
      username: string;
      email?: string;
      password: string;
      roleName?: string;
      phone?: string;
    },
  ) {
    return this.authService.register(createUserDto);
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(
    @Body() loginDto: { email?: string; username?: string; password: string },
  ) {
    if (!loginDto.password) {
      throw new UnauthorizedException('Password is required');
    }

    if (loginDto.email && loginDto.username) {
      throw new UnauthorizedException(
        'Please provide either email or username, not both',
      );
    }

    if (!loginDto.email && !loginDto.username) {
      throw new UnauthorizedException(
        'Please provide either email or username',
      );
    }

    const identifier = loginDto.email || loginDto.username || '';
    const isEmail = !!loginDto.email;
    return this.authService.login(identifier, loginDto.password, isEmail);
  }
}
