import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';

class PayslipWebview extends ConsumerWidget {
  final Map<String, dynamic> paySlipData;
  const PayslipWebview({super.key, required this.paySlipData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log("payslip $paySlipData");
    final eid = ref.watch(loginDataProvider)!.eid;
    //final isLoading = ValueNotifier<bool>(true);

    return Scaffold(
        appBar: const CustomAppBar(title: 'Payslip'),
        backgroundColor: const Color.fromARGB(255, 243, 239, 239),
        body: const PDF().fromUrl("${"http://115.96.66.234/evarsityamjain/workforce/report/PaySlip.jsp?iden=8&EmployeeCategoryId=-1&PayStructureId="+paySlipData["paystructureid"]+"&PayPeriodId="+paySlipData["payperiodid"]+"&perPage=1&OfficeId="+paySlipData["officeid"]}&DivisionId=0&EmployeeId=$eid&intFlag=1"));
  }
}
