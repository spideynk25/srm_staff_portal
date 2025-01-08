import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/app_meta_data.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/absentee_count.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/current_admission.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/due_list.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/library_transaction.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/lms_report_page.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/staff_attendance.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/staff_birthday.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/todays_absentee.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:srm_staff_portal/widgets/custom_drawer.dart';
import 'package:srm_staff_portal/features/academic/presentation/pages/academic_page.dart';
import 'package:srm_staff_portal/features/auth/presentation/pages/login_page.dart';
import 'package:srm_staff_portal/features/book_search/presentation/pages/book_search_page.dart';
import 'package:srm_staff_portal/features/calender/presentation/pages/calender_page.dart';
import 'package:srm_staff_portal/features/leave/presentation/pages/leave_page.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/mis_reports_page.dart';
import 'package:srm_staff_portal/features/notification/presentation/pages/notification_page.dart';
import 'package:srm_staff_portal/features/profile/presentation/pages/profile_page.dart';
import 'package:srm_staff_portal/features/workforce/presentation/pages/workforce_page.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String query = "";

  @override
  Widget build(BuildContext context) {
    final menuIds = ref.watch(loginDataProvider)?.menuIds ?? [];

    final allMetadata = {
      ...AppMetaData.userMetadataForDrawer,
      ...AppMetaData.misReportMetadata,
      ...AppMetaData.leaveMetadata,
      ...AppMetaData.workforceMetadata,
      ...AppMetaData.academicMetadata,
      ...AppMetaData.notificationMetadata,
    };

    final Map<String, dynamic> homeUIData = {
      "Profile": {
        "icon": "assets/icons/icon_profile.jpg",
        "action": (BuildContext context) => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProfilePage(isDrawer: false)))
      },
      "Leave": {
        "icon": "assets/icons/icon_leavemanagement.png",
        "action": (BuildContext context) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => LeavePage()))
      },
      "Workforce": {
        "icon": "assets/icons/icon_workforce.png",
        "action": (BuildContext context) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => WorkforcePage()))
      },
      "Academic": {
        "icon": "assets/icons/icon_academic.png",
        "action": (BuildContext context) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AcademicPage()))
      },
      "Notification": {
        "icon": "assets/icons/icon_communications.png",
        "action": (BuildContext context) => Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotificationPage()))
      },
      "MIS Reports": {
        "icon": "assets/icons/icon_dashboard.png",
        "action": (BuildContext context) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => MISReportsPage()))
      },
      "Calendar": {
        "icon": "assets/icons/icon_calendar.png",
        "action": (BuildContext context) => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CalenderPage()))
      },
      "Book Search": {
        "icon": "assets/icons/icon_book_search.png",
        "action": (BuildContext context) => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const BookSearchPage()))
      },
    };

    final Map<String, dynamic> facultyMetaData = {
      "Staff Leave": {
        "label": "Staff Leave",
        "icon": "assets/icons/icon_leavestatus.jpg",
        "action": (BuildContext context) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StaffAttendance(from: 0),
              ),
            ),
      },
      "Library Transaction": {
        "label": "Library Transaction",
        "icon": "assets/icons/icon_transactions.png",
        "action": (BuildContext context) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LibraryTransaction(),
              ),
            ),
      },
      "Absentee Count": {
        "label": "Absentee Count",
        "icon": "assets/icons/icondb_absenteecount.png",
        "action": (BuildContext context) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AbsenteeCount(),
              ),
            ),
      },
      "Todays Absentee": {
        "label": "Todays Absentee",
        "icon": "assets/icons/icondb_todayabsentee.png",
        "action": (BuildContext context) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TodayAbsentee(),
              ),
            ),
      },
      "Staff Birthday": {
        "label": "Staff Birthday",
        "icon": "assets/icons/icondb_staffbirthday.png",
        "action": (BuildContext context) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StaffBirthday(),
              ),
            ),
      },
      "LMS": {
        "label": "LMS",
        "icon": "assets/icons/icon_permissionentry.png",
        "action": (BuildContext context) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LmsReportPage(),
              ),
            ),
      },
    };

    final Map<String, dynamic> managementMetaData = {
      "Current Admission": {
        "label": "Current Admission",
        "icon": "assets/icons/icondb_admissioncurrentyear.png",
        "action": (BuildContext context) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CurrentAdmission(),
              ),
            ),
      },
      "Due List": {
        "label": "Due List",
        "icon": "assets/icons/icondb_duelist.png",
        "action": (BuildContext context) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DueList(),
              ),
            ),
      },
      "Staff Birthday": {
        "label": "Staff Birthday",
        "icon": "assets/icons/icondb_birthdaylist.png",
        "action": (BuildContext context) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StaffBirthday(),
              ),
            ),
      },
      "Staff Attendance": {
        "label": "Staff Attendance",
        "icon": "assets/icons/icondb_staffleave.png",
        "action": (BuildContext context) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StaffAttendance(from: 1),
              ),
            ),
      },
    };

    Map<String, dynamic> mergedData = {
      ...homeUIData,
      ...Map.fromEntries(
          allMetadata.entries.where((entry) => menuIds.contains(entry.key))),
    };

    if (menuIds.contains("MIS for Faculty")) {
      mergedData = {
        ...mergedData,
        ...facultyMetaData,
      };
    }

    if (menuIds.contains("MIS for Management")) {
      mergedData = {
        ...mergedData,
        ...managementMetaData,
      };
    }

    final List<MapEntry<String, dynamic>> searchResults = query.isEmpty
        ? []
        : mergedData.entries
            .where((entry) =>
                entry.key.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: CustomAppBar(title: "Search"),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search",
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
          ),
          Expanded(
            child: searchResults.isEmpty
                ? Center(
                    child: Text(
                      query.isEmpty
                          ? "Start typing to search..."
                          : "No results found",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final entry = searchResults[index];
                      return ListTile(
                        leading: Image.asset(entry.value["icon"],
                            width: 40, height: 40),
                        title: Text(entry.key),
                        onTap: () => entry.value["action"](context),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
