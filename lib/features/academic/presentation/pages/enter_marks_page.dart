import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/academic/data/internal_marks_service.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:srm_staff_portal/widgets/custom_snackbar.dart';

class EnterMarksPage extends ConsumerStatefulWidget {
  final Map<String, dynamic>? programSectionData;
  final int breakupId;
  final String selectedDate;
  const EnterMarksPage(
      {super.key,
      required this.programSectionData,
      required this.breakupId,
      required this.selectedDate});

  @override
  ConsumerState<EnterMarksPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends ConsumerState<EnterMarksPage> {
  List<Map<String, dynamic>>? studentsListData;
  List<Map<String, dynamic>> studentsWithExtraData = [];
  bool isLoading = true;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getStudentsList();
    });
  }

  Future<void> _getStudentsList() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final internalMarksService = InternalMarksService();

    try {
      final List? data;
      if (widget.programSectionData?['EnteredCnt'] == "0") {
        data = await internalMarksService.getStudentsList(
          breakupId: widget.breakupId,
          internalBreakUpId:
              int.parse(widget.programSectionData?['InternalBreakUpId']),
          progSectionId:
              int.parse(widget.programSectionData?['programsectionid']),
          eid: eid,
          encryptionProvider: encryption,
        );
      } else {
        data = await internalMarksService.getInternalMarkEntriedDetails(
            progSectionId:
                int.parse(widget.programSectionData?['programsectionid']),
            internalBreakUpId:
                int.parse(widget.programSectionData?['InternalBreakUpId']),
            eid: eid,
            examDate: widget.selectedDate,
            encryptionProvider: encryption);
      }

      setState(() {
        studentsListData = data?.cast<Map<String, dynamic>>();
        studentsWithExtraData = studentsListData!.map((student) {
          return {...student, "absent": false, "marks": 0};
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log('Error fetching profile data: $e');
    }
  }

  List<Map<String, dynamic>> generateAttendanceMap() {
    return studentsWithExtraData.map((student) {
      final uniqueId = "${student['uniqueid']}";
      final isAbsent = student['absent'] == true ? 'true' : 'false';
      final obtainedMarks = student["marks"];
      print(obtainedMarks);
      return {
        "studentid": uniqueId,
        "IsAbsent": isAbsent,
        "markobtained": obtainedMarks.toString()
      };
    }).toList();
  }

  void _saveInternalMarkEntry() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final internalMarksService = InternalMarksService();
    final returnData = jsonEncode(generateAttendanceMap());
    try {
      final data = await internalMarksService.saveInternalMarkEntry(
        returnData: returnData,
        examDate: widget.selectedDate,
        internalBreakUpId:
            int.parse(widget.programSectionData?['InternalBreakUpId']),
        progSectionId:
            int.parse(widget.programSectionData?['programsectionid']),
        eid: eid,
        encryptionProvider: encryption,
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(CustomSnackbar.show(title: "${data?["Message"]}"));
      if (data?["Status"] == "Success") {
        Navigator.pop(context, "refetch");
      }
    } catch (e) {
      log("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Enter Marks'),
        backgroundColor: Color(0xFFF3EFEF),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Enter Marks',
        actions: [
          if (widget.programSectionData?['EnteredCnt'] == "0")
            IconButton(
              icon: const Icon(Icons.upload, color: Colors.white),
              onPressed: _saveInternalMarkEntry,
            ),
        ],
      ),
      body: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color.fromARGB(255, 8, 49, 110),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            'Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 3,
                        child: Center(
                          child: Text(
                            'Reg. No.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      if (widget.programSectionData?['EnteredCnt'] == "0")
                        const Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              'Absent',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      const Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            'Marks',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: studentsWithExtraData.length,
                  itemBuilder: (context, index) {
                    final student = studentsWithExtraData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                student['studentName'] ?? 'Unknown',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: widget.programSectionData?['EnteredCnt'] !=
                                      "0"
                                  ? Center(
                                      child: Text(
                                        student['registerNumber'] ?? 'N/A',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    )
                                  : Text(
                                      student['registerNumber'] ?? 'N/A',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                            ),
                          ),
                          if (widget.programSectionData?['EnteredCnt'] == "0")
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Checkbox(
                                  value: student['absent'],
                                  onChanged: (value) {
                                    setState(() {
                                      studentsWithExtraData[index]['absent'] =
                                          value!;
                                      studentsWithExtraData[index]['marks'] =
                                          value
                                              ? 0
                                              : student['conductingMaxMarks'];
                                    });
                                  },
                                ),
                              ),
                            ),
                          if (widget.programSectionData?['EnteredCnt'] == "0")
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextFormField(
                                  enabled: !student['absent'],
                                  initialValue: student['marks'].toString(),
                                  decoration: const InputDecoration(
                                      hintText: 'Mark',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 8.0),
                                      border: OutlineInputBorder(),
                                      errorStyle: TextStyle(
                                        fontSize: 17,
                                      )),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      studentsWithExtraData[index]['marks'] =
                                          int.tryParse(value) ?? 0;
                                    });
                                  },
                                  validator: (value) {
                                    final intValue = int.tryParse(value ?? '');
                                    if (intValue == null) {
                                      return 'Please enter a valid number';
                                    }
                                    if (intValue >
                                        int.parse(
                                            student["conductingMaxMarks"])) {
                                      return '/${student["conductingMaxMarks"]}';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          if (int.parse(
                                  widget.programSectionData?['EnteredCnt']) >
                              0)
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Center(
                                  child: Text(
                                    student['markobtained'] ?? 'N/A',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
      ),
    );
  }
}
