import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/entities/login_data.dart';

class LoginDataNotifier extends StateNotifier<LoginData?> {
  LoginDataNotifier() : super(null);

  void setLoginData(LoginData data) {
    state = data;
  }

  void clearLoginData() {
    state = null;
  }
}

final loginDataProvider = StateNotifierProvider<LoginDataNotifier, LoginData?>((ref) {
  return LoginDataNotifier();
});