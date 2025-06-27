import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Payment, PaymentDocument, PaymentStatus, PaymentMethod } from './schemas/payment.schema';
import { CreatePaymentDto } from './dto/create-payment.dto';
import { FilterPaymentDto } from './dto/filter-payment.dto';

@Injectable()
export class PaymentsService {
  constructor(@InjectModel(Payment.name) private paymentModel: Model<PaymentDocument>) {}

  async create(createPaymentDto: CreatePaymentDto): Promise<Payment> {
    const transactionId = `TXN-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
    const payment = new this.paymentModel({
      ...createPaymentDto,
      transactionId,
    });
    return payment.save();
  }

  async findAll(filterDto: FilterPaymentDto): Promise<{ payments: Payment[]; total: number; page: number; totalPages: number }> {
    const { status, method, startDate, endDate, page = '1', limit = '10' } = filterDto;
    
    const query: any = {};
    
    if (status) {
      query.status = status;
    }
    
    if (method) {
      query.method = method;
    }
    
    if (startDate || endDate) {
      query.createdAt = {};
      if (startDate) {
        query.createdAt.$gte = new Date(startDate);
      }
      if (endDate) {
        query.createdAt.$lte = new Date(endDate);
      }
    }

    const pageNum = parseInt(page, 10);
    const limitNum = parseInt(limit, 10);
    const skip = (pageNum - 1) * limitNum;

    const payments = await this.paymentModel
      .find(query)
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limitNum)
      .exec();

    const total = await this.paymentModel.countDocuments(query);
    const totalPages = Math.ceil(total / limitNum);

    return {
      payments,
      total,
      page: pageNum,
      totalPages,
    };
  }

  async findOne(id: string): Promise<Payment> {
    return this.paymentModel.findById(id).exec();
  }

  async getStats(): Promise<any> {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    const thisWeek = new Date();
    thisWeek.setDate(thisWeek.getDate() - 7);
    thisWeek.setHours(0, 0, 0, 0);

    // Total transactions today
    const transactionsToday = await this.paymentModel.countDocuments({
      createdAt: { $gte: today },
    });

    // Total transactions this week
    const transactionsThisWeek = await this.paymentModel.countDocuments({
      createdAt: { $gte: thisWeek },
    });

    // Revenue today
    const revenueToday = await this.paymentModel.aggregate([
      { $match: { createdAt: { $gte: today }, status: PaymentStatus.SUCCESS } },
      { $group: { _id: null, total: { $sum: '$amount' } } },
    ]);

    // Revenue this week
    const revenueThisWeek = await this.paymentModel.aggregate([
      { $match: { createdAt: { $gte: thisWeek }, status: PaymentStatus.SUCCESS } },
      { $group: { _id: null, total: { $sum: '$amount' } } },
    ]);

    // Failed transactions today
    const failedTransactionsToday = await this.paymentModel.countDocuments({
      createdAt: { $gte: today },
      status: PaymentStatus.FAILED,
    });

    // Revenue trend for the last 7 days
    const revenueTrend = await this.paymentModel.aggregate([
      {
        $match: {
          createdAt: { $gte: thisWeek },
          status: PaymentStatus.SUCCESS,
        },
      },
      {
        $group: {
          _id: {
            $dateToString: { format: '%Y-%m-%d', date: '$createdAt' },
          },
          revenue: { $sum: '$amount' },
          count: { $sum: 1 },
        },
      },
      { $sort: { _id: 1 } },
    ]);

    return {
      transactionsToday,
      transactionsThisWeek,
      revenueToday: revenueToday[0]?.total || 0,
      revenueThisWeek: revenueThisWeek[0]?.total || 0,
      failedTransactionsToday,
      revenueTrend,
    };
  }

  async seedSampleData(): Promise<void> {
    const existingPayments = await this.paymentModel.countDocuments();
    if (existingPayments > 0) {
      return; // Don't seed if data already exists
    }

    const samplePayments = [];
    const methods = Object.values(PaymentMethod);
    const statuses = Object.values(PaymentStatus);
    
    for (let i = 0; i < 50; i++) {
      const createdAt = new Date();
      createdAt.setDate(createdAt.getDate() - Math.floor(Math.random() * 30)); // Random date within last 30 days
      
      samplePayments.push({
        amount: Math.floor(Math.random() * 1000) + 10,
        method: methods[Math.floor(Math.random() * methods.length)],
        status: statuses[Math.floor(Math.random() * statuses.length)],
        receiver: `user_${Math.floor(Math.random() * 100)}@example.com`,
        sender: `sender_${Math.floor(Math.random() * 100)}@example.com`,
        description: `Sample payment ${i + 1}`,
        transactionId: `TXN-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
        createdAt,
        updatedAt: createdAt,
      });
    }

    await this.paymentModel.insertMany(samplePayments);
    console.log('Sample payment data seeded');
  }
}
