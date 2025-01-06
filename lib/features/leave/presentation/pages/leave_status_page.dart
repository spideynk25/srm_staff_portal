import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/leave/data/leave_status_service.dart';
import 'package:srm_staff_portal/features/leave/presentation/components/detailed_row.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';


class LeaveStatusPage extends ConsumerStatefulWidget {
  const LeaveStatusPage({super.key});

  @override
  ConsumerState<LeaveStatusPage> createState() => _LeaveStatusPageState();
}

class _LeaveStatusPageState extends ConsumerState<LeaveStatusPage> {
  List<dynamic>? leaveStatusData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLeaveStatusData();
    });
  }

  Future<void> _fetchLeaveStatusData() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final leaveStatusService = LeaveStatusService();

    try {
      final data = await leaveStatusService.getLeaveStatusDetails(
        eid: eid,
        encryptionProvider: encryption,
      );
      log("$data");
      setState(() {
        leaveStatusData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("Error fetching leave status data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: "Leave Status"),
        backgroundColor: Color.fromARGB(255, 243, 239, 239),
        body: Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: "Leave Status"),
      backgroundColor: const Color.fromARGB(255, 243, 239, 239),
      body: leaveStatusData == null || leaveStatusData!.isEmpty
          ? const Center(
              child: Text(
                "No leave applications found.",
                style: TextStyle(color: Colors.black),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: leaveStatusData!.length,
              itemBuilder: (context, index) {
                final leave = leaveStatusData![index];

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45, width: 1),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailedRow(
                        label: "Application Date",
                        value: leave['applicationdate'],
                        icon: Icons.calendar_today,
                      ),
                      DetailedRow(
                        label: "Leave Type",
                        value: leave['leavetype'],
                        icon: Icons.question_answer,
                      ),
                      DetailedRow(
                        label: "From Date",
                        value: leave['fromdate'],
                        icon: Icons.calendar_month,
                      ),
                      DetailedRow(
                        label: "To Date",
                        value: leave['todate'],
                        icon: Icons.calendar_month,
                      ),
                      DetailedRow(
                        label: "Session",
                        value: leave['session'],
                        icon: Icons.schedule,
                      ),
                      DetailedRow(
                        label: "Reason",
                        value: leave['reason'],
                        icon: Icons.comment,
                      ),
                      DetailedRow(
                        label: "No. of Days",
                        value: leave['noofdays'].toString(),
                        icon: Icons.numbers,
                      ),
                      DetailedRow(
                        label: "Leave Status",
                        value: leave['leavestatus'],
                        icon: Icons.info_outline,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

}
