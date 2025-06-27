import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/payment_provider.dart';
import '../models/payment.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _receiverController = TextEditingController();
  final _senderController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _failureReasonController = TextEditingController();

  PaymentMethod _selectedMethod = PaymentMethod.creditCard;
  PaymentStatus _selectedStatus = PaymentStatus.success;

  @override
  void dispose() {
    _amountController.dispose();
    _receiverController.dispose();
    _senderController.dispose();
    _descriptionController.dispose();
    _failureReasonController.dispose();
    super.dispose();
  }

  Future<void> _submitPayment() async {
    if (_formKey.currentState!.validate()) {
      final paymentProvider = context.read<PaymentProvider>();
      
      final payment = await paymentProvider.createPayment(
        amount: double.parse(_amountController.text),
        method: _selectedMethod,
        status: _selectedStatus,
        receiver: _receiverController.text.trim(),
        sender: _senderController.text.trim().isEmpty ? null : _senderController.text.trim(),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        failureReason: _selectedStatus == PaymentStatus.failed && _failureReasonController.text.trim().isNotEmpty
            ? _failureReasonController.text.trim()
            : null,
      );

      if (payment != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment created successfully! ID: ${payment.transactionId}'),
            backgroundColor: Colors.green,
          ),
        );
        _resetForm();
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _amountController.clear();
    _receiverController.clear();
    _senderController.clear();
    _descriptionController.clear();
    _failureReasonController.clear();
    setState(() {
      _selectedMethod = PaymentMethod.creditCard;
      _selectedStatus = PaymentStatus.success;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Simulate New Payment',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create a simulated payment transaction for testing purposes.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Amount
                      TextFormField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                          labelText: 'Amount *',
                          prefixText: '\$ ',
                          border: OutlineInputBorder(),
                          helperText: 'Enter the payment amount',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          final amount = double.tryParse(value);
                          if (amount == null || amount <= 0) {
                            return 'Please enter a valid amount greater than 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Receiver
                      TextFormField(
                        controller: _receiverController,
                        decoration: const InputDecoration(
                          labelText: 'Receiver *',
                          border: OutlineInputBorder(),
                          helperText: 'Email or username of the receiver',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a receiver';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Sender
                      TextFormField(
                        controller: _senderController,
                        decoration: const InputDecoration(
                          labelText: 'Sender (Optional)',
                          border: OutlineInputBorder(),
                          helperText: 'Email or username of the sender',
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Payment Method
                      DropdownButtonFormField<PaymentMethod>(
                        value: _selectedMethod,
                        decoration: const InputDecoration(
                          labelText: 'Payment Method *',
                          border: OutlineInputBorder(),
                        ),
                        items: PaymentMethod.values.map((method) {
                          return DropdownMenuItem(
                            value: method,
                            child: Text(_getMethodDisplayName(method)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedMethod = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Payment Status
                      DropdownButtonFormField<PaymentStatus>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Payment Status *',
                          border: OutlineInputBorder(),
                        ),
                        items: PaymentStatus.values.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Row(
                              children: [
                                Icon(
                                  _getStatusIcon(status),
                                  color: _getStatusColor(status),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(_getStatusDisplayName(status)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedStatus = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description (Optional)',
                          border: OutlineInputBorder(),
                          helperText: 'Additional notes about the payment',
                        ),
                        maxLines: 3,
                      ),
                      
                      // Failure Reason (only for failed payments)
                      if (_selectedStatus == PaymentStatus.failed) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _failureReasonController,
                          decoration: const InputDecoration(
                            labelText: 'Failure Reason',
                            border: OutlineInputBorder(),
                            helperText: 'Reason why the payment failed',
                          ),
                          maxLines: 2,
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Submit Button
                      Consumer<PaymentProvider>(
                        builder: (context, paymentProvider, child) {
                          if (paymentProvider.error != null) {
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red.shade200),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.error, color: Colors.red.shade600),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Failed to create payment. Please try again.',
                                          style: TextStyle(color: Colors.red.shade700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _resetForm,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Reset Form'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: Consumer<PaymentProvider>(
                              builder: (context, paymentProvider, child) {
                                return ElevatedButton(
                                  onPressed: paymentProvider.isLoading ? null : _submitPayment,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: paymentProvider.isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : const Text('Create Payment'),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMethodDisplayName(PaymentMethod method) {
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

  String _getStatusDisplayName(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.success:
        return 'Success';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.pending:
        return 'Pending';
    }
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.success:
        return Colors.green;
      case PaymentStatus.failed:
        return Colors.red;
      case PaymentStatus.pending:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.success:
        return Icons.check_circle;
      case PaymentStatus.failed:
        return Icons.error;
      case PaymentStatus.pending:
        return Icons.schedule;
    }
  }
}
