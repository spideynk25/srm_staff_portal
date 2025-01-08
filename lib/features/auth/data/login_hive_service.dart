import 'package:hive/hive.dart';
import 'package:srm_staff_portal/features/auth/domain/entities/login_data.dart';

class LoginHiveService {
  final _box = Hive.box<LoginData>('loginData');

  void saveLoginData(LoginData data) {
    _box.put('user', data); // Save login data with a key
  }

  LoginData? getLoginData() {
    return _box.get('user'); // Retrieve login data
  }

  void clearLoginData() {
    _box.delete('user'); // Clear the stored login data
  }

  bool isLoggedIn() {
    return _box.containsKey('user'); // Check if user is logged in
  }
}
