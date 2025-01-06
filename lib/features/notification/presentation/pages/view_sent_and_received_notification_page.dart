import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/notification/data/view_sent_and_received_notification_state.dart';
import 'package:srm_staff_portal/features/notification/presentation/pages/view_sent_and_received_notification_detailed_page.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';

class ViewSentAndReceivedNotificationPage extends ConsumerStatefulWidget {
  final int flag;
  const ViewSentAndReceivedNotificationPage({super.key, required this.flag});

  @override
  ConsumerState<ViewSentAndReceivedNotificationPage> createState() =>
      _ViewSentAndReceivedNotificationPageState();
}

class _ViewSentAndReceivedNotificationPageState
    extends ConsumerState<ViewSentAndReceivedNotificationPage> {
  List<dynamic>? viewNotificationData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getViewSentNotificationList();
    });
    _getViewSentNotificationList();
  }

  Future<void> _getViewSentNotificationList() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final viewSentAndReceivedNotificationPage =
        ViewSentAndReceivedNotificationState();

    try {
      final data =
          await viewSentAndReceivedNotificationPage.getViewSentNotificationList(
        flag: widget.flag,
        eid: eid,
        encryptionProvider: encryption,
      );
      print(data);
      setState(() {
        viewNotificationData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching profile data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: CustomAppBar(
            title:
                '${widget.flag == 1 ? "Sent" : "Received"} Notification List'),
        backgroundColor: const Color.fromARGB(255, 243, 239, 239),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (viewNotificationData == null || viewNotificationData!.isEmpty) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 239, 239),
        appBar: CustomAppBar(
            title:
                '${widget.flag == 1 ? "Sent" : "Received"} Notification List'),
        body: const Center(
          child: Text(
            "No notifications available",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 239, 239),
      appBar: CustomAppBar(
          title: '${widget.flag == 1 ? "Sent" : "Received"} Notification List'),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: viewNotificationData?.length,
        itemBuilder: (context, index) {
          final notification = viewNotificationData?[index];
          return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(color: Colors.black)),
              elevation: 4.0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.message, size: 19, color: Color.fromARGB(255, 8, 49, 110),),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      "${notification["notificationtitle"]}",
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow
                                          .ellipsis, 
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Second child: Notification date and time
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 10),
                              child: Column(
                                children: [
                                  Text(
                                    "${notification["notificationdate"]}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  Text(
                                    "${notification["notificationtime"]}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${notification["message"]}"),
                    ),
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.black),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewSentAndReceivedNotificationDetailedPage(
                                  detailedData: notification),
                        ))),
              ));
        },
      ),
    );
  }
}
