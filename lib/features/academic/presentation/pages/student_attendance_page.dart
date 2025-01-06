import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:srm_staff_portal/features/academic/data/student_attendance_service.dart';
import 'package:srm_staff_portal/features/academic/presentation/pages/attendance_list_page.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:srm_staff_portal/widgets/custom_snackbar.dart';

class StudentAttendancePage extends ConsumerStatefulWidget {
  const StudentAttendancePage({super.key});

  @override
  ConsumerState<StudentAttendancePage> createState() =>
      _StudentAttendancePageState();
}

class _StudentAttendancePageState extends ConsumerState<StudentAttendancePage> {
  Map<String, dynamic>? studentAttendenceTemplateData;
  List<dynamic>? studentAttendanceHourCoursesData;
  List<dynamic>? snackbarData;
  DateTime? selectedDate;
  DateTime initialDate = DateTime.now();
  bool isLoaded = false;

  bool isTemplateLoading = true;
  bool isHourDataLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchStudentAttendenceTemplate();
    });
  }

  Future<void> _fetchStudentAttendenceTemplate() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final studentAttendanceService = StudentAttendanceService();

    try {
      final data = await studentAttendanceService.getStudentAttendanceTemplate(
        eid: eid,
        encryptionProvider: encryption,
      );
      setState(() {
        studentAttendenceTemplateData = data;
        isTemplateLoading = false;
      });
    } catch (e) {
      setState(() => isTemplateLoading = false);
      log("Error fetching attendance template data: $e");
    }
  }

  Future<void> _fetchStudentAttendanceHourCourses(
      int attendanceTemplateId, String attendanceDate) async {
    setState(() => isHourDataLoading = true);

    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final studentAttendanceService = StudentAttendanceService();

    try {
      final data =
          await studentAttendanceService.getStudentAttendanceHourWiseCourses(
        attendanceTemplateId: attendanceTemplateId,
        attendanceData: attendanceDate,
        eid: eid,
        encryptionProvider: encryption,
      );
      setState(() {
        studentAttendanceHourCoursesData = data;
        isHourDataLoading = false;
        isLoaded = true;
      });

      if (data?[0].containsKey("Status")) {
        studentAttendanceHourCoursesData = null;

        snackbarData = data;
        if (snackbarData?[0]["Status"] == "Error") {
          ScaffoldMessenger.of(context)
              .showSnackBar(CustomSnackbar.show(title: snackbarData?[0]["Message"]));
        }
        return;
      }
      log("DATA IN PAGE $data");

      final data2 = await _fetchAttendanceDetailsJson(
          int.parse(data?[0]["attenTransId"]));

      setState(() {
        isHourDataLoading = false;
      });
    } catch (e) {
      setState(() => isHourDataLoading = false);
      log("Error fetching hour-wise courses: $e");
    }
  }

  Future<void> _fetchAttendanceDetailsJson(int transId) async {
    setState(() => isHourDataLoading = true);

    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final studentAttendanceService = StudentAttendanceService();

    try {
      final data = await studentAttendanceService.getAttendanceDetails(
        transId: transId,
        eid: eid,
        encryptionProvider: encryption,
      );
    } catch (e) {
      setState(() => isHourDataLoading = false);
      log("Error fetching hour-wise courses: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      initialDate: initialDate,
    );

    if (pickedDate != null && pickedDate != initialDate) {
      final templateId = int.parse(
          studentAttendenceTemplateData?["dayordertemplateid"] ?? '0');
      final formattedDate =
          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      print("pickeddate $formattedDate");
      await _fetchStudentAttendanceHourCourses(templateId, formattedDate);

      setState(() {
        selectedDate = pickedDate;
        initialDate = pickedDate;
      });
    }
  }

  Widget _buildAttendanceCard(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: InkWell(
        onTap: () async {
          final refetch = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AttendanceListPage(
                    attendanceTransactionId: int.parse(item["attenTransId"]),
                    subjectId: int.parse(item["subid"]),
                    programSectionId: item["programsectionid"],
                    attendanceDate: selectedDate!,
                    dayOrderId: int.parse(item["dayOrderId"]),
                    delegationId: int.parse(item["attendancedelegationid"]),
                    hourId: int.parse(item["hourdesc"]),
                    officeId:
                        int.parse(studentAttendenceTemplateData?["officeid"])),
              ));
          if (refetch == "refetch") {
            await _fetchStudentAttendanceHourCourses(
                int.parse(
                    studentAttendenceTemplateData?["dayordertemplateid"] ??
                        '0'),
                "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}");
          }
        },
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.blue.withOpacity(0.2),
        child: Card(
          color: int.parse(item["attenTransId"]) > 0
              ? Colors.green.shade200
              : Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black)),
          child: Stack(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(12.0),
                title: Text(
                  item['subdesc'] ?? 'No Subject Description',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hour: ${item['hourdesc'] ?? 'N/A'}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87),
                    ),
                    Text("Course Code: ${item['subcode'] ?? 'N/A'}"),
                    Text(
                      "Program: ${item['programsection'] ?? 'N/A'}",
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isTemplateLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: "Student Attendance"),
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),
      );
    }
    return Scaffold(
      appBar: const CustomAppBar(title: "Student Attendance"),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () => _selectDate(context),
                  ),
                  selectedDate == null
                      ? const Text("Select Date")
                      : Text(DateFormat('dd/MM/yyyy').format(selectedDate!)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (isHourDataLoading)
              const Center(child: CircularProgressIndicator())
            else if (studentAttendanceHourCoursesData == null &&
                isLoaded == false)
              const Text(
                "Select a date to check the schedule",
                style: TextStyle(fontSize: 16),
              )
            else if (isLoaded == true &&
                (studentAttendanceHourCoursesData == null ||
                    studentAttendenceTemplateData == null))
              const Text(
                "Select a date to check the schedule",
                style: TextStyle(fontSize: 16),
              )
            else if (studentAttendanceHourCoursesData != null &&
                studentAttendanceHourCoursesData!.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: studentAttendanceHourCoursesData?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = studentAttendanceHourCoursesData![index];
                    return _buildAttendanceCard(item);
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
