import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/mis_reports/data/faculty_services.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';


class TodayAbsentee extends ConsumerStatefulWidget {
  const TodayAbsentee({super.key});

  @override
  ConsumerState<TodayAbsentee> createState() => TodayAbsenteeState();
}

class TodayAbsenteeState extends ConsumerState<TodayAbsentee> {
  List<dynamic>? attendanceData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTodaysAbsentee();
    });
  }

  Future<void> fetchTodaysAbsentee() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final facultyService = FacultyServices();

    try {
      final response = await facultyService.getTodayAbsentee(
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        appBar:CustomAppBar(title: 'Today Absentee'),
        backgroundColor: Color.fromARGB(255, 243, 239, 239),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:CustomAppBar(title: 'Today Absentee'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              border: TableBorder.all(color: Colors.transparent, width: 0),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FixedColumnWidth(100),
                1: FixedColumnWidth(100),
                2: FixedColumnWidth(175),
                3: FixedColumnWidth(150),
                4: FixedColumnWidth(150),
              },
              children: _buildTableRows(attendanceData),
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
                'Day Order',
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
                'Hour',
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
                'Program',
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
                'Student Name',
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
                'Register Number',
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
      rows.add(
        TableRow(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.white : Colors.grey.shade300,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  attendance['dayorder'].toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  attendance['hour'].toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  attendance['program'].toString(),
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  attendance['studentname'].toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  attendance['registerno'].toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
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