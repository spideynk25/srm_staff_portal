import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/leave/data/leave_availability_service.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';


class LeaveAvailabilityPage extends ConsumerStatefulWidget {
  const LeaveAvailabilityPage({super.key});

  @override
  ConsumerState<LeaveAvailabilityPage> createState() =>
      _LeaveAvailabilityPageState();
}

class _LeaveAvailabilityPageState extends ConsumerState<LeaveAvailabilityPage> {
  List<dynamic>? leaveStatusData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLeaveAvailabilityData();
    });
  }

  Future<void> _fetchLeaveAvailabilityData() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final leaveAvailabilityService = LeaveAvailabilityService();

    try {
      final data = await leaveAvailabilityService.getLeaveAvailability(
        leavePeriodId: ref.read(leavePeriodIdProvider.notifier).state,
        eid: eid,
        encryptionProvider: encryption,
      );
      setState(() {
        leaveStatusData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching leave status data: $e");
    }
  }

  Widget _buildLeaveCard(Map<String, dynamic> leaveData) {
    final leaveType = leaveData['leavetype'] ?? 'Unknown';
    final leaveAvailability =
        double.tryParse(leaveData['leaveavailability'] ?? '0') ?? 0;

    Color availabilityColor;
    if (leaveAvailability > 0) {
      availabilityColor = Colors.green;
    } else if (leaveAvailability == 0) {
      availabilityColor = Colors.orange;
    } else {
      availabilityColor = Colors.red;
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Leave type at the top
            Text(
              leaveType,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            // Availability at the center
            Expanded(
              child: Center(
                child: Text(
                  '$leaveAvailability',
                  style: TextStyle(
                    fontSize: 40, 
                    fontWeight: FontWeight.bold,
                    color: availabilityColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title:  "Leave Availability"),
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
            strokeWidth: 3,
          ),
        ),
      );
    }

    if (leaveStatusData == null || leaveStatusData!.isEmpty) {
      return const Scaffold(
        appBar: CustomAppBar(title:  "Leave Availability"),
        body:  Center(
          child: Text(
            "No leave data available.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title:  "Leave Availability"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            // crossAxisSpacing: 3,
            // mainAxisSpacing: 3,
           // childAspectRatio: 0.8,
          ),
          itemCount: leaveStatusData!.length,
          itemBuilder: (context, index) {
            final leaveData = leaveStatusData![index];
            return _buildLeaveCard(leaveData);
          },
        ),
      ),
    );
  }
}
