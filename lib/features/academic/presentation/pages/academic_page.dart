import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/app_meta_data.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:srm_staff_portal/widgets/custom_card_widgets.dart';



class AcademicPage extends ConsumerWidget {
  const AcademicPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuIds = ref.watch(loginDataProvider)!.menuIds;
    final academicData =
        menuIds.where((data) =>AppMetaData.academicMetadata.containsKey(data)).toList();
    return Scaffold(
      appBar: const CustomAppBar(title: "Acedemic"),
        backgroundColor: const Color.fromARGB(255, 243, 239, 239),
        body: ListView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: academicData.length,
          itemBuilder: (context, index) {
            final item = academicData[index];
            final metaData = AppMetaData.academicMetadata[item];
            return CustomCardWidgets(
                name: metaData["label"],
                imagePath: metaData["icon"],
                onTap: () => metaData["action"](context)
            );
          },
        ));
  }
}