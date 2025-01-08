import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:srm_staff_portal/encryption_provider.dart';
import 'package:srm_staff_portal/encryption_state.dart';
import 'package:srm_staff_portal/features/auth/data/login_hive_service.dart';
import 'package:srm_staff_portal/features/auth/domain/entities/login_data.dart';
import 'package:srm_staff_portal/features/auth/presentation/pages/login_page.dart';
import 'package:srm_staff_portal/features/home/presentation/pages/home_page.dart';

final leavePeriodIdProvider = StateProvider<int>((ref) => 0);
final loginLoadingProvider = StateProvider((ref) => false);
final attendanceSavedProvider = StateProvider((ref) => false);
final encryptionProvider =
    StateNotifierProvider<EncryptionProvider, EncryptionState>(
  (ref) => EncryptionProvider(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  try {
    Hive.registerAdapter(LoginDataAdapter());
    await Hive.openBox<LoginData>('loginData');
  } catch (e) {
    debugPrint('Error initializing Hive: $e');
  }

  final hiveService = LoginHiveService();
  final isLoggedIn = hiveService.isLoggedIn();

  runApp(ProviderScope(child: MyApp(isLoggedIn: isLoggedIn)));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? HomePage() : LoginPage(),
    );
  }
}
