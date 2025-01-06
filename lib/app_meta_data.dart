import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:srm_staff_portal/features/academic/presentation/pages/create_assignment_page.dart';
import 'package:srm_staff_portal/features/academic/presentation/pages/delegation_approval_page.dart';
import 'package:srm_staff_portal/features/academic/presentation/pages/internal_marks_page.dart';
import 'package:srm_staff_portal/features/academic/presentation/pages/my_timetable_page.dart';
import 'package:srm_staff_portal/features/academic/presentation/pages/student_attendance_page.dart';
import 'package:srm_staff_portal/features/book_search/presentation/pages/book_search_page.dart';
import 'package:srm_staff_portal/features/calender/presentation/pages/calender_page.dart';
import 'package:srm_staff_portal/features/leave/presentation/pages/leave_approval_page.dart';
import 'package:srm_staff_portal/features/leave/presentation/pages/leave_entry_page.dart';
import 'package:srm_staff_portal/features/leave/presentation/pages/leave_status_page.dart';
import 'package:srm_staff_portal/features/leave/presentation/pages/permission_entry_page.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/mis_faculty.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/mis_management.dart';
import 'package:srm_staff_portal/features/notification/presentation/pages/notification_view_page.dart';
import 'package:srm_staff_portal/features/notification/presentation/pages/send_notification_to_all_page.dart';
import 'package:srm_staff_portal/features/notification/presentation/pages/send_notification_to_staff_page.dart';
import 'package:srm_staff_portal/features/notification/presentation/pages/send_notification_to_students_page.dart';
import 'package:srm_staff_portal/features/profile/presentation/pages/profile_page.dart';
import 'package:srm_staff_portal/features/workforce/presentation/pages/payslip_page.dart';

class AppMetaData {
  static final Map<String, dynamic> userMetadataForDrawer = {
    "Personal Details": {
      "icon": "assets/icons/icon_profile.jpg",
      "label": "Profile",
      "action": (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ProfilePage(
                    isDrawer: false,
                  ))),
    },
  };

  static final Map<String, dynamic> misReportMetadata = {
    "MIS for Faculty": {
      "icon": "assets/icons/icon_facultydashboard.png",
      "label": "MIS for Faculty",
      "action": (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MISFacultyPage(),
          )),
    },
    "MIS for Management": {
      "icon": "assets/icons/icon_managementdashboard.png",
      "label": "MIS for Management",
      "action": (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MISManagementPage(),
          )),
    },
    "Calendar": {
      "icon": "assets/icons/icon_calendar.png",
      "label": "Calendar",
      "action": (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CalenderPage(),
          )),
    },
    "Book Search": {
      "icon": "assets/icons/icon_book_search.png",
      "label": "Book Search",
      "action": (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookSearchPage(),
          )),
    },
  };

  static final Map<String, dynamic> leaveMetadata = {
    "Leave Status": {
      "icon": "assets/icons/icon_leavestatus.jpg",
      "label": "Leave Status",
      "action": (BuildContext context) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LeaveStatusPage(),
            ),
          ),
    },
    "Leave Entry": {
      "icon": "assets/icons/icon_leaveentry.jpg",
      "label": "Leave Entry",
      "action": (BuildContext context) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LeaveEntryPage(),
            ),
          ),
    },
    "Leave Approval": {
      "icon": "assets/icons/icon_leaveapproval.jpg",
      "label": "Leave Approval",
      "action": (BuildContext context) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LeaveApprovalPage(),
            ),
          ),
    },
    "Permission Entry": {
      "icon": "assets/icons/icon_permissionentry.png",
      "label": "Permission Entry",
      "action": (BuildContext context) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PermissionEntryPage(),
            ),
          ),
    },
  };

  // static final Map<String, dynamic> homeMetaData = {
  //   "Personal Details": {
  //     "icon": "assets/icons/icon_profile.jpg",
  //     "label": "Leave Status",
  //     "action": (BuildContext context) => Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => const ProfilePage(
  //                   isDrawer: false,
  //                 )))
  //   },
  //   "Leave Entry": {
  //     "icon": "assets/icons/icon_leaveentry.jpg",
  //     "label": "Leave Entry",
  //     "action": (BuildContext context) => Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const LeaveEntryPage(),
  //           ),
  //         ),
  //   },
  //   "Leave Approval": {
  //     "icon": "assets/icons/icon_leaveapproval.jpg",
  //     "label": "Leave Approval",
  //     "action": (BuildContext context) => Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const LeaveApprovalPage(),
  //           ),
  //         ),
  //   },
  //   "Permission Entry": {
  //     "icon": "assets/icons/icon_permissionentry.png",
  //     "label": "Permission Entry",
  //     "action": (BuildContext context) => Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const PermissionEntryPage(),
  //           ),
  //         ),
  //   },
  // };

  static final Map<String, dynamic> workforceMetadata = {
    "Biometric Log": {
      "icon": "assets/icons/icon_biometriclog.jpg",
      "label": "Biometric Log",
      "action": () => log("1 clicked"),
    },
    "Payslip": {
      "icon": "assets/icons/icon_payslip.jpg",
      "label": "Payslip",
      "action": (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PaySlipPage(),
          )),
    },
  };

  static final Map<String, dynamic> academicMetadata = {
    "My Timetable": {
      "icon": "assets/icons/icon_timetable.jpg",
      "label": "My Timetable",
      "action": (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyTimetablePage(),
          )),
    },
    "Student Attendance": {
      "icon": "assets/icons/icon_studentattendance.jpg",
      "label": "Student Attendance",
      "action": (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StudentAttendancePage(),
          )),
    },
    "Internal Mark Entry": {
      "icon": "assets/icons/icon_studentattendance.jpg",
      "label": "Internal Mark Entry",
      "action": (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const InternalMarksPage(),
          )),
    },
    "Create Assignment": {
      "icon": "assets/icons/icon_studentattendance.jpg",
      "label": "Create Assignment",
      "action": (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateAssignmentPage(),
          )),
    },
    "Delegation Approval": {
      "icon": "assets/icons/icon_studentattendance.jpg",
      "label": "Delegation Approval",
      "action": (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DelegationApprovalPage(),
          )),
    },
  };

  static final Map<String, dynamic> notificationMetadata = {
    "Send Notification to Students": {
      "icon": "assets/icons/icon_notification.PNG",
      "label": "Send Notification to Students",
      "action": (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SendNotificationToStudents(),
          )),
    },
    "Send Notification to Staff": {
      "icon": "assets/icons/icon_notificationtoemployee.png",
      "label": "Send Notification to Staff",
      "action": (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SendNotificationToStaffPage(),
          )),
    },
    "Notification to All": {
      "icon": "assets/icons/icon_notificationtoall.png",
      "label": "Notification to All",
      "action": (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SendNotificationToAllPage(),
          )),
    },
    "Notification View": {
      "icon": "assets/icons/icon_notificationview.png",
      "label": "Notification View",
      "action": (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationViewPage(),
          )),
    },
    "Broadcast": {
      "icon": "assets/icons/icondb_broadcast.png",
      "label": "Broadcast",
      "action": () => log("4 clicked"),
    },
  };
}
