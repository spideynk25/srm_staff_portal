import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/mis_reports/data/statistics_report_service.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';

class StatisticsReportPage extends ConsumerStatefulWidget {
  final int divisionId;
  final String title;

  const StatisticsReportPage(
      {super.key, required this.divisionId, required this.title});

  @override
  ConsumerState<StatisticsReportPage> createState() =>
      _StatisticsReportPageState();
}

class _StatisticsReportPageState extends ConsumerState<StatisticsReportPage> {
  List<dynamic>? statisticsReportData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchStatisticsReportData();
    });
  }

  Future<void> _fetchStatisticsReportData() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final officeId = ref.watch(loginDataProvider)!.officeId;
    final statisticsReportService = StatisticsReportService();

    try {
      final data =
          await statisticsReportService.getLMSClassWorkTypeWiseUsageStatistics(
        officeId: 2,
        divisionId: widget.divisionId,
        eid: eid,
        encryptionProvider: encryption,
      );
      setState(() {
        statisticsReportData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("Error fetching profile data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: "Statistics Report"),
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: "Statistics Report"),
      backgroundColor: const Color.fromARGB(255, 243, 239, 239),
      body: statisticsReportData == null || statisticsReportData!.isEmpty
          ? const Center(
              child: Text(
                "No data available",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(1),
              child: Card(
                color: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(1),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: const Color.fromARGB(255, 8, 49, 110),
                        padding: const EdgeInsets.all(25),
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Table(
                        border: TableBorder.symmetric(
                          inside: BorderSide(color: Colors.grey.shade300),
                        ),
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(2),
                          4: FlexColumnWidth(1),
                          5: FlexColumnWidth(1),
                          6: FlexColumnWidth(1),
                        },
                        children: [
                          _buildTableHeader(),
                          ..._buildTableRows(statisticsReportData!),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  TableRow _buildTableHeader() {
    return const TableRow(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 8, 49, 110),
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Sl. No.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Employee Name',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Subject',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Division',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Material',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Assignment',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'MCQ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  List<TableRow> _buildTableRows(List<dynamic> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return TableRow(
        decoration: BoxDecoration(
          color: index % 2 == 0 ? Colors.grey[100] : Colors.white,
        ),
        children: [
          _buildTableCell((index + 1).toString()),
          _buildTableCell(item['employeename'] ?? ''),
          _buildTableCell(item['subject'] ?? ''),
          _buildTableCell(item['divisionname'] ?? ''),
          _buildTableCell(item['material'] ?? ''),
          _buildTableCell(item['assignment'] ?? ''),
          _buildTableCell(item['mcq'] ?? ''),
        ],
      );
    }).toList();
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
