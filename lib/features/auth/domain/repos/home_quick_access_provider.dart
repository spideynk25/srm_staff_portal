import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/entities/home_quick_access_data.dart';

class HomeQuickAccessNotifier extends StateNotifier<HomeQuickAccessData?> {
  HomeQuickAccessNotifier() : super(null);

  void setHomeQuickAccessData(HomeQuickAccessData data) {
    state = data;
  }

  void clearHomeQuickAccessData() {
    state = null;
  }
}

final homeQuickAccessProvider = StateNotifierProvider<HomeQuickAccessNotifier, HomeQuickAccessData?>((ref) {
  return HomeQuickAccessNotifier();
});