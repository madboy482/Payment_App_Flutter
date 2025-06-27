import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/payment.dart';
import '../models/dashboard_stats.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();
  
  // Use different base URLs for web vs mobile
  static String get baseUrl {
    if (kIsWeb) {
      return 'https://payment-app-flutter.onrender.com';
    } else {
      // For mobile, use the production URL too
      return 'https://payment-app-flutter.onrender.com';
    }
  }
  
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    
    return headers;
  }

  // Auth endpoints
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('Making login request to: $baseUrl/auth/login');
      print('Request body: ${jsonEncode({'username': username, 'password': password})}');
      print('Headers: $_headers');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _token = data['access_token'];
        return data;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Network error during login: $e');
      if (e.toString().contains('XMLHttpRequest')) {
        throw Exception('Network error: Cannot connect to server. Please check if the backend is running.');
      } else if (e.toString().contains('CORS')) {
        throw Exception('CORS error: Cross-origin request blocked.');
      } else {
        rethrow;
      }
    }
  }

  // User endpoints
  Future<List<User>> getUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users: ${response.body}');
    }
  }

  Future<User> createUser(String username, String password, String email, List<String> roles) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: _headers,
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
        'roles': roles,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user: ${response.body}');
    }
  }

  // Payment endpoints
  Future<Map<String, dynamic>> getPayments({
    String? status,
    String? method,
    String? startDate,
    String? endDate,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (status != null) queryParams['status'] = status;
    if (method != null) queryParams['method'] = method;
    if (startDate != null) queryParams['startDate'] = startDate;
    if (endDate != null) queryParams['endDate'] = endDate;

    final uri = Uri.parse('$baseUrl/payments').replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'payments': (data['payments'] as List<dynamic>)
            .map((payment) => Payment.fromJson(payment))
            .toList(),
        'total': data['total'],
        'page': data['page'],
        'totalPages': data['totalPages'],
      };
    } else {
      throw Exception('Failed to load payments: ${response.body}');
    }
  }

  Future<Payment> getPayment(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/payments/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return Payment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load payment: ${response.body}');
    }
  }

  Future<Payment> createPayment({
    required double amount,
    required PaymentMethod method,
    required PaymentStatus status,
    required String receiver,
    String? sender,
    String? description,
    String? failureReason,
  }) async {
    final payment = Payment(
      id: '',
      amount: amount,
      method: method,
      status: status,
      receiver: receiver,
      sender: sender,
      description: description,
      failureReason: failureReason,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final response = await http.post(
      Uri.parse('$baseUrl/payments'),
      headers: _headers,
      body: jsonEncode(payment.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Payment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create payment: ${response.body}');
    }
  }

  Future<DashboardStats> getDashboardStats() async {
    print('Making request to: $baseUrl/payments/stats');
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/payments/stats'),
        headers: _headers,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return DashboardStats.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Network error during dashboard stats request: $e');
      if (e.toString().contains('SocketException') || e.toString().contains('Connection')) {
        throw Exception('Network error: Cannot connect to server at $baseUrl. Please check if the backend is running and accessible.');
      } else {
        rethrow;
      }
    }
  }

  Future<void> seedData() async {
    final response = await http.post(
      Uri.parse('$baseUrl/payments/seed'),
      headers: _headers,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to seed data: ${response.body}');
    }
  }
}
