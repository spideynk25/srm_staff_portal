import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/encryption_provider.dart';
import 'package:srm_staff_portal/encryption_state.dart';
import 'package:srm_staff_portal/features/auth/presentation/pages/login_page.dart';

final leavePeriodIdProvider = StateProvider<int>((ref) => 0);
final loginLoadingProvider = StateProvider(
  (ref) => false,
);
final attendanceSavedProvider = StateProvider((ref) => false);
final encryptionProvider =
    StateNotifierProvider<EncryptionProvider, EncryptionState>(
  (ref) => EncryptionProvider(),
);
void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.green,
  // ));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
