import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/mis_reports/data/lms_report_service.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';

class NotUsedFacultyListPage extends ConsumerStatefulWidget {
  final int officeId;
  final int divisionId; // Assuming you need divisionId as a parameter

  const NotUsedFacultyListPage({
    super.key,
    required this.officeId,
    required this.divisionId,
  });

  @override
  ConsumerState<NotUsedFacultyListPage> createState() =>
      _NotUsedFacultyListPageState();
}

class _NotUsedFacultyListPageState
    extends ConsumerState<NotUsedFacultyListPage> {
  List<dynamic>? notUsedFacultyData; // To hold the fetched data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotUsedFacultyData();
    });
  }

  Future<void> _fetchNotUsedFacultyData() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;

    final lmsReportService = LmsReportService();

    try {
      final data = await lmsReportService.getNotUsedList(
        officeId: widget.officeId,
        divisionId: widget.divisionId,
        eid: eid,
        encryptionProvider: encryption,
      );

      if (data != null && data.isNotEmpty) {
        setState(() {
          notUsedFacultyData = data; // Store the fetched data
          isLoading = false;
        });
      } else {
        setState(() {
          notUsedFacultyData = []; // Default to empty list
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("Error fetching not used faculty list: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(48.0),
            child: LinearProgressIndicator(color: Colors.black),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Not-Used Faculty List"),
      body: notUsedFacultyData == null || notUsedFacultyData!.isEmpty
          ? const Center(
              child: Text(
                "No data available",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: const {
                      0: FixedColumnWidth(80),
                      1: FixedColumnWidth(150),
                      2: FixedColumnWidth(100),
                      3: FixedColumnWidth(100),
                    },
                    children: _buildTableRows(notUsedFacultyData),
                  ),
                ),
              ),
            ),
    );
  }

  List<TableRow> _buildTableRows(List<dynamic>? notUsedFacultyData) {
    List<TableRow> rows = [];

    // Header Row
    rows.add(
      const TableRow(
        decoration: BoxDecoration(color: Color.fromARGB(255, 8, 49, 110)),
        children: [
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              'Employee Code',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              'Employee Name',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              'Designation',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              'Department',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
    // Table Rows
    for (int index = 0; index < (notUsedFacultyData?.length ?? 0); index++) {
      var faculty = notUsedFacultyData![index];
      rows.add(
        TableRow(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.white : Colors.grey.shade300,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                faculty['employeecode'] ?? 'Unknown',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                faculty['employeename'] ?? 'Unknown',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                faculty['designation'] ?? 'Unknown',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                faculty['division'] ?? 'Unknown',
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      );
    }
    return rows;
  }
}
