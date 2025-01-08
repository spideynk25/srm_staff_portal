import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CreateAssignmentPage extends ConsumerStatefulWidget {
  const CreateAssignmentPage({super.key});

  @override
  ConsumerState<CreateAssignmentPage> createState() => _CreateAssignmentPageState();
}

class _CreateAssignmentPageState extends ConsumerState<CreateAssignmentPage> {
  late WebViewController controller;
  bool isInitialized = false; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      final eid = ref.read(loginDataProvider)?.eid ?? ''; // Use ref.read()
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(
            "http://115.96.66.234/evarsityamjain/lms/transaction/LMSIndexforMobile.jsp?EmployeeId=$eid"));
      isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Create Assignment'),
      backgroundColor: const Color.fromARGB(255, 243, 239, 239),
      body: WebViewWidget(controller: controller),
    );
  }
}
