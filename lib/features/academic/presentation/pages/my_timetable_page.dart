import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/academic/data/my_timetable_service.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';



class MyTimetablePage extends ConsumerStatefulWidget {
  const MyTimetablePage({super.key});

  @override
  ConsumerState<MyTimetablePage> createState() => _MyTimetablePageState();
}

class _MyTimetablePageState extends ConsumerState<MyTimetablePage> {
  List<Map<String, dynamic>>? employeeTimeTableData;
  bool isLoading = true;

  final myTimetableService = MyTimetableService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchStudentAttendenceTemplateData();
    });
  }

  Future<void> _fetchStudentAttendenceTemplateData() async {
    try {
      final encryption = ref.read(encryptionProvider.notifier);
      final eid = ref.watch(loginDataProvider)!.eid;

      final attendanceTemplate =
          await myTimetableService.getStudentAttendanceTemplateJson(
        eid: eid,
        encryptionProvider: encryption,
      );
      log("Fetched Attendance Template: $attendanceTemplate");

      final templateId =
          int.parse(attendanceTemplate?["dayordertemplateid"] ?? '0');
      await _fetchEmployeeTimeTable(templateId);
    } catch (e) {
      log("Error fetching attendance template: $e");
      setState(() {
        isLoading = false;
        employeeTimeTableData = [];
      });
    }
  }

  Future<void> _fetchEmployeeTimeTable(int templateId) async {
    try {
      final encryption = ref.read(encryptionProvider.notifier);
      final eid = ref.watch(loginDataProvider)!.eid;

      final timetableData = await myTimetableService.getEmployeeTimeTableJson(
        templateId: templateId,
        eid: eid,
        encryptionProvider: encryption,
      );

      log("Fetched Employee Timetable Data: $timetableData");
      setState(() {
        isLoading = false;
        employeeTimeTableData = List<Map<String, dynamic>>.from(timetableData!);
      });
    } catch (e) {
      log("Error fetching employee timetable: $e");
      setState(() {
        isLoading = false;
        employeeTimeTableData = [];
      });
    }
  }

  String formatTime(String time) {
    final parts = time.split(':');
    return "${parts[0]}:${parts[1]}";
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
         appBar: CustomAppBar(title: "My Timetable"),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (employeeTimeTableData == null || employeeTimeTableData!.isEmpty) {
      return const Scaffold(
        appBar: CustomAppBar(title: "My Timetable"),
        body: Center(
          child: Text("No Timetable Data Available"),
        ),
      );
    }

    // Group data by day and sort by hours
    final groupedData = <String, List<Map<String, dynamic>>>{};
    for (var entry in employeeTimeTableData!) {
      final day = entry["dayorderdesc"];
      groupedData.putIfAbsent(day, () => []).add(entry);
    }

    // Extract unique time slots dynamically
    final timeSlots = employeeTimeTableData!
        .map((entry) =>
            "${formatTime(entry['fromtime'])} - ${formatTime(entry['totime'])}")
        .toSet()
        .toList();

    // Extract unique subjects for the legend
    final subjectLegend = {
      for (var entry in employeeTimeTableData!)
        if (entry["subjectcode"] != null && entry["subjectcode"] != "-")
          entry["subjectcode"]: entry["subjectdesc"]
    };

    final sortedDays = groupedData.keys.toList();

    return Scaffold(
      appBar: const CustomAppBar(title: "My Timetable"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 20,
                      horizontalMargin: 10,
                       headingRowColor: WidgetStateProperty.all(
                          const Color.fromARGB(255, 8, 49, 110)),
                        columns: [
                          const DataColumn(
                            label: Text("Day/Hour",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                          ...timeSlots.map(
                            (slot) => DataColumn(
                              label: Center(
                                child: Text(
                                  slot.replaceAll(" - ", "\n"),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        rows: sortedDays.map((day) {
                          final dayEntries = groupedData[day] ?? [];

                          final hourData = timeSlots.map((slot) {
                            final entry = dayEntries.firstWhere(
                              (e) =>
                                  "${formatTime(e['fromtime'])} - ${formatTime(e['totime'])}" ==
                                  slot,
                              orElse: () => {"subjectcode": "-"},
                            );
                            return entry["subjectcode"];
                          }).toList();

                          return DataRow(
                            cells: [
                              DataCell(Text(day)),
                              ...hourData.map(
                                (subjectCode) => DataCell(
                                  Center(
                                    child: Text(
                                      subjectCode ?? "-",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: subjectCode == "-"
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Legend Container
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                   border: Border.all(
                            color: Colors.black45,
                            width: 1),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Subject Legend:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...subjectLegend.entries.map((entry) {
                        return Column(
                          children: [
                            Text(
                              "${entry.value}",
                              style: const TextStyle(fontSize: 14,),
                            ),
                            const SizedBox(height: 8)
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
