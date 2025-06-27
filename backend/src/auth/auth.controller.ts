import { Controller, Request, Post, UseGuards, Body } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LocalAuthGuard } from './local-auth.guard';
import { LoginDto } from '../common/dto/login.dto';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @UseGuards(LocalAuthGuard)
  @Post('login')
  async login(@Request() req, @Body() loginDto: LoginDto) {
    console.log('Login attempt for user:', loginDto.username);
    console.log('Request headers:', req.headers);
    const result = this.authService.login(req.user);
    console.log('Login successful for user:', req.user.username);
    return result;
  }
}
