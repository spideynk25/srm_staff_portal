import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/leave/data/leave_approval_service.dart';
import 'package:srm_staff_portal/features/leave/presentation/pages/leave_approval_details_page.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';


class LeaveApprovalPage extends ConsumerStatefulWidget {
  const LeaveApprovalPage({super.key});

  @override
  ConsumerState<LeaveApprovalPage> createState() => _LeaveApprovalPageState();
}

class _LeaveApprovalPageState extends ConsumerState<LeaveApprovalPage> {
  List<dynamic>? leaveApprovalData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLeaveApprovalData();
    });
  }

  final leaveApprovalService = LeaveApprovalService();

  Future<void> _fetchLeaveApprovalData() async {
    isLoading = true;
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;

    try {
      final data = await leaveApprovalService.getLeavesApprovalDetails(
        eid: eid,
        encryptionProvider: encryption,
      );
      log("$data");
      setState(() {
        leaveApprovalData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("Error fetching leave approval data: $e");
    }
  }

  Future<void> approveLeave(int leaveApplicationid, int leaveStatus) async {
    try {
      log("page $leaveStatus");
      isLoading = true;
      final eid = ref.watch(loginDataProvider)!.eid;
      final encryption = ref.read(encryptionProvider.notifier);
      final data = await leaveApprovalService.approveLeave(
        leaveApplicationId: leaveApplicationid,
        leaveStatus: leaveStatus,
        approvalemployeeid: eid,
        encryptionProvider: encryption,
      );
      log("$data");
      _fetchLeaveApprovalData();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("Error fetching leave approval data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        appBar:CustomAppBar(title: 'Leave Approval'),
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),
      );
    }
    if (leaveApprovalData == null) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Leave Approval'),
        body: Center(
          child: Text(
            "No Pending Leave Application",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ),
      );
    }
    return Scaffold(
      appBar:const CustomAppBar(title: 'Leave Approval'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: leaveApprovalData!.length,
          itemBuilder: (context, index) {
            final leave = leaveApprovalData![index];
            return Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            leave['employeename'],
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  approveLeave(
                                      int.parse(leave["leaveapplicationid"]),
                                      1);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 12.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  'Approve',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              ElevatedButton(
                                onPressed: () {
                                  approveLeave(
                                      int.parse(leave["leaveapplicationid"]),
                                      9);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 6.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  'Reject',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        "Reason: ${leave['reason']}",
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        height: 2,
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LeaveApprovalDetailsPage(
                                  leaveData: leave,
                                  approveLeave: approveLeave,
                                ),
                              ));
                        },
                        label: const Text(
                          "Details",
                          style: TextStyle(fontSize: 16),
                        ),
                        icon: const Icon(
                          Icons.keyboard_double_arrow_right,
                          size: 17,
                        ),
                        iconAlignment: IconAlignment.end,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
