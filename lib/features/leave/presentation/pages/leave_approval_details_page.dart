import 'package:flutter/material.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';


class LeaveApprovalDetailsPage extends StatelessWidget {
  final Map<String, dynamic> leaveData;
  final void Function(int, int) approveLeave;

  const LeaveApprovalDetailsPage(
      {super.key, required this.leaveData, required this.approveLeave});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Leave Approval Details'),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              color: Colors.white,
              elevation: 6.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leaveData['employeename'],
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Designation:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(leaveData['designation']),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Department:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(leaveData['department']),
                      ],
                    ),
                    Divider(color: Colors.grey[300]),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: Colors.blueAccent),
                        const SizedBox(width: 8.0),
                        Text('From: ${leaveData['fromdate']}'),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: Colors.redAccent),
                        const SizedBox(width: 8.0),
                        Text('To: ${leaveData['todate']}'),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(Icons.timelapse, color: Colors.orangeAccent),
                        const SizedBox(width: 8.0),
                        Text('No. of Days: ${leaveData['noofdays']}'),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Reason:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      leaveData['reason'],
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Session:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      leaveData['session'].replaceAll('&lt;br&gt;', '\n'),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async{
                             approveLeave(
                                int.parse(leaveData["leaveapplicationid"]), 1);
                                Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Approve',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            approveLeave(
                                int.parse(leaveData["leaveapplicationid"]), 9);
                                Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
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
                    )
                  ],
                ),
              ),
            )));
  }
}
