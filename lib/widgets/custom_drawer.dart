import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/app_meta_data.dart';
import 'package:srm_staff_portal/features/auth/data/login_hive_service.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/auth/presentation/pages/login_page.dart';
import 'package:srm_staff_portal/features/profile/presentation/pages/profile_page.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuIds = ref.watch(loginDataProvider)?.menuIds ?? [];
    final userDetails = ref.read(loginDataProvider);
    final userData = menuIds
        .where((data) => AppMetaData.userMetadataForDrawer.containsKey(data))
        .toList();
    final leaveManagementData = menuIds
        .where((data) => AppMetaData.leaveMetadata.containsKey(data))
        .toList();
    final workForceData = menuIds
        .where((data) => AppMetaData.workforceMetadata.containsKey(data))
        .toList();
    final academicData = menuIds
        .where((data) => AppMetaData.academicMetadata.containsKey(data))
        .toList();
    final notificationData = menuIds
        .where((data) => AppMetaData.notificationMetadata.containsKey(data))
        .toList();
    final misReportsData = menuIds
        .where(
            (data) => AppMetaData.misReportMetadata.containsKey(data))
        .toList();
    misReportsData.addAll(["Calendar", "Book Search"]);
    log("userdata $userData");
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 8, 49, 110),
                  Color.fromARGB(255, 20, 100, 200),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(isDrawer: false),)),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      image: const DecorationImage(
                        image: AssetImage("assets/icons/icon_profile.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // User Information
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userDetails?.employeeName ?? 'Unknown User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userDetails?.designation ?? 'No Designation',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userDetails?.department ?? 'No Department',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildCategoryHeader("User"),
          ...userData.map((title) {
            final data = AppMetaData.userMetadataForDrawer[title];
            return _buildDrawerItem(context, data["label"], data["icon"],
                () => data["action"](context));
          }),
          const Divider(),
          _buildCategoryHeader("Leave Management"),
          ...leaveManagementData.map((title) {
            final data = AppMetaData.leaveMetadata[title];
            return _buildDrawerItem(context, data["label"], data["icon"],
                () => data["action"](context));
          }),
          const Divider(),
          _buildCategoryHeader("Workforce"),
          ...workForceData.map((title) {
            final data = AppMetaData.workforceMetadata[title];
            return _buildDrawerItem(context, data["label"], data["icon"],
                () => data["action"](context));
          }),
          const Divider(),
          _buildCategoryHeader("Academic"),
          ...academicData.map((title) {
            final data = AppMetaData.academicMetadata[title];
            return _buildDrawerItem(context, data["label"], data["icon"],
                () => data["action"](context));
          }),
          const Divider(),
          _buildCategoryHeader("Notification"),
          ...notificationData.map((title) {
            final data = AppMetaData.notificationMetadata[title];
            return _buildDrawerItem(context, data["label"], data["icon"],
                () => data["action"](context));
          }),
          const Divider(),
          _buildCategoryHeader("MIS Reports"),
          ...misReportsData.map((title) {
            final data = AppMetaData.misReportMetadata[title];
            return _buildDrawerItem(context, data["label"], data["icon"],
                () => data["action"](context));
          }),
          const Divider(),
          _buildDrawerItem(
            context,
            "Logout",
            "assets/icons/icon_logout.jpg",
            () {
              final loginHiveService = LoginHiveService();
              loginHiveService.clearLoginData();              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ));
            }
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    String title,
    String icon,
    Function page,
  ) {
    return ListTile(
      leading: Image.asset(icon, width: 24, height: 24),
      title: Text(
        title,
        style: TextStyle(color: Colors.black87),
      ),
      onTap: () {
        Navigator.pop(context);
        page();
      },
    );
  }
}
