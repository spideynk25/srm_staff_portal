import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/app_meta_data.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:srm_staff_portal/widgets/custom_card_widgets.dart';


class WorkforcePage extends ConsumerWidget {
  const WorkforcePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuIds = ref.watch(loginDataProvider)!.menuIds;
    final workForceData =
        menuIds.where((data) => AppMetaData.workforceMetadata.containsKey(data)).toList();
    return Scaffold(
        appBar: const CustomAppBar(title: 'Workforce'),
        backgroundColor: const Color.fromARGB(255, 243, 239, 239),
        body: ListView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: workForceData.length,
          itemBuilder: (context, index) {
            final item = workForceData[index];
            final metaData = AppMetaData.workforceMetadata[item];
            return CustomCardWidgets(
                name: metaData["label"],
                imagePath: metaData["icon"],
                onTap: () => metaData["action"](context),
              );
          },
        ));
  }
}
