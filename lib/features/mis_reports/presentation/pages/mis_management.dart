import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/current_admission.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/due_list.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/staff_attendance.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/staff_birthday.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';


class MISManagementPage extends ConsumerWidget {
  MISManagementPage({super.key});

  final List<dynamic> managementMetaData = [
    {
      "label": "Current Admission",
      "icon": "assets/icons/icondb_admissioncurrentyear.png",
      "action": (BuildContext context) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CurrentAdmission(),
            ),
          ),
    },
    {
      "label": "Due List",
      "icon": "assets/icons/icondb_duelist.png",
      "action": (BuildContext context) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DueList(),
            ),
          ),
    },
    {
      "label": "Staff Birthday",
      "icon": "assets/icons/icondb_birthdaylist.png",
      "action": (BuildContext context) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StaffBirthday(),
            ),
          ),
    },
    {
      "label": "Staff Attendance",
      "icon": "assets/icons/icondb_staffleave.png",
      "action": (BuildContext context) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StaffAttendance(from: 1),
            ),
          ),
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'MIS Management'),
      backgroundColor: const Color.fromARGB(255, 243, 239, 239),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: managementMetaData.length,
          itemBuilder: (context, index) {
            final metaData = managementMetaData[index];
            final name = metaData["label"];
            final imagePath = metaData["icon"];
            return InkWell(
              onTap: () {
                metaData["action"](context);
              },
              child: Card(
                margin: const EdgeInsets.all(0),
                elevation: 8,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                shadowColor: Colors.grey.withOpacity(0.4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
