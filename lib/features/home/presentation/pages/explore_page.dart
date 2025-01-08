import 'package:flutter/material.dart';
import 'package:srm_staff_portal/features/academic/presentation/pages/academic_page.dart';
import 'package:srm_staff_portal/features/auth/data/login_hive_service.dart';
import 'package:srm_staff_portal/features/auth/presentation/pages/login_page.dart';
import 'package:srm_staff_portal/features/book_search/presentation/pages/book_search_page.dart';
import 'package:srm_staff_portal/features/calender/presentation/pages/calender_page.dart';
import 'package:srm_staff_portal/features/leave/presentation/pages/leave_page.dart';
import 'package:srm_staff_portal/features/mis_reports/presentation/pages/mis_reports_page.dart';
import 'package:srm_staff_portal/features/notification/presentation/pages/notification_page.dart';
import 'package:srm_staff_portal/features/profile/presentation/pages/profile_page.dart';
import 'package:srm_staff_portal/features/workforce/presentation/pages/workforce_page.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:srm_staff_portal/widgets/custom_drawer.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  
  @override
  Widget build(BuildContext context) {
    
    final Map<String, dynamic> homeUIData = {
      "1": ["Profile", "assets/icons/icon_profile.jpg", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage(isDrawer: false,)))],
      "2": ["Leave", "assets/icons/icon_leavemanagement.png", () => Navigator.push(context, MaterialPageRoute(builder: (context) => LeavePage()))],
      "3": ["Workforce", "assets/icons/icon_workforce.png", () => Navigator.push(context, MaterialPageRoute(builder: (context) => WorkforcePage()))],
      "4": ["Academic", "assets/icons/icon_academic.png", () => Navigator.push(context, MaterialPageRoute(builder: (context) => AcademicPage()))],
      "5": ["Notification", "assets/icons/icon_communications.png", () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()))],
      "6": ["MIS Reports", "assets/icons/icon_dashboard.png", () => Navigator.push(context, MaterialPageRoute(builder: (context) => MISReportsPage()))],
      "7": ["Calendar", "assets/icons/icon_calendar.png", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CalenderPage()))],
      "8": ["Book Search", "assets/icons/icon_book_search.png", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BookSearchPage()))],
      "9": ["Logout", "assets/icons/icon_logout.jpg", (){
          final loginHiveService = LoginHiveService();
          loginHiveService.clearLoginData(); 
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
        }],
    };

    return Scaffold(
      appBar: CustomAppBar(title: "Explore"),
      drawer: const CustomDrawer(),
      body: Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: homeUIData.length,
        itemBuilder: (context, index) {
          final data = homeUIData[(index + 1).toString()];
          final name = data[0];
          final imagePath = data[1];
          return InkWell(
            onTap: data[2],
            child: Card(
              margin: const EdgeInsets.all(0),
              elevation: 8,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shadowColor: Colors.grey.withOpacity(0.4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
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
