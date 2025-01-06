import 'package:flutter/material.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BookSearchPage extends StatefulWidget {
  const BookSearchPage({super.key});

  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
          "http://115.96.66.234/evarsityamjain/library/reports/advancedBookSearchVEC.jsp"));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomAppBar(title: 'Book Search'),
      backgroundColor: const Color.fromARGB(255, 243, 239, 239),
      body: WebViewWidget(controller: controller),
    );
  }
}
