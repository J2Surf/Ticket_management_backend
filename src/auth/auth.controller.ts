import {
  Controller,
  Post,
  Body,
  HttpCode,
  HttpStatus,
  UnauthorizedException,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  @ApiOperation({ summary: 'Register a new user' })
  @ApiResponse({
    status: 201,
    description: 'User successfully registered',
    schema: {
      example: {
        id: 1,
        username: 'john_doe',
        email: 'john.doe@example.com',
        role: 'CUSTOMER',
        phone: '+1234567890',
        accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
      },
    },
  })
  @ApiResponse({
    status: 409,
    description: 'Username or email already exists',
  })
  async register(@Body() createUserDto: RegisterDto) {
    return this.authService.register(createUserDto);
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login with email and password' })
  @ApiResponse({
    status: 200,
    description: 'User successfully logged in',
    schema: {
      example: {
        id: 1,
        username: 'john_doe',
        email: 'john.doe@example.com',
        role: 'CUSTOMER',
        phone: '+1234567890',
        accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
      },
    },
  })
  @ApiResponse({
    status: 401,
    description: 'Invalid credentials',
  })
  async login(@Body() loginDto: LoginDto) {
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
