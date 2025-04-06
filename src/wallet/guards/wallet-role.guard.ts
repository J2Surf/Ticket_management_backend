import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from '../decorators/roles.decorator';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class WalletRoleGuard implements CanActivate {
  constructor(
    private reflector: Reflector,
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const requiredRoles = this.reflector.getAllAndOverride<string[]>(
      ROLES_KEY,
      [context.getHandler(), context.getClass()],
    );

    console.log('WalletRoleGuard - Required roles:', requiredRoles);

    if (!requiredRoles) {
      console.log('WalletRoleGuard - No required roles, allowing access');
      return true;
    }

    const request = context.switchToHttp().getRequest();
    const [type, token] = request.headers.authorization?.split(' ') ?? [];

    console.log('WalletRoleGuard - Authorization type:', type);

    if (type !== 'Bearer' || !token) {
      console.log('WalletRoleGuard - Invalid authorization header');
      throw new UnauthorizedException('Invalid authorization header');
    }

    try {
      const user = await this.jwtService.verifyAsync(token, {
        secret: this.configService.get('JWT_SECRET'),
      });

      console.log('WalletRoleGuard - User from token:', user);
      console.log('WalletRoleGuard - User roles:', user.roles);

      const hasRequiredRole =
        user &&
        user.roles &&
        requiredRoles.some((role) => user.roles.includes(role.toUpperCase()));

      console.log('WalletRoleGuard - Has required role:', hasRequiredRole);

      if (!hasRequiredRole) {
        console.log('WalletRoleGuard - User does not have required roles');
        throw new UnauthorizedException('User does not have required roles');
      }

      return hasRequiredRole;
    } catch (error) {
      console.error('WalletRoleGuard - Error verifying token:', error);
      throw new UnauthorizedException('Invalid token');
    }
  }
}
