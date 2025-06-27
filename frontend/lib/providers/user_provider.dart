import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setToken(String token) {
    _apiService.setToken(token);
  }

  Future<void> loadUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await _apiService.getUsers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> createUser({
    required String username,
    required String password,
    required String email,
    required List<String> roles,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _apiService.createUser(username, password, email, roles);
      _isLoading = false;
      notifyListeners();
      
      // Refresh the users list
      await loadUsers();
      
      return user;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
