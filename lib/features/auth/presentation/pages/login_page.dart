import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/data/login_hive_service.dart';
import 'package:srm_staff_portal/features/auth/data/login_service.dart';
import 'package:srm_staff_portal/features/auth/domain/entities/login_data.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/home/presentation/pages/home_page.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_snackbar.dart';


class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final nameController = TextEditingController();
  final pwdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  void dispose() {
    nameController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    ref.read(loginLoadingProvider.notifier).state = true;

    final username = nameController.text.trim();
    final password = pwdController.text.trim();

    try {
      final loginHiveService = LoginHiveService();
      final loginService = LoginService();
      final encryption = ref.read(encryptionProvider.notifier);
      final response = await loginService.login(
        username: username,
        password: password,
        encryptionProvider: encryption,
      );
      
      if(response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackbar.show(title: 'Invalid username or password')
        );
        return;
      }
      if (response.isNotEmpty) {
        final loginData = LoginData.fromJson(response);
        loginHiveService.saveLoginData(loginData); 
        ref.read(loginDataProvider.notifier).setLoginData(loginData);
      log("page eid ${response["eid"]}");
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackbar.show(title: "Login Successful"),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } catch (e) {
      log("$e");
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackbar.show(title: 'Error: ${e.toString()}')
      );
    } finally {
      ref.read(loginLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginLoadingProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 300,
                        height: 150,
                      ),
                      const SizedBox(height: 50),
                      Text(
                        'STAFF LOGIN',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                          color: Colors.blue.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 50),
                      TextFormField(
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        controller: nameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.blue.shade800,
                          ),
                          hintText: "User ID",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your User ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        controller: pwdController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.key_sharp,
                            color: Colors.blue.shade800,
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.blue.shade800,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText =
                                    !_obscureText; // Toggle the obscure text
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        iconAlignment: IconAlignment.start,
                        onPressed: isLoading ? null : login,
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          fixedSize: const Size(175, 50),
                          backgroundColor: Colors.blue.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.blue.shade400,
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Powered by',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      Image.asset(
                        'assets/images/eVarsity.png',
                        width: 200,
                        height: 50,
                      ),
                      const Text(
                        'v',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
