import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/workforce/data/payslip_service.dart';
import 'package:srm_staff_portal/features/workforce/presentation/pages/payslip_webview_page.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';


class PaySlipPage extends ConsumerStatefulWidget {
  const PaySlipPage({super.key});

  @override
  ConsumerState<PaySlipPage> createState() => _PaySlipPageState();
}

class _PaySlipPageState extends ConsumerState<PaySlipPage> {
  List<dynamic>? paySlip;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPaySlipData();
    });
    _fetchPaySlipData();
  }

  Future<void> _fetchPaySlipData() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final paySlipService = PaySlipService();

    try {
      final data = await paySlipService.getPaySlipDetails(
        eid: eid,
        encryptionProvider: encryption,
      );
      log("$data");
      setState(() {
        paySlip = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("Error fetching profile data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
         appBar: CustomAppBar(title: 'Payslip'),
        backgroundColor: Color.fromARGB(255, 243, 239, 239),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 239, 239),
        appBar: const CustomAppBar(title: 'Payslip'),
        body: ListView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: paySlip?.length,
          itemBuilder: (context, index) {
            final item = paySlip?[index];
            return Card(
                margin: const EdgeInsets.only(top: 15),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side:const BorderSide(color: Colors.black)
                    ),
                    tileColor:
                        Colors.white,
                    title: Text(
                      item["payperioddesc"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.black),
                    onTap:()=>{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PayslipWebview(paySlipData: item,),))
                    }));
          },
        ));
  }
}
