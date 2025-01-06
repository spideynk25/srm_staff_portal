import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/mis_reports/data/top_dept_in_pie_chart_service.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';

class TopDeptInPieChartPage extends ConsumerStatefulWidget {
  final int classWorkTypeId;
  final int limit;

  const TopDeptInPieChartPage({
    super.key,
    required this.classWorkTypeId,
    required this.limit,
  });

  @override
  ConsumerState<TopDeptInPieChartPage> createState() =>
      _TopDeptInPieChartPageState();
}

class _TopDeptInPieChartPageState extends ConsumerState<TopDeptInPieChartPage> {
  List<dynamic>? topDeptPieChartData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDeptPieChartData();
    });
  }

  Future<void> _fetchDeptPieChartData() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final officeId = ref.watch(loginDataProvider)!.officeId;
    final topDeptInPieChartService = TopDeptInPieChartService();

    try {
      final data = await topDeptInPieChartService.getTopLimitDept(
        officeId: 2,
        classworkTypeId: widget.classWorkTypeId,
        limit: widget.limit,
        eid: eid,
        encryptionProvider: encryption,
      );
      log("Data fetched successfully: $data");
      setState(() {
        topDeptPieChartData = data;
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
    final pieChartData = <String, double>{};
    final List<Color> pieChartColors = [];
    double totalSum = 0.0;

    if (topDeptPieChartData != null) {
      for (int i = 0; i < topDeptPieChartData!.length; i++) {
        final item = topDeptPieChartData![i];
        final departmentName = item["divisionname"] ?? "Unknown";
        final total = double.tryParse(item["total"]?.toString() ?? "0") ?? 0.0;

        pieChartData[departmentName] = total;
        totalSum += total;
        pieChartColors.add(
          Colors.primaries[i % Colors.primaries.length],
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Top Department in Pie Chart"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : pieChartData.isEmpty
              ? const Center(child: Text("No data available"))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        const SizedBox(height: 25),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: PieChart(
                            dataMap: pieChartData,
                            chartType: ChartType.ring,
                            colorList: pieChartColors, 
                            legendOptions: const LegendOptions(
                              showLegends: false, 
                            ),
                            chartValuesOptions: ChartValuesOptions(
                              chartValueBackgroundColor: Colors.blue.shade100,
                              showChartValuesInPercentage: true,
                              showChartValuesOutside: true,
                              chartValueStyle:const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              decimalPlaces: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          'Departments Legend:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...pieChartData.entries.map(
                          (entry) {
                            final index =
                                pieChartData.keys.toList().indexOf(entry.key);
                            final percentage =
                                (entry.value / totalSum * 100).toStringAsFixed(2);
                            return Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  color: pieChartColors[index],
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${entry.key} - $percentage%',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 30,)
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
