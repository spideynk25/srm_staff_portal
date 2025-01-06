import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/mis_reports/data/management_services.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';

class StaffAttendance extends ConsumerStatefulWidget {
  final int from;
  const StaffAttendance({super.key, required this.from});

  @override
  ConsumerState<StaffAttendance> createState() => StaffAttendanceState();
}

class StaffAttendanceState extends ConsumerState<StaffAttendance> {
  List<dynamic>? attendanceData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchStaffDetails();
    });
  }

  Future<void> fetchStaffDetails() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final managementService = ManagementServices();

    try {
      final response = await managementService.getStaffDetails(
        eid: eid,
        encryptionProvider: encryption,
      );

      if (response != null && response['Status'] == 'Success') {
        attendanceData = response['Data'];
      } else {
        // Handle the error case
        log("Error: ${response?['Message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      log("Error fetching attendance data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Color getRowColor(String dateStr) {
    final date = DateFormat('dd-MMM-yyyy').parse(dateStr);
    final today = DateTime.now();
    // final yesterday = today.subtract(const Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return Colors.pink.shade200; // Today's date color
    } else if (date.year <= today.year &&
        date.month <= today.month &&
        date.day < today.day) {
      return Colors.green.shade200; // Past dates color
    } else {
      return Colors.orange.shade200; // Future dates color
    }
  }

  @override
  Widget build(BuildContext context) {
    late String title;
    if (widget.from == 1) {
      title = 'Staff Attendance';
    } else {
      title = 'Staff Leave';
    }

    if (isLoading) {
      return Scaffold(
        appBar: CustomAppBar(title: title),
        backgroundColor: Color.fromARGB(255, 243, 239, 239),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
     appBar: CustomAppBar(title: title),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Table(
                  border:
                      TableBorder.all(color: Colors.grey.shade100, width: 2),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: FixedColumnWidth(120),
                    1: FixedColumnWidth(100),
                    2: FixedColumnWidth(100),
                    3: FixedColumnWidth(100),
                    4: FixedColumnWidth(100),
                  },
                  children: _buildTableRows(attendanceData),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 45, vertical: 22.5),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: Colors.green.shade200,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Previous Day',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 30),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: Colors.pink.shade200,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Current Day',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 30),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: Colors.orange.shade200,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Future Day',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> _buildTableRows(List<dynamic>? attendanceData) {
    List<TableRow> rows = [];

    // Header Row
    rows.add(
      TableRow(
        decoration: BoxDecoration(
          color: Colors.blue.shade800,
        ),
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Date',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Leave Count',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'OD Count',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Permission Count',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Late Count',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Data Rows with Alternative Colors
    for (int index = 0; index < (attendanceData?.length ?? 0); index++) {
      var attendance = attendanceData![index];
      final rowColor = getRowColor(attendance['disleavedate'].toString());

      rows.add(
        TableRow(
          decoration: BoxDecoration(
            color: rowColor,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  attendance['disleavedate'].toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  attendance['leavecnt'].toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  attendance['odcnt'].toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  attendance['permissioncnt'].toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  attendance['latecnt'].toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return rows;
  }
}
