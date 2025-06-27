import { Controller, Get, Post, Body, Param, Query, UseGuards } from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { CreatePaymentDto } from './dto/create-payment.dto';
import { FilterPaymentDto } from './dto/filter-payment.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../common/guards/roles.guard';
import { Roles } from '../common/decorators/roles.decorator';

@Controller('payments')
@UseGuards(JwtAuthGuard, RolesGuard)
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Post()
  @Roles('admin', 'viewer')
  create(@Body() createPaymentDto: CreatePaymentDto) {
    return this.paymentsService.create(createPaymentDto);
  }

  @Get()
  @Roles('admin', 'viewer')
  findAll(@Query() filterDto: FilterPaymentDto) {
    return this.paymentsService.findAll(filterDto);
  }

  @Get('stats')
  @Roles('admin', 'viewer')
  getStats() {
    return this.paymentsService.getStats();
  }

  @Get(':id')
  @Roles('admin', 'viewer')
  findOne(@Param('id') id: string) {
    return this.paymentsService.findOne(id);
  }

  @Post('seed')
  @Roles('admin')
  seedData() {
    return this.paymentsService.seedSampleData();
  }
}
