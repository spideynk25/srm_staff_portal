import 'package:flutter/material.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DueList extends StatefulWidget {
  const DueList({super.key});

  @override
  State<DueList> createState() => _DueListState();
}

class _DueListState extends State<DueList> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
          "http://115.96.66.234/evarsityamjain/dashboard/reports/DueListforMobile.jsp"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Due List'),
      body: WebViewWidget(controller: controller),
    );
  }
}
