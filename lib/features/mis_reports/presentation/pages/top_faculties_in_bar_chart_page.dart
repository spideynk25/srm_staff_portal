import 'dart:developer';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/mis_reports/data/top_faculties_in_bar_chart_service.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';

class TopFacultiesInBarChartPage extends ConsumerStatefulWidget {
  final int classWorkTypeId;
  final int limit;

  const TopFacultiesInBarChartPage({
    super.key,
    required this.classWorkTypeId,
    required this.limit,
  });

  @override
  ConsumerState<TopFacultiesInBarChartPage> createState() =>
      _TopFacultiesInBarChartPageState();
}

class _TopFacultiesInBarChartPageState
    extends ConsumerState<TopFacultiesInBarChartPage> {
  List<dynamic>? topFacultiesInBarChartData;
  bool isLoading = true;
  final Map<String, Color> pieChartColors = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTopFacultiesBarChatData();
    });
  }

  Future<void> _fetchTopFacultiesBarChatData() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final officeId = ref.watch(loginDataProvider)!.officeId;
    final topFacultiesInBarChartService = TopFacultiesInBarChartService();

    try {
      final data = await topFacultiesInBarChartService.getTopLimitFaculty(
        officeId: 2,
        classworkTypeId: widget.classWorkTypeId,
        limit: widget.limit,
        eid: eid,
        encryptionProvider: encryption,
      );

      final parsedData = data?.map((item) {
        final employeename = item['employeename'];

        Color assignedColor =
            Colors.primaries[pieChartColors.length % Colors.primaries.length];
        pieChartColors[employeename] = assignedColor;

        return {
          'total': double.tryParse(item['total'].toString()) ?? 0.0,
          'employeename': employeename,
        };
      }).toList();

      log("Data fetched successfully: $parsedData");
      setState(() {
        topFacultiesInBarChartData = parsedData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("Error fetching topFacultiesInBarChartData data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Top Faculties Bar Chart"),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.black),
            )
          : topFacultiesInBarChartData == null ||
                  topFacultiesInBarChartData!.isEmpty
              ? const Center(child: Text("No data available"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * .70,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                const barsSpace = 20.0;
                                const barsWidth = 20.0;

                                return BarChart(
                                  duration: const Duration(milliseconds: 1000),
                                  BarChartData(
                                    alignment: BarChartAlignment.center,
                                    barTouchData: BarTouchData(
                                      enabled: false,
                                    ),
                                    maxY: topFacultiesInBarChartData!
                                        .map((e) => e['total'] as double)
                                        .reduce((a, b) =>
                                            a > b ? a : b), // Max total value
                                    titlesData: FlTitlesData(
                                      show: true,
                                      topTitles: const AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 75,
                                          getTitlesWidget:
                                              (double value, TitleMeta meta) {
                                            if (value.toInt() <
                                                topFacultiesInBarChartData!
                                                    .length) {
                                              return SideTitleWidget(
                                                meta: meta,
                      

                                                child: Text(
                                                  topFacultiesInBarChartData![
                                                              value.toInt()]
                                                          ['employeename']
                                                      .split('-')[0]
                                                      .toString()
                                                      .split(" ")[0]
                                                      
                                                     ,
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          },
                                        ),
                                      ),
                                      leftTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 40,
                                            interval: 500),
                                      ),
                                      rightTitles: const AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                    ),
                                    gridData: FlGridData(
                                      show: true,
                                      checkToShowHorizontalLine: (value) =>
                                          value % 10 == 0,
                                      getDrawingHorizontalLine: (value) =>
                                          const FlLine(
                                        color: Colors.black26,
                                        strokeWidth: 1,
                                      ),
                                      drawVerticalLine: false,
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: const Border(
                                        bottom: BorderSide(),
                                        left: BorderSide(),
                                      ),
                                    ),
                                    groupsSpace: barsSpace,
                                    barGroups: topFacultiesInBarChartData!
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      int index = entry.key;
                                      var employee = entry.value;
                                      return BarChartGroupData(
                                        x: index,
                                        barsSpace: barsSpace,
                                        barRods: [
                                          BarChartRodData(
                                            toY: employee['total'] as double,
                                            color: pieChartColors[
                                                employee['employeename']],
                                            width: barsWidth,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Departments Legend:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 15),
                            ...topFacultiesInBarChartData!.map(
                              (employee) {
                                final employeename = employee['employeename'];
                                final total = employee['total'] as double;
                                final color = pieChartColors[employeename];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        color: color,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          '$employeename: ${total.toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
