import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/notification/data/send_notification_to_staff_service.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:srm_staff_portal/widgets/custom_snackbar.dart';

class SendNotificationEmployeeListPage extends ConsumerStatefulWidget {
  final List<dynamic> employeeListData;
  final String title;
  const SendNotificationEmployeeListPage(
      {super.key, required this.employeeListData, required this.title});

  @override
  ConsumerState<SendNotificationEmployeeListPage> createState() =>
      _SendNotificationEmployeeListState();
}

class _SendNotificationEmployeeListState
    extends ConsumerState<SendNotificationEmployeeListPage> {
  List<dynamic>? filteredEmployeeList;
  List<bool> selectedEmployees = [];
  bool isSelectAll = false;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final sendNotificationToStaffService = SendNotificationToStaffService();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterEmployees);
    filteredEmployeeList = List.from(widget.employeeListData);
    selectedEmployees =
        List<bool>.filled(widget.employeeListData.length, false);
  }

  void _filterEmployees() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredEmployeeList = List.from(widget.employeeListData);
      });
    } else {
      setState(() {
        filteredEmployeeList = widget.employeeListData
            .where((employee) =>
                (employee['employeename'] ?? '')
                    .toLowerCase()
                    .contains(query) ||
                (employee['employeeid'] ?? '').toString().contains(query))
            .toList();
      });
    }
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      isSelectAll = value ?? false;
      selectedEmployees =
          List<bool>.filled(filteredEmployeeList?.length ?? 0, isSelectAll);
    });
  }

  void _sendNotification() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;

    // Collect selected employees
    final selectedEmployeeData = filteredEmployeeList!
        .asMap()
        .entries
        .where((entry) => selectedEmployees[entry.key])
        .map((entry) => {"uniqueid": entry.value['employeeid']})
        .toList();

    final returnData = jsonEncode(selectedEmployeeData);
    final message = _messageController.text;

    try {
      final data =
          await sendNotificationToStaffService.sendNotificationToEmployees(
        returnData: returnData,
        notificationMessage: message,
        eid: eid,
        encryptionProvider: encryption,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackbar.show(title: data?["Message"] ?? "Notification sent successfully!")
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
       CustomSnackbar.show(title: "Error: $e")
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Send Notification to Employees"),
      backgroundColor: Colors.white,
      body: widget.employeeListData.isEmpty
          ? const Center(child: Text("No employees available."))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Enter your message here...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: _sendNotification,
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 8, 49, 110),
                                ),
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 8, 49, 110),
                      ),
                      hintText: "Search by name or employee ID...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        horizontalMargin: 10,
                        columnSpacing: 23,
                        headingRowColor: WidgetStateColor.resolveWith(
                            (states) => const Color.fromARGB(255, 8, 49, 110)),
                        columns: [
                          DataColumn(
                            label: Row(
                              children: [
                                Checkbox(
                                  value: isSelectAll,
                                  onChanged: _toggleSelectAll,
                                  fillColor: WidgetStateColor.resolveWith(
                                      (states) => Colors.white),
                                  checkColor: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          const DataColumn(
                            label: Text('Name',
                                style: TextStyle(color: Colors.white)),
                          ),
                          const DataColumn(
                              label: Text('Employee ID',
                                  style: TextStyle(color: Colors.white))),
                        ],
                        rows:
                            filteredEmployeeList!.asMap().entries.map((entry) {
                          final index = entry.key;
                          final employee = entry.value;
                          return DataRow(
                            cells: [
                              DataCell(Checkbox(
                                value: selectedEmployees[index],
                                onChanged: (value) {
                                  setState(() {
                                    selectedEmployees[index] = value ?? false;
                                    isSelectAll =
                                        !selectedEmployees.contains(false);
                                  });
                                },
                              )),
                              DataCell(Text(
                                employee['employeename'] ?? 'Unknown',
                              )),
                              DataCell(
                                  Text(employee['employeeid'] ?? 'Unknown')),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
