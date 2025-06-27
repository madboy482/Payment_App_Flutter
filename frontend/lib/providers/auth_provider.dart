import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    // Delay initialization to avoid setState during build
    Future.microtask(() => _loadSavedAuth());
  }

  Future<void> _loadSavedAuth() async {
    final token = await StorageService.getToken();
    final userDataString = await StorageService.getUserData();
    
    if (token != null && userDataString != null) {
      try {
        _apiService.setToken(token);
        final userData = jsonDecode(userDataString);
        _user = User.fromJson(userData);
        notifyListeners();
      } catch (e) {
        // Clear invalid stored data
        await logout();
      }
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('Attempting login for user: $username');
      final response = await _apiService.login(username, password);
      print('Login response received: $response');
      
      final token = response['access_token'];
      final userData = response['user'];

      if (token == null) {
        throw Exception('No access token received');
      }
      if (userData == null) {
        throw Exception('No user data received');
      }

      await StorageService.saveToken(token);
      await StorageService.saveUserData(jsonEncode(userData));
      
      _apiService.setToken(token);
      _user = User.fromJson(userData);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Login error: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _apiService.clearToken();
    await StorageService.clearAll();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
