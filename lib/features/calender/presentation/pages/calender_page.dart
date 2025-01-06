import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/calender/data/calender_service.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:srm_staff_portal/widgets/custom_snackbar.dart';


class CalenderPage extends ConsumerStatefulWidget {
  const CalenderPage({super.key});

  @override
  ConsumerState<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends ConsumerState<CalenderPage> {
  List<dynamic>? calenderData;
  bool isLoading = false;
  DateTime? initialFromDate = DateTime.now();
  DateTime? initialToDate = DateTime.now();
  DateTime? fromDate;
  DateTime? toDate;

  final calenderService = CalenderService();

  Future<int?> _fetchOfficeId() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;

    try {
      final officeId = await calenderService.getOfficeId(
        eid: eid,
        encryptionProvider: encryption,
      );
      log("$officeId");
      return officeId;
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching profile data: $e");
    }
    return null;
  }

  Future<void> _fetchCalenderEntryData() async {
    if (fromDate == null || toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
         CustomSnackbar.show(title: "Select the date to see the calender"));
      return;
    }
    final difference = toDate!.difference(fromDate!).inDays;
    print("diff $difference");
    if (difference < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackbar.show(title: "Date is in invalid range"));
      return;
    }
    setState(() {
      isLoading = true;
    });

    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    try {
      int? officeId = await _fetchOfficeId();
      final data = await calenderService.getCalenderDetails(
        officeId: officeId!,
        fromDate: "${fromDate!.year}-${fromDate!.month}-${fromDate!.day}",
        toDate: "${toDate!.year}-${toDate!.month}-${toDate!.day}",
        eid: eid,
        encryptionProvider: encryption,
      );
      log("$data");
      setState(() {
        calenderData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching profile data: $e");
    }
  }

  Future<void> _selectDate(BuildContext context, String dateType) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: dateType == "fromDate" ? initialFromDate! : initialToDate!,
    );
    if (pickedDate != null) {
      setState(() {
        if (dateType == "fromDate") {
          fromDate = pickedDate;
          initialFromDate = pickedDate;
        } else {
          toDate = pickedDate;
          initialToDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Calendar'),
      backgroundColor: const Color(0xFFF7F7F7),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text("From Date"),
                      Card(
                        color: Colors.white70,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            side: BorderSide(color: Colors.black)),
                        child: Container(
                            padding: const EdgeInsets.only(left: 3),
                            child: _buildDateSelector(
                                context, fromDate, "fromDate")),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text("To Date"),
                      Card(
                        color: Colors.white70,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            side: BorderSide(color: Colors.black)),
                        child: Container(
                            padding: const EdgeInsets.only(left: 3),
                            child:
                                _buildDateSelector(context, toDate, "toDate")),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  width: 45, // Set the width
                  height: 57, 
                  child: ElevatedButton(
                    onPressed: _fetchCalenderEntryData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 8, 49, 110),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "Go",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // Adjust font size for smaller button
                      ),
                    ),
                  ),
                ),
              
                if (calenderData != null)
                  Container(
                    padding: const EdgeInsets.only(top: 12, left: 4),
                  width: 45, // Set the width
                  height: 57, 
                    child: IconButton(
                      onPressed: _fetchCalenderEntryData,
                      style: IconButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 8, 49, 110),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (calenderData == null)
              const Center(
                child: Text(
                  "Select date range to fetch calendar data.",
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            else
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      horizontalMargin: 10,
                      border: TableBorder.all(width: 1, color: Colors.grey),
                      headingRowColor: WidgetStateProperty.all(
                          const Color.fromARGB(255, 8, 49, 110)),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Date',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Day',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Status',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Day\nOrder',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Week',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Sem',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                      rows: calenderData!.map((entry) {
                        return DataRow(cells: [
                          DataCell(Text(entry['date'] ?? '')),
                          DataCell(Text(entry['day'] ?? '')),
                          DataCell(Text(entry['daystatus'] ?? '')),
                          DataCell(Text(entry['week'].toString())),
                          DataCell(Text(
                            entry['dayorder'] ?? '',
                            textAlign: TextAlign.center,
                          )),
                          DataCell(Text(entry['semester'] ?? '')),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    DateTime? selectedDate,
    String dateType,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            selectedDate == null
                ? "Select Date"
                : DateFormat('dd/MM/yyyy').format(selectedDate),
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
        Expanded(
          flex: 0,
          child: IconButton(
            onPressed: () => _selectDate(context, dateType),
            icon: const Icon(Icons.calendar_month, color: Color.fromARGB(255, 8, 49, 110)),
          ),
        ),
      ],
    );
  }
}
