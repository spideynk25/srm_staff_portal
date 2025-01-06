import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/notification/data/send_notification_to_students_service.dart';
import 'package:srm_staff_portal/features/notification/presentation/pages/send_notification_student_list_page.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';


class SendNotificationToStudents extends ConsumerStatefulWidget {
  const SendNotificationToStudents({super.key});

  @override
  ConsumerState<SendNotificationToStudents> createState() =>
      _SendNotificationToStudentsState();
}

class _SendNotificationToStudentsState
    extends ConsumerState<SendNotificationToStudents> {
  List<dynamic>? staffSubjectsData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getStaffSubjects();
    });
    _getStaffSubjects();
  }

  Future<void> _getStaffSubjects() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final sendNotificationToStudentsService =
        SendNotificationToStudentsService();

    try {
      final data =
          await sendNotificationToStudentsService.getStaffSubjectsDetails(
        eid: eid,
        encryptionProvider: encryption,
      );
      print(data);
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
        appBar: CustomAppBar(title: 'Notification to Students'),
        backgroundColor: Color.fromARGB(255, 243, 239, 239),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (staffSubjectsData == null || staffSubjectsData!.isEmpty) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Notification to Students'),
        backgroundColor: Color.fromARGB(255, 243, 239, 239),
        body: Center(
          child: Text('No Data Found'),
        ),
      );
    }
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 239, 239),
        appBar: const CustomAppBar(title: 'Notification to Students'),
        body: ListView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: staffSubjectsData?.length,
          itemBuilder: (context, index) {
            final item = staffSubjectsData?[index];
            return Card(
                margin: const EdgeInsets.only(top: 15),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black)),
                child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black)),
                    tileColor: Colors.white,
                    title: Text(
                      "${item["subjectcode"]} - ${item["subjectdesc"]}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.black),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SendNotificationStudentList(
                              employeeListData: item),
                        ))));
          },
        ));
  }
}
