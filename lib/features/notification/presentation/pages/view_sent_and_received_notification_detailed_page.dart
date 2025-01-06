import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';

class ViewSentAndReceivedNotificationDetailedPage extends StatelessWidget {
  final Map<String, dynamic> detailedData;
 

  const ViewSentAndReceivedNotificationDetailedPage({
    super.key,
    required this.detailedData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Notification Details'),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black)
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Center(
                  child: Text(
                    detailedData["receivedfrom"] ?? 'Unknown Sender',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    detailedData["notificationtitle"] ?? 'No Title',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                const Divider(height: 30, thickness: 1.2),
                // Date and Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailRow(
                      'Date',
                      detailedData['notificationdate'] ?? 'Unknown',
                      Icons.calendar_today,
                    ),
                    _buildDetailRow(
                      'Time',
                      detailedData['notificationtime'] ?? 'Unknown',
                      FontAwesomeIcons.clock,
                    ),
                  ],
                ),
                const Divider(height: 30, thickness: 1.2),
                // Message Header
                const Text(
                  'Message:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Message Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      detailedData['message'] ?? 'No Content Available',
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color.fromARGB(255, 8, 49, 110),),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}
