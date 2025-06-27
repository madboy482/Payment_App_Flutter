enum PaymentStatus { success, failed, pending }

enum PaymentMethod { creditCard, debitCard, paypal, bankTransfer, crypto }

class Payment {
  final String id;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final String receiver;
  final String? sender;
  final String? description;
  final String? transactionId;
  final String? failureReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    required this.id,
    required this.amount,
    required this.method,
    required this.status,
    required this.receiver,
    this.sender,
    this.description,
    this.transactionId,
    this.failureReason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['_id'] ?? json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      method: _parsePaymentMethod(json['method'] ?? ''),
      status: _parsePaymentStatus(json['status'] ?? ''),
      receiver: json['receiver'] ?? '',
      sender: json['sender'],
      description: json['description'],
      transactionId: json['transactionId'],
      failureReason: json['failureReason'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'method': _paymentMethodToString(method),
      'status': _paymentStatusToString(status),
      'receiver': receiver,
      'sender': sender,
      'description': description,
      'failureReason': failureReason,
    };
  }

  static PaymentMethod _parsePaymentMethod(String method) {
    switch (method.toLowerCase()) {
      case 'credit_card':
        return PaymentMethod.creditCard;
      case 'debit_card':
        return PaymentMethod.debitCard;
      case 'paypal':
        return PaymentMethod.paypal;
      case 'bank_transfer':
        return PaymentMethod.bankTransfer;
      case 'crypto':
        return PaymentMethod.crypto;
      default:
        return PaymentMethod.creditCard;
    }
  }

  static PaymentStatus _parsePaymentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return PaymentStatus.success;
      case 'failed':
        return PaymentStatus.failed;
      case 'pending':
        return PaymentStatus.pending;
      default:
        return PaymentStatus.pending;
    }
  }

  static String _paymentMethodToString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.creditCard:
        return 'credit_card';
      case PaymentMethod.debitCard:
        return 'debit_card';
      case PaymentMethod.paypal:
        return 'paypal';
      case PaymentMethod.bankTransfer:
        return 'bank_transfer';
      case PaymentMethod.crypto:
        return 'crypto';
    }
  }

  static String _paymentStatusToString(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.success:
        return 'success';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.pending:
        return 'pending';
    }
  }

  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';
  
  String get methodDisplayName {
    switch (method) {
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.paypal:
        return 'PayPal';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.crypto:
        return 'Cryptocurrency';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case PaymentStatus.success:
        return 'Success';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.pending:
        return 'Pending';
    }
  }
}
