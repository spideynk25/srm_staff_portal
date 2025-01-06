import 'package:flutter/material.dart';
import 'package:srm_staff_portal/features/notification/presentation/pages/view_sent_and_received_notification_page.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';

class NotificationViewPage extends StatelessWidget {
  NotificationViewPage({super.key});

  final viewNotificationTitles = [
    "VIEW SENT NOTIFICATION",
    "VIEW RECEIVED NOTIFICATION"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 239, 239),
        appBar: const CustomAppBar(title: 'Notification to Students'),
        body: ListView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: viewNotificationTitles.length,
          itemBuilder: (context, index) {
            final item = viewNotificationTitles[index];
            return Card(
                margin: const EdgeInsets.only(top: 15),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black)),
                child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black)),
                    tileColor: Colors.white,
                    title: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.black),
                    onTap: () {
                      if (index == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ViewSentAndReceivedNotificationPage(
                                      flag: 1),
                            ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ViewSentAndReceivedNotificationPage(
                                      flag: 2),
                            ));
                      }
                    }));
          },
        ));
  }
}
