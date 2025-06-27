import { Module, OnModuleInit } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { PaymentsModule } from './payments/payments.module';
import { UsersService } from './users/users.service';
import { PaymentsService } from './payments/payments.service';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    MongooseModule.forRoot(process.env.MONGODB_URI || 'mongodb+srv://nalin482:Nalin2005@paymentdashboard.pcqp1iw.mongodb.net/?retryWrites=true&w=majority&appName=PaymentDashboard'),
    AuthModule,
    UsersModule,
    PaymentsModule,
  ],
})
export class AppModule implements OnModuleInit {
  constructor(
    private usersService: UsersService,
    private paymentsService: PaymentsService,
  ) {}

  async onModuleInit() {
    // Create default admin user
    await this.usersService.createDefaultAdmin();
    
    // Seed sample payment data
    await this.paymentsService.seedSampleData();
  }
}
