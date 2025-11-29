import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  UserProfile? _user;
  bool _loading = false;
  String? _error;

  UserProfile? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchUser() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await UserService.fetchMe();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
