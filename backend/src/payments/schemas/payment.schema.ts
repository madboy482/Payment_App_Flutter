import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type PaymentDocument = Payment & Document;

export enum PaymentStatus {
  SUCCESS = 'success',
  FAILED = 'failed',
  PENDING = 'pending',
}

export enum PaymentMethod {
  CREDIT_CARD = 'credit_card',
  DEBIT_CARD = 'debit_card',
  PAYPAL = 'paypal',
  BANK_TRANSFER = 'bank_transfer',
  CRYPTO = 'crypto',
}

@Schema({ timestamps: true })
export class Payment {
  @Prop({ required: true })
  amount: number;

  @Prop({ required: true, enum: PaymentMethod })
  method: PaymentMethod;

  @Prop({ required: true, enum: PaymentStatus })
  status: PaymentStatus;

  @Prop({ required: true })
  receiver: string;

  @Prop()
  sender?: string;

  @Prop()
  description?: string;

  @Prop()
  transactionId?: string;

  @Prop()
  failureReason?: string;
}

export const PaymentSchema = SchemaFactory.createForClass(Payment);
