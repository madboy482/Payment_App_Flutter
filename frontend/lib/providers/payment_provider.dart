import 'package:flutter/foundation.dart';
import '../models/payment.dart';
import '../models/dashboard_stats.dart';
import '../services/api_service.dart';

class PaymentProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Payment> _payments = [];
  DashboardStats? _dashboardStats;
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalPayments = 0;
  
  // Filters
  PaymentStatus? _statusFilter;
  PaymentMethod? _methodFilter;
  DateTime? _startDateFilter;
  DateTime? _endDateFilter;

  List<Payment> get payments => _payments;
  DashboardStats? get dashboardStats => _dashboardStats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalPayments => _totalPayments;
  
  PaymentStatus? get statusFilter => _statusFilter;
  PaymentMethod? get methodFilter => _methodFilter;
  DateTime? get startDateFilter => _startDateFilter;
  DateTime? get endDateFilter => _endDateFilter;

  PaymentProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    // Token should be loaded by AuthProvider first
    await Future.delayed(const Duration(milliseconds: 100));
  }

  void setToken(String token) {
    _apiService.setToken(token);
  }

  Future<void> loadPayments({int page = 1}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getPayments(
        status: _statusFilter != null ? _paymentStatusToString(_statusFilter!) : null,
        method: _methodFilter != null ? _paymentMethodToString(_methodFilter!) : null,
        startDate: _startDateFilter?.toIso8601String(),
        endDate: _endDateFilter?.toIso8601String(),
        page: page,
        limit: 10,
      );

      _payments = response['payments'];
      _currentPage = response['page'];
      _totalPages = response['totalPages'];
      _totalPayments = response['total'];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDashboardStats() async {
    try {
      print('Loading dashboard stats from: ${ApiService.baseUrl}/payments/stats');
      _dashboardStats = await _apiService.getDashboardStats();
      print('Dashboard stats loaded successfully');
      notifyListeners();
    } catch (e) {
      print('Error loading dashboard stats: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<Payment?> createPayment({
    required double amount,
    required PaymentMethod method,
    required PaymentStatus status,
    required String receiver,
    String? sender,
    String? description,
    String? failureReason,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final payment = await _apiService.createPayment(
        amount: amount,
        method: method,
        status: status,
        receiver: receiver,
        sender: sender,
        description: description,
        failureReason: failureReason,
      );
      
      _isLoading = false;
      notifyListeners();
      
      // Refresh the payments list and stats
      await loadPayments();
      await loadDashboardStats();
      
      return payment;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void setStatusFilter(PaymentStatus? status) {
    _statusFilter = status;
    _currentPage = 1;
    loadPayments();
  }

  void setMethodFilter(PaymentMethod? method) {
    _methodFilter = method;
    _currentPage = 1;
    loadPayments();
  }

  void setDateFilter(DateTime? startDate, DateTime? endDate) {
    _startDateFilter = startDate;
    _endDateFilter = endDate;
    _currentPage = 1;
    loadPayments();
  }

  void clearFilters() {
    _statusFilter = null;
    _methodFilter = null;
    _startDateFilter = null;
    _endDateFilter = null;
    _currentPage = 1;
    loadPayments();
  }

  void nextPage() {
    if (_currentPage < _totalPages) {
      loadPayments(page: _currentPage + 1);
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      loadPayments(page: _currentPage - 1);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _paymentMethodToString(PaymentMethod method) {
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

  String _paymentStatusToString(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.success:
        return 'success';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.pending:
        return 'pending';
    }
  }
}
