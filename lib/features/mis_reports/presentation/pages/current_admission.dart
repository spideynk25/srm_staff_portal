import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:srm_staff_portal/encryption_provider.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/mis_reports/data/management_services.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';


class CurrentAdmission extends ConsumerStatefulWidget {
  const CurrentAdmission({super.key});

  @override
  ConsumerState<CurrentAdmission> createState() => CurrentAdmissionState();
}

class CurrentAdmissionState extends ConsumerState<CurrentAdmission> {
  Map<String, dynamic>? managementData;
  List<int> officeIds = [];
  int shift1Count = 0;
  int shift2Count = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAdmissionDetails();
    });
  }

  Future<void> fetchAdmissionDetails() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final managementService = ManagementServices();

    try {
      final data = await managementService.getAdmissionList(
        eid: eid,
        encryptionProvider: encryption,
      );
      print(data);

      setState(() {
        managementData = data;
        isLoading = false;
      });

      if (managementData != null && managementData!['Data'] != null) {
        // Fetch both office IDs
        officeIds = managementData!['Data']
            .map<int>((item) => int.parse(item['officeid']))
            .toList();

        // Fetch department admissions for both office IDs
        for (var officeId in officeIds) {
          await fetchDeptAdmission(officeId, eid, encryption);
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching profile data: $e");
    }
  }

  Future<void> fetchDeptAdmission(
      int officeId, String eid, EncryptionProvider encryptionProvider) async {
    final managementService = ManagementServices();

    try {
      final data = await managementService.getDeptAdmission(
        officeId: officeId,
        eid: eid,
        encryptionProvider: encryptionProvider,
      );
      print("Department Admission Data for Office ID $officeId: $data");

      if (data != null && data['Data'] != null) {
        for (var program in data['Data']) {
          int admissionCount = int.parse(program['admissioncnt']);
          setState(() {
            if (officeId == 1) {
              shift1Count += admissionCount;
            } else if (officeId == 2) {
              shift2Count += admissionCount;
            }
          });
        }
      }
    } catch (e) {
      print("Error fetching department admission data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: "Current Admission"),
        backgroundColor: Color.fromARGB(255, 243, 239, 239),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Current Admission"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .70,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final barsSpace = 15.0 * constraints.maxWidth / 100;
                    final barsWidth = 40.0 * constraints.maxWidth / 100;

                    return BarChart(
                      duration: const Duration(milliseconds: 800),
                      BarChartData(
                        alignment: BarChartAlignment.center,
                        barTouchData: BarTouchData(
                          enabled: false,
                        ),
                        maxY: 3000,
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0:
                                    return const Text(
                                      'Shift I',
                                      style: TextStyle(
                                        color: Colors.black,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  case 1:
                                    return const Text(
                                      'Shift II',
                                      style: TextStyle(
                                        color: Colors.black,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  default:
                                    return const Text('');
                                }
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 100),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          checkToShowHorizontalLine: (value) => value % 10 == 0,
                          getDrawingHorizontalLine: (value) => const FlLine(
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
                        barGroups: getData(barsWidth, barsSpace),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 45, vertical: 22.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: Colors.blue.shade500,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Shift I - $shift1Count',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: Colors.purple.shade500,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Shift II - $shift2Count',
                        style: const TextStyle(
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
    );
  }

  List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: shift1Count.toDouble(),
            color: Colors.blue.shade500,
            width: barsWidth,
            borderRadius: BorderRadius.zero,
            /* backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 3000,
              color: Colors.grey.shade300,
            ), */
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: shift2Count.toDouble(),
            color: Colors.purple.shade500,
            width: barsWidth,
            borderRadius: BorderRadius.zero,
            /* backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 3000,
              color: Colors.grey.shade300,
            ), */
          ),
        ],
      ),
    ];
  }
}
