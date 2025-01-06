import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/mis_reports/data/lms_report_service.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';


class LmsUsageStatisticsPage extends ConsumerStatefulWidget {
  final int officeId;
  final int divisionId;

  const LmsUsageStatisticsPage({
    super.key,
    required this.officeId,
    required this.divisionId,
  });

  @override
  ConsumerState<LmsUsageStatisticsPage> createState() =>
      _LmsUsageStatisticsPageState();
}

class _LmsUsageStatisticsPageState extends ConsumerState<LmsUsageStatisticsPage> {
  List<dynamic>? usageData;
  Map<String, double>? usedDataMap = {};
  Map<String, double>? notUsedDataMap = {};
  String overAllFacultyCount = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUsageData();
    });
  }

  Future<void> _fetchUsageData() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;

    final lmsReportService = LmsReportService();

    try {
      final data = await lmsReportService.getUsedNotUsedCount(
        officeId: widget.officeId,
        divisionId: widget.divisionId,
        eid: eid,
        encryptionProvider: encryption,
      );

      if (data != null && data.isNotEmpty) {
        final Map<String, double> usedMap = {};
        final Map<String, double> notUsedMap = {};
        String facultyCount = '';

        for (var entry in data) {
          if (entry.containsKey('overallfacultycount')) {
            facultyCount = entry['overallfacultycount'];
          }
          if (entry.containsKey('usedfacultycount')) {
            usedMap[entry['usedclassworktype']] =
                double.parse(entry['usedfacultycount']);
          }
          if (entry.containsKey('notusedfacultycount')) {
            notUsedMap[entry['notusedclassworktype']] =
                double.parse(entry['notusedfacultycount']);
          }
        }

        setState(() {
          usageData = data;
          usedDataMap = usedMap;
          notUsedDataMap = notUsedMap;
          overAllFacultyCount = facultyCount;
          isLoading = false;
        });
      } else {
        setState(() {
          usageData = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("Error fetching usage statistics: $e");
    }
  }

  Widget buildPieChart(String title, Map<String, double>? dataMap) {
    if (dataMap == null || dataMap.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          Center(
            child: Text(
              'No data available for $title',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 50),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 25),
        PieChart(
          dataMap: dataMap,
          chartType: ChartType.ring,
          animationDuration: const Duration(milliseconds: 800),
          chartLegendSpacing: 64,
          chartRadius: MediaQuery.of(context).size.width / 3.2,
          colorList: const [Colors.green, Colors.blue, Colors.orange, Colors.red],
          legendOptions: const LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            legendTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValuesInPercentage: true,
            decimalPlaces: 2,
            chartValueStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: "LMS Usage Statistics"),
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),
      );
    }

    return Scaffold(
     appBar: CustomAppBar(title: "LMS Usage Statistics"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall Faculty Count: $overAllFacultyCount',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              buildPieChart('Used Faculty Count:', usedDataMap),
              buildPieChart('Not Used Faculty Count:', notUsedDataMap),
            ],
          ),
        ),
      ),
    );
  }
}
