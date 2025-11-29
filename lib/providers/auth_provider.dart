import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  bool _loading = false;
  String? _error;

  String? get token => _token;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadSavedToken() async {
    _token = await AuthService.getToken();
    notifyListeners();
  }

  
  Future<void> loadToken() async {
    await loadSavedToken();
  }

  Future<void> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _token = await AuthService.login(email: email, password: password);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _token = await AuthService.register(
        name: name,
        email: email,
        password: password,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    _token = null;
    notifyListeners();
  }
}
