import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:srm_staff_portal/features/academic/data/student_attendance_service.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';

class AttendanceListPage extends ConsumerStatefulWidget {
  final int subjectId;
  final int officeId;
  final String programSectionId;
  final int delegationId;
  final DateTime attendanceDate;
  final int dayOrderId;
  final int hourId;
  final int attendanceTransactionId;
  const AttendanceListPage(
      {super.key,
      required this.subjectId,
      required this.programSectionId,
      required this.officeId,
      required this.delegationId,
      required this.attendanceDate,
      required this.dayOrderId,
      required this.hourId,
      required this.attendanceTransactionId});

  @override
  ConsumerState<AttendanceListPage> createState() => _AttendanceListPageState();
}

class _AttendanceListPageState extends ConsumerState<AttendanceListPage> {
  List<Map<dynamic, dynamic>>? studentAttendanceListData;
  DateTime? selectedDate;
  DateTime initialDate = DateTime.now();

  bool isTemplateLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchStudentAttendanceList();
    });
  }

  Future<void> _fetchStudentAttendanceList() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final studentAttendanceService = StudentAttendanceService();
    try {
      dynamic data;
      if (widget.attendanceTransactionId > 0) {
        data = await studentAttendanceService.getAttendanceDetails(
          transId: widget.attendanceTransactionId,
          eid: eid,
          encryptionProvider: encryption,
        );
      } else {
        data = await studentAttendanceService.getStudentAttendanceList(
          officeId: widget.officeId,
          programSectionId: widget.programSectionId,
          subjectId: widget.subjectId,
          eid: eid,
          encryptionProvider: encryption,
        );
      }
      if (widget.attendanceTransactionId > 0) {
        setState(() {
          studentAttendanceListData = (data)
              ?.map((student) => {
                    ...student,
                    'isPresent':
                        student["studentAttendance"] == "P" ? true : false
                  })
              .cast<Map<dynamic, dynamic>>()
              .toList();
          isTemplateLoading = false;
        });
      } else {
        setState(() {
          studentAttendanceListData = (data)
              ?.map((student) => {
                    ...student,
                    'isPresent': true,
                  })
              .cast<Map<dynamic, dynamic>>()
              .toList();
          isTemplateLoading = false;
        });
      }

      log("page $studentAttendanceListData");
    } catch (e) {
      setState(() => isTemplateLoading = false);
      log("Error fetching attendance template data: $e");
    }
  }

  Future<dynamic> _saveStudentAttendance(
    String returnData,
    int subjectId,
    int delegationId,
    DateTime attendanceDate,
    int dayOrderId,
    int hourId,
  ) async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final studentAttendanceService = StudentAttendanceService();

    try {
      final data = await studentAttendanceService.saveStudentAttendance(
        returnData: returnData,
        subjectId: subjectId,
        hourId: hourId,
        delegationId: delegationId,
        dayOrderId: dayOrderId,
        attendanceDate:
            "${attendanceDate.year}-${attendanceDate.month}-${attendanceDate.day}",
        eid: eid,
        encryptionProvider: encryption,
      );
      if (data?["Status"] == "Success") {
        Navigator.pop(context, "refetch");
      }
    } catch (e) {
      setState(() => isTemplateLoading = false);
      log("Error fetching attendance template data: $e");
    }
  }

  Future<dynamic> _cancelStudentAttendance(
    int attendanceTransactionId,
  ) async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final studentAttendanceService = StudentAttendanceService();

    try {
      final data = await studentAttendanceService.cancelStudentAttendance(
        attendanceTransactionId: attendanceTransactionId,
        eid: eid,
        encryptionProvider: encryption,
      );
      if (data?["Status"] == "Success") {
        Navigator.pop(context, "refetch");
      }
    } catch (e) {
      setState(() => isTemplateLoading = false);
      log("Error fetching attendance template data: $e");
    }
  }

  List<Map<dynamic, String>> generateAttendanceMap(String programId) {
    return studentAttendanceListData!.map((student) {
      final uniqueId = student['uniqueid'];
      final isPresent = student['isPresent'] == true ? 'true' : 'false';
      return {"uniqueid": '$uniqueId', "studentAttendance": isPresent};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Attendance List',
        actions: [
          (widget.attendanceTransactionId == 0)
              ? IconButton(
                  onPressed: () async {
                    final attendanceMapList =
                        generateAttendanceMap(widget.programSectionId);
                    log("Generated Attendance Map: $attendanceMapList");
                    await _saveStudentAttendance(
                        jsonEncode(attendanceMapList),
                        widget.subjectId,
                        widget.delegationId,
                        widget.attendanceDate,
                        widget.dayOrderId,
                        widget.hourId);
                  },
                  icon: const Icon(Icons.upload),
                )
              : IconButton(
                  onPressed: () async {
                    await _cancelStudentAttendance(
                        widget.attendanceTransactionId);
                    Navigator.pop(context, "refetch");
                  },
                  icon: const Icon(FontAwesomeIcons.ban))
        ],
      ),
      body: isTemplateLoading
          ? const Center(child: CircularProgressIndicator())
          : studentAttendanceListData == null ||
                  studentAttendanceListData!.isEmpty
              ? const Center(child: Text('No data available'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: GridView.count(
                            crossAxisCount: 3,
                            childAspectRatio: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 0,
                            children: [
                              Container(
                                color: Colors.white,
                                child: const Center(
                                  child: Text(
                                    'Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                child: const Center(
                                  child: Text(
                                    'Reg. No.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                child: const Center(
                                  child: Text(
                                    'Attendance',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              ...studentAttendanceListData!.expand((student) {
                                return [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        student['studentName'] ?? 'Unknown',
                                        style: const TextStyle(fontSize: 12.9),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      student['registerNumber'] ?? 'N/A',
                                      style: const TextStyle(fontSize: 12.9),
                                    ),
                                  ),
                                  Center(
                                    child: IconButton(
                                      onPressed:
                                          widget.attendanceTransactionId == 0
                                              ? () {
                                                  setState(() {
                                                    student['isPresent'] =
                                                        !(student['isPresent']
                                                            as bool);
                                                  });
                                                }
                                              : null,
                                      icon: Icon(
                                        student['isPresent']
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: student['isPresent']
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                ];
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
