import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/mis_reports/data/lms_report_service.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/components/lms_custom_list_tile.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/lms_not_used_faculty_list.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/lms_usage_statistics.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/statistics_report_page.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/top_dept_in_pie_chart_page.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/top_faculties_in_bar_chart_page.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';


class LmsReportPage extends ConsumerStatefulWidget {
  const LmsReportPage({super.key});

  @override
  ConsumerState<LmsReportPage> createState() => _LmsReportState();
}

class _LmsReportState extends ConsumerState<LmsReportPage> {
  List<dynamic>? shiftList;
  List<dynamic>? departmentList;
  List<dynamic>? classworkList;
  List<dynamic>? limitList = [
    {"limitName": "Top 3", "limitValue": 3},
    {"limitName": "Top 5", "limitValue": 5},
    {"limitName": "Top 10", "limitValue": 10},
  ];
  Map<String, dynamic>? result = {
    "shiftData": null,
    "departmentData": null,
    "classworkData": null,
    "limitData": null,
  };
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLmsReportData();
    });
    _fetchLmsReportData();
  }

  Future<void> _fetchLmsReportData() async {
    log("$result");
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final officeId = ref.watch(loginDataProvider)!.officeId;
    final lmsReportService = LmsReportService();
    log("officeid $officeId");
    try {
      final shiftListData = await lmsReportService.getOfficesList(
        eid: eid,
        encryptionProvider: encryption,
      );
      log("$shiftListData");
      setState(() {
        shiftList = shiftListData;
        //isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("Error fetching profile data: $e");
      return;
    }
    try {
      final departmentListData = await lmsReportService.getDivisionsList(
          //officeId:int.parse(officeId),
          officeId: 2,
          eid: eid,
          encryptionProvider: encryption);
      setState(() {
        departmentList = departmentListData;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("Error fetching lms_report_page data: $e");
      return;
    }

    try {
      final classworkListData = await lmsReportService.getClassWorkTypeList(
          eid: eid, encryptionProvider: encryption);
      setState(() {
        classworkList = classworkListData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("Error fetching lms_report_page data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'LMS Report'),
        backgroundColor: Color.fromARGB(255, 243, 239, 239),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: 'LMS Report'),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 8, 49, 110),
                        width: 2.0,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                  hint: const Text("Shift"),
                  icon: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 8, 49, 110),
                    ),
                    width: 20,
                    height: 20,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  isExpanded: true,
                  items: shiftList!.map((item) {
                    return DropdownMenuItem<String>(
                      value: item["officename"],
                      child: Text(item["officename"]),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      result?["shiftData"] = shiftList!
                          .where((data) => data["officename"] == newValue)
                          .toList();
                    });
                    log("$result");
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 8, 49, 110),
                        width: 2.0,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                  hint: const Text("Department"),
                  icon: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 8, 49, 110),
                    ),
                    width: 20,
                    height: 20,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  isExpanded: true,
                  items: departmentList!.map((item) {
                    return DropdownMenuItem<String>(
                      value: item["divisionname"],
                      child: Text(item["divisionname"]),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      result?["departmentData"] = departmentList!
                          .where((data) => data["divisionname"] == newValue)
                          .toList();
                    });
                    log("result $result");
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 8, 49, 110),
                        width: 2.0,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                  icon: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 8, 49, 110),
                    ),
                    width: 20,
                    height: 20,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  hint: const Text("Classwork"),
                  isExpanded: true,
                  items: classworkList!.map((item) {
                    return DropdownMenuItem<String>(
                      value: item["classworktype"],
                      child: Text(item["classworktype"]),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      result?["classworkData"] = classworkList!
                          .where((data) => data["classworktype"] == newValue)
                          .toList();
                    });
                    log("$result");
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 8, 49, 110),
                        width: 2.0,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                  icon: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 8, 49, 110),
                    ),
                    width: 20,
                    height: 20,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  hint: const Text("Limit"),
                  isExpanded: true,
                  items: limitList!.map((item) {
                    return DropdownMenuItem<String>(
                      value: item["limitName"],
                      child: Text(item["limitName"]),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      result?["limitData"] = limitList!
                          .where((data) => data["limitName"] == newValue)
                          .toList();
                    });
                    log("$result");
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                LmsCustomListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StatisticsReportPage(
                              divisionId: int.parse(
                                  result?["departmentData"][0]["divisionid"]),
                              title: result?["departmentData"][0]
                                  ["divisionname"]),
                        ));
                  },
                  name: "STATISTICS REPORT",
                ),
                const SizedBox(
                  height: 10,
                ),
                LmsCustomListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopDeptInPieChartPage(
                              classWorkTypeId: int.parse(
                                  result?["classworkData"][0]["classworktypeid"]),
                              limit: result?["limitData"][0]["limitValue"]),
                        ),
                      );
                    },
                    name: "TOP DEPT. IN PIE CHART"),
                const SizedBox(
                  height: 10,
                ),
                LmsCustomListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopFacultiesInBarChartPage(
                              classWorkTypeId: int.parse(
                                  result?["classworkData"][0]["classworktypeid"]),
                              limit: result?["limitData"][0]["limitValue"]),
                        ),
                      );
                    },
                    name: "TOP FACULTIES IN BAR CHART"),
                const SizedBox(
                  height: 10,
                ),
                LmsCustomListTile(
                    onTap: () {
                      if (result?["departmentData"] != null &&
                          result?["departmentData"].isNotEmpty &&
                          result?["shiftData"] != null &&
                          result?["shiftData"].isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LmsUsageStatisticsPage(
                              divisionId: int.parse(
                                  result?["departmentData"][0]["divisionid"]),
                              officeId: int.parse(
                                  result?["shiftData"][0]["officeid"]),
                            ),
                          ),
                        );
                      } else {
                        log("One or more data sets are null");
                      }
                    },
                    name: "LMS USAGE STATISTICS"),
                const SizedBox(
                  height: 10,
                ),
                LmsCustomListTile(
                  onTap: () {
                    if (result?["departmentData"] != null &&
                        result?["departmentData"].isNotEmpty &&
                        result?["shiftData"] != null &&
                        result?["shiftData"].isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotUsedFacultyListPage(
                            divisionId: int.parse(
                                result?["departmentData"][0]["divisionid"]),
                            officeId:
                                int.parse(result?["shiftData"][0]["officeid"]),
                          ),
                        ),
                      );
                    } else {
                      log("One or more data sets are null");
                    }
                  },
                name: "LMS NOT USED FACULTY LIST"),
              ],
            ),
          ),
        ));
  }
}
