import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/notification/data/send_notification_to_students_service.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:srm_staff_portal/widgets/custom_snackbar.dart';


class SendNotificationStudentList extends ConsumerStatefulWidget {
  final Map<String, dynamic> employeeListData;
  const SendNotificationStudentList(
      {super.key, required this.employeeListData});

  @override
  ConsumerState<SendNotificationStudentList> createState() =>
      _SendNotificationStudentListState();
}

class _SendNotificationStudentListState
    extends ConsumerState<SendNotificationStudentList> {
  List<dynamic>? studentsListData;
  List<dynamic>? filteredStudentsList;
  List<bool> selectedStudents = [];
  bool isSelectAll = false;
  bool isLoading = true;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final sendNotificationToStudentsService = SendNotificationToStudentsService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getStudentList());
    _searchController.addListener(_filterStudents);
  }

  Future<void> _getStudentList() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    try {
      final data =
          await sendNotificationToStudentsService.getStudentListDetails(
        subjectId: int.parse(widget.employeeListData["subjectid"]),
        programSectionId:
            int.parse(widget.employeeListData["programsectionid"]),
        eid: eid,
        encryptionProvider: encryption,
      );
      if (mounted) {
        setState(() {
          studentsListData = data;
          filteredStudentsList = List.from(data ?? []);
          selectedStudents = List<bool>.filled(data?.length ?? 0, false);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
      log("Error fetching student data: $e");
    }
  }

  void _filterStudents() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredStudentsList = List.from(studentsListData ?? []);
      });
    } else {
      setState(() {
        filteredStudentsList = studentsListData
            ?.where((student) =>
                (student['studentName'] ?? '').toLowerCase().contains(query) ||
                (student['registerNumber'] ?? '').toLowerCase().contains(query))
            .toList();
      });
    }
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      isSelectAll = value ?? false;
      selectedStudents =
          List<bool>.filled(filteredStudentsList?.length ?? 0, isSelectAll);
    });
  }

  void _sendNotification() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;

    final selectedStudentsData = filteredStudentsList!
        .asMap()
        .entries
        .where((entry) => selectedStudents[entry.key])
        .map((entry) => {"uniqueid": entry.value['uniqueid']})
        .toList();

    final returnData = jsonEncode(selectedStudentsData);
    final message = _messageController.text;

    try {
      final data = await sendNotificationToStudentsService.sendNotification(
        returnData: returnData,
        subjectId: int.parse(widget.employeeListData["subjectid"]),
        notificationMessage: message,
        eid: eid,
        encryptionProvider: encryption,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackbar.show(title: data?["Message"] ?? "Notification sent successfully!")
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
       CustomSnackbar.show(title: "Error: $e")
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Send Notification to Students"),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : studentsListData == null || studentsListData!.isEmpty
              ? const Center(child: Text("No students available."))
              : Column(
                  children: [
                    // Message input
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your message here...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    onPressed: _sendNotification,
                                    style: IconButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 8, 49, 110),
                                    ),
                                    icon: const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color.fromARGB(255, 8, 49, 110),
                          ),
                          hintText: "Search by name or register number...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Table for student list
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            horizontalMargin: 10,
                            columnSpacing: 23,
                            headingRowColor: WidgetStateColor.resolveWith(
                                (states) =>
                                    const Color.fromARGB(255, 8, 49, 110)),
                            columns: [
                              DataColumn(
                                label: Row(
                                  children: [
                                    Checkbox(
                                      value: isSelectAll,
                                      onChanged: _toggleSelectAll,
                                      fillColor: WidgetStateColor.resolveWith(
                                          (states) => Colors.white),
                                      checkColor: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              const DataColumn(
                                  label: Text('Name',
                                      style: TextStyle(color: Colors.white))),
                              const DataColumn(
                                  label: Text('Register Number',
                                      style: TextStyle(color: Colors.white))),
                            ],
                            rows: filteredStudentsList!
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key;
                              final student = entry.value;
                              return DataRow(
                                cells: [
                                  DataCell(Checkbox(
                                    value: selectedStudents[index],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedStudents[index] =
                                            value ?? false;
                                        isSelectAll =
                                            !selectedStudents.contains(false);
                                      });
                                    },
                                  )),
                                  DataCell(Text(
                                      student['studentName'] ?? 'Unknown')),
                                  DataCell(Text(
                                      student['registerNumber'] ?? 'Unknown')),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
