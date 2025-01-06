import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/app_meta_data.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:srm_staff_portal/widgets/custom_card_widgets.dart';


class LeavePage extends ConsumerWidget {
  const LeavePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuIds = ref.watch(loginDataProvider)?.menuIds ?? [];
    final leaveData = menuIds.where((data) => AppMetaData.leaveMetadata.containsKey(data)).toList();

    return Scaffold(
      appBar: const CustomAppBar(title: "Leave"),
      backgroundColor: const Color.fromARGB(255, 243, 239, 239),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: leaveData.length,
        itemBuilder: (context, index) {
          final item = leaveData[index];
          final metadata = AppMetaData.leaveMetadata[item];
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
