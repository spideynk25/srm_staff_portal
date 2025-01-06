import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/app_meta_data.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:srm_staff_portal/widgets/custom_card_widgets.dart';

class MISReportsPage extends ConsumerWidget {
  const MISReportsPage({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuIds = ref.watch(loginDataProvider)!.menuIds;
    final reportdata =
        menuIds.where((data) =>AppMetaData.misReportMetadata.containsKey(data)).toList();
    return Scaffold(
      appBar:const CustomAppBar(title: "MIS Report"),
      backgroundColor: const Color.fromARGB(255, 243, 239, 239),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: reportdata.length,
        itemBuilder: (context, index) {
          final item = reportdata[index];
          final metadata = AppMetaData.misReportMetadata[item];

          return CustomCardWidgets(
            name: metadata["label"],
            imagePath: metadata["icon"],
            onTap: () => metadata["action"](context),
          );
        },
      ),
    );
  }
}
