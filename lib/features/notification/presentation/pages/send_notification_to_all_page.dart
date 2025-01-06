import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/notification/data/send_notification_to_staff_service.dart';
import 'package:srm_staff_portal/features/notification/presentation/pages/send_notification_employee_list_page.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';

class SendNotificationToAllPage extends ConsumerStatefulWidget {
  const SendNotificationToAllPage({super.key});

  @override
  ConsumerState<SendNotificationToAllPage> createState() => _SendNotificationToAllPageState();
}

class _SendNotificationToAllPageState extends ConsumerState<SendNotificationToAllPage> {
  List<dynamic>? staffSubjectsData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getEmployeeList();
    });
  }

  Future<void> _getEmployeeList() async {
    setState(() {
      isLoading = true; 
    });

    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final sendNotificationToStaffService = SendNotificationToStaffService();

    try {
      final data = await sendNotificationToStaffService.getEmployeeList(
        eid: eid,
        encryptionProvider: encryption,
      );
      setState(() {
        staffSubjectsData = data;
        isLoading = false; 
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching profile data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: "Notification to Staff"),
        backgroundColor: Color.fromARGB(255, 243, 239, 239),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (staffSubjectsData == null || staffSubjectsData!.isEmpty) {
      return const Scaffold(
        appBar: CustomAppBar(title: "Notification to Staff"),
        backgroundColor: Color.fromARGB(255, 243, 239, 239),
        body: Center(
          child: Text('No staff data available'),
        ),
      );
    }

    Map<String, List<Map<String, dynamic>>> groupedEmployees = {};
    for (var employee in staffSubjectsData!) {
      String category = employee['employeecategory'];
      if (groupedEmployees.containsKey(category)) {
        groupedEmployees[category]?.add(employee);
      } else {
        groupedEmployees[category] = [employee];
      }
    }

    List<List<Map<String, dynamic>>> groupedValues = groupedEmployees.values.toList();
    List<String> groupedKeys = groupedEmployees.keys.toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 239, 239),
      appBar: const CustomAppBar(title: "Notification to Staff"),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: groupedKeys.length,
        itemBuilder: (context, index) {
          final String item = groupedKeys[index];
          return Card(
            margin: const EdgeInsets.only(top: 15),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(color: Colors.black)
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(color: Colors.black)
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.black),
              tileColor: Colors.white,
              title: Text(
                item,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SendNotificationEmployeeListPage(
                    title: item,
                    employeeListData: groupedValues[index],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
