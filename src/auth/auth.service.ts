import {
  Injectable,
  ConflictException,
  UnauthorizedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { User, UserStatus } from '../entities/user.entity';
import { Role } from '../entities/role.entity';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
    @InjectRepository(Role)
    private roleRepository: Repository<Role>,
    private jwtService: JwtService,
  ) {}

  async register(createUserDto: {
    username: string;
    email?: string;
    password: string;
    roleName?: string;
    phone?: string;
  }) {
    // Check for existing username
    const existingUsername = await this.userRepository.findOne({
      where: { username: createUserDto.username },
    });

    if (existingUsername) {
      throw new ConflictException('Username already exists');
    }

    // Check for existing email if provided
    if (createUserDto.email) {
      const existingEmail = await this.userRepository.findOne({
        where: { email: createUserDto.email },
      });

      if (existingEmail) {
        throw new ConflictException('Email already exists');
      }
    }

    const hashedPassword = await bcrypt.hash(createUserDto.password, 10);

    // Find the role by name
    let role: Role | null = null;
    if (createUserDto.roleName) {
      role = await this.roleRepository.findOne({
        where: { name: createUserDto.roleName },
      });
      if (!role) {
        throw new ConflictException(`Role ${createUserDto.roleName} not found`);
      }
    } else {
      // If no role specified, assign default 'user' role
      role = await this.roleRepository.findOne({
        where: { name: 'user' },
      });
      if (!role) {
        throw new ConflictException('Default user role not found');
      }
    }

    // Create user without roles first
    const user = this.userRepository.create({
      username: createUserDto.username,
      email: createUserDto.email,
      password: hashedPassword,
      phone: createUserDto.phone,
      status: UserStatus.ACTIVE,
      failed_login_attempts: 0,
    });

    // Save user first
    const savedUser = await this.userRepository.save(user);

    // If role exists, add it to the user
    if (role) {
      savedUser.roles = [role];
      await this.userRepository.save(savedUser);
    }

    const { password, ...result } = savedUser;
    return result;
  }

  async login(identifier: string, password: string, isEmail: boolean = false) {
    // Find user by either email or username based on the isEmail flag
    const user = await this.userRepository.findOne({
      where: isEmail ? { email: identifier } : { username: identifier },
      relations: ['roles'],
    });

    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }

    // Check if user is active
    if (user.status !== UserStatus.ACTIVE) {
      throw new UnauthorizedException('Account is not active');
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      // Increment failed login attempts
      user.failed_login_attempts += 1;
      user.last_login_attempt = new Date();
      await this.userRepository.save(user);
      throw new UnauthorizedException('Invalid credentials');
    }

    // Reset failed login attempts on successful login
    user.failed_login_attempts = 0;
    user.last_login = new Date();
    user.last_activity = new Date();
    await this.userRepository.save(user);

    const payload = {
      sub: user.id,
      username: user.username,
      email: user.email,
      roles: user.roles.map((role) => role.name),
    };
    const accessToken = this.jwtService.sign(payload);

    const { password: _, ...result } = user;
    return {
      ...result,
      accessToken,
    };
  }
}
