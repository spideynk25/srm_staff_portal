import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/academic/presentation/pages/delegation_approval_page.dart';
import 'package:srm_staff_portal/features/auth/data/login_hive_service.dart';
import 'package:srm_staff_portal/features/auth/domain/entities/home_quick_access_data.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/home_quick_access_provider.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/home/data/home_quick_access_service.dart';
import 'package:srm_staff_portal/features/leave/presentation/pages/leave_approval_page.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/staff_birthday.dart';
import 'package:srm_staff_portal/features/notification/presentation/pages/notification_view_page.dart';
import 'package:srm_staff_portal/main.dart';

class HomeQuickAccessPage extends ConsumerStatefulWidget {
  const HomeQuickAccessPage({super.key});

  @override
  ConsumerState<HomeQuickAccessPage> createState() =>
      _HomeQuickAccessPageState();
}

class _HomeQuickAccessPageState extends ConsumerState<HomeQuickAccessPage> {
  bool isLoading = true;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _fetchHomeQuickAccessData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  final loginHiveService = LoginHiveService();
  Future<void> _fetchHomeQuickAccessData() async {
    final eid = loginHiveService.getLoginData()?.eid;
    if (eid == null) {
      log("Error: User is not logged in.");
      setState(() {
        isLoading = false;
      });
      return;
    }
    final encryption = ref.read(encryptionProvider.notifier);
    final homeQuickAccessService = HomeQuickAccessService();
    try {
      final data = await homeQuickAccessService.dashBoardData(
        eid: eid,
        encryptionProvider: encryption,
      );

      log(data.toString());
      final homeQuickAccessData = HomeQuickAccessData.fromJsonList(data!);
      ref
          .read(homeQuickAccessProvider.notifier)
          .setHomeQuickAccessData(homeQuickAccessData);
      setState(() {
        false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("Error fetching home quick access data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeQuickAccessData = ref.watch(homeQuickAccessProvider);
    final loginData = ref.watch(loginDataProvider);
    log('Notifications: ${homeQuickAccessData?.notifications}');

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 243, 239, 239),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(),
          child: homeQuickAccessData == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello, ${loginData?.employeeName ?? 'User'}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                const Text(
                                  "Welcome!",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: SafeArea(
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage:
                                    homeQuickAccessData.staffPhoto.isNotEmpty
                                        ? MemoryImage(_decodeBase64(
                                            homeQuickAccessData.staffPhoto))
                                        : null,
                                child: homeQuickAccessData.staffPhoto.isEmpty
                                    ? const Icon(Icons.person,
                                        size: 50, color: Colors.white)
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(height: 20),
                      _buildNotificationCard(
                          context, homeQuickAccessData.notifications),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Centers the cards
                        children: [
                          if (loginHiveService
                              .getLoginData()!
                              .menuIds
                              .contains("Leave Approval"))
                            Expanded(
                              child: _buildQuickAccessCard(
                                  icon: Icons.event_busy,
                                  title: "Pending Leaves",
                                  count: homeQuickAccessData.pendingLeaveCount,
                                  color: Colors.orange,
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LeaveApprovalPage()))),
                            ),
                          const SizedBox(width: 15),
                          _buildQuickAccessCard(
                              icon: Icons.assignment_late,
                              title: "Pending Delegations",
                              count: homeQuickAccessData.pendingDelegationCount,
                              color: Colors.redAccent,
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DelegationApprovalPage()))),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: _buildBigBirthdayCard(
                          context,
                          icon: Icons.cake,
                          title: "Today's Birthday 🎉",
                          name: homeQuickAccessData.birthDayEmployeeName,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Uint8List _decodeBase64(String base64String) {
    return base64Decode(base64String);
  }

  Widget _buildQuickAccessCard({
    required IconData icon,
    required String title,
    required String count,
    required Color color,
    required GestureTapCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 160,
        height: 170,
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: const Color.fromARGB(66, 22, 22, 22),
                    offset: Offset(0, 4),
                    blurRadius: 15)
              ],
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  count,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBigBirthdayCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String name,
    required Color color,
  }) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => StaffBirthday())),
      child: SizedBox(
        width: 300,
        height: 250,
        child: Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: const Color.fromARGB(66, 22, 22, 22),
                      offset: Offset(0, 4),
                      blurRadius: 15)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  name.isNotEmpty ? name : "No Birthdays Today",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
      BuildContext context, List<dynamic> allNotifications) {
    return SizedBox(
      width: double.infinity,
      height: 400,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.notifications_active,
                    color: Color.fromARGB(255, 8, 49, 110),
                    size: 30,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Notifications",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Latest Notifications",
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: allNotifications.length,
                itemBuilder: (context, index) {
                  final notification = allNotifications[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.grey.shade100,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Icon(
                            Icons.paste,
                            color: Color.fromARGB(255, 8, 49, 110),
                          ),
                        ),
                        title: Text(
                          notification.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.message,
                              maxLines: 2, // Limit subtitle to 2 lines
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              notification.date,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationViewPage())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text(
                  "View All Notifications",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
