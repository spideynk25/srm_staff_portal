import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/leave/data/leave_entry_service.dart';
import 'package:srm_staff_portal/features/leave/presentation/pages/leave_availability_page.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:srm_staff_portal/widgets/custom_snackbar.dart';


class LeaveEntryPage extends ConsumerStatefulWidget {
  const LeaveEntryPage({super.key});

  @override
  ConsumerState<LeaveEntryPage> createState() => _LeaveEntryPageState();
}

class _LeaveEntryPageState extends ConsumerState<LeaveEntryPage> {
  final _remarkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<dynamic>? leaveApprovalData;
  List<dynamic>? leaveTypeData;
  bool isLoading = true;
  String? selectedLeavePeriod;
  String? selectedLeaveType;
  DateTime? selectedDate;
  String? initialDate;
  String? maxCalenderDate;
  String? minCalenderDate;
  int? numberOfDays;
  DateTime? fromDate;
  DateTime? toDate;
  Map<String, dynamic> result = {
    "leavePeriod": null,
    "leaveType": null,
    "leaveAvailability": null,
    "fromDate": null,
    "fromSession": [
      {"session": "Full Day", "value": 2}
    ],
    "toDate": null,
    "toSession": [
      {"session": "Full Day", "value": 2}
    ],
    "initialDate": null,
    "numberOfDays": 0,
    "reason": null
  };

  final sessions = [
    {"session": "Full Day", "value": 2},
    {"session": "Forenoon", "value": 3},
    {"session": "Afternoon", "value": 4},
  ];

  final leaveEntryService = LeaveEntryService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchLeaveApprovalData();
    });
  }

  Future<void> _fetchLeaveApprovalData() async {
    setState(() {
      isLoading = true;
    });

    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;

    try {
      final data = await leaveEntryService.listLeavePeriodJson(
        eid: eid,
        encryptionProvider: encryption,
      );
      log("$data");
      if (data != null && data.isNotEmpty) {
        setState(() {
          leaveApprovalData = data;
          if (!(data[0] as Map<String, dynamic>).containsKey("Message")) {
            result["leavePeriod"] = data[0]["leaveperioddesc"];
            minCalenderDate = data[0]["mincalenderdate"];
            maxCalenderDate = data[0]["maxcalenderdate"];
            initialDate = data[0]["setcalenderdate"];
          }
        });
        await _listLeaveTypeJson(int.parse(data[0]["leaveperiodid"]));
        if (!(data[0] as Map<String, dynamic>).containsKey("Message")) {
          await _listLeaveTypeJson(int.parse(data[0]["leaveperiodid"]));
          ref.read(leavePeriodIdProvider.notifier).state =
              data[0]["leaveperiodid"];
        }
      }
    } catch (e) {
      log("Error fetching leave approval data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _listLeaveTypeJson(int leavePeriodId) async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;

    try {
      final data = await leaveEntryService.listLeaveTypeJson(
        leavePeriodId: leavePeriodId,
        eid: eid,
        encryptionProvider: encryption,
      );
      log("runtime type ${data.runtimeType}");
      setState(() {
        log("$data");
        leaveTypeData = data;
        result["leaveType"] = data != null ? [data[0]] : null;
      });
    } catch (e) {
      log("Error fetching leave types: $e");
    }
  }

  Future<void> _selectDate(BuildContext context, String type) async {
    final initialDate = this.initialDate!.split("-");
    final fromDate = minCalenderDate!.split("-");
    final toDate = maxCalenderDate!.split("-");
    log("$initialDate $fromDate $toDate");
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(int.parse(initialDate[0]),
          int.parse(initialDate[1]), int.parse(initialDate[2])),
      firstDate: DateTime(int.parse(fromDate[0]), int.parse(fromDate[1]),
          int.parse(fromDate[2])),
      lastDate: DateTime(
          int.parse(toDate[0]), int.parse(toDate[1]), int.parse(toDate[2])),
    );

    if (pickedDate != null) {
      if (type == "fromDate") {
        result["fromDate"] =
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
        setState(() {
          this.fromDate = pickedDate;
        });
      } else {
        result["toDate"] =
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
        setState(() {
          this.toDate = pickedDate;
        });
      }
    }
  }

  Future<void> _saveEmployeeLeaveDetailsJson() async {
    log("from date $fromDate");
    log("from date $toDate");
    if (fromDate == null && toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(CustomSnackbar.show(title: "Please Enter the From Date and To Date"));
      return;
    }
    if (fromDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
         CustomSnackbar.show(title: "Please Enter the From Date"));
      return;
    }
    if (toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
           CustomSnackbar.show(title: "Please Enter the To Date"));
      return;
    }
    numberOfDays = toDate!.difference(fromDate!).inDays;

    if (numberOfDays! < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackbar.show(title: "Please Enter Valid Date Range"));
      return;
    }
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    numberOfDays = toDate!.difference(fromDate!).inDays;
    log("leaveperiod:${leaveApprovalData![0]["leaveperiodid"].runtimeType} ${leaveApprovalData![0]["leaveperiodid"]}");
    log("leavetype ${result["leaveType"][0]["leavetypeid"].runtimeType} ${result["leaveType"][0]["leavetypeid"]}");
    log("fromDate ${result["fromDate"].runtimeType} ${result["fromDate"]}");
    log("fromSession ${result["fromSession"][0]["value"].runtimeType} ${result["fromSession"][0]["value"]}");
    log("numberofdays ${numberOfDays.runtimeType} $numberOfDays");
    log("reason ${_remarkController.text.runtimeType} ${_remarkController.text}");
    log("toDate ${result["toDate"].runtimeType} ${result["toDate"]}");
    log("toSession ${result["toSession"][0]["value"].runtimeType} ${result["toSession"][0]["value"]}");
    try {
      final data = await leaveEntryService.saveEmployeeLeaveDetailsJson(
          eid: eid,
          encryptionProvider: encryption,
          leavePeriodId: int.parse(leaveApprovalData![0]["leaveperiodid"]),
          leaveTypeId: int.parse(result["leaveType"][0]["leavetypeid"]),
          fromDate: result["fromDate"],
          fromSession: result["fromSession"][0]["value"],
          leaveAppliedDays: double.parse(numberOfDays!.toStringAsFixed(2)),
          reason: _remarkController.text,
          toDate: result["toDate"],
          toSession: result["toSession"][0]["value"]);
      log("page $data");
      ScaffoldMessenger.of(context)
          .showSnackBar(CustomSnackbar.show(title: data!));
    } catch (e) {
      log("_saveEmployeeLeaveDetailsJson: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: "Leave Entry"),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if ((leaveApprovalData?[0] as Map<String, dynamic>)
        .containsKey("Message")) {
      if (leaveApprovalData?[0]["Message"].toString() != null) {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: const CustomAppBar(title: "Leave Entry"),
            body: Center(
              child: Text(
                leaveApprovalData?[0]["Message"],
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
              ),
            ));
      }
    }

    if ((leaveApprovalData?[0] as Map<String, dynamic>)
        .containsKey("Message")) {
      if (leaveApprovalData?[0]["Message"].toString() != null) {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: const CustomAppBar(title: "Leave Entry"),
            body: Center(
              child: Text(
                leaveApprovalData?[0]["Message"],
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
              ),
            ));
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Leave Entry"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "To be approved by: ${leaveApprovalData![0]["reportingofficer"]}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            if (leaveApprovalData != null)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 8, 49, 110),
                      width: 2.0,
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                icon: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 8, 49, 110),
                  ),
                  width: 20,
                  height: 20,
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                hint: const Text("Select Leave Period"),
                isExpanded: true,
                items: leaveApprovalData!.map((item) {
                  return DropdownMenuItem<String>(
                    value: item["leaveperioddesc"],
                    child: Text(item["leaveperioddesc"]),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    result["leavePeriod"] = newValue;
                  });
                },
              ),
            const SizedBox(height: 25),
            if (leaveTypeData != null)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 8, 49, 110),
                      width: 2.0,
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                icon: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 8, 49, 110),
                  ),
                  width: 20,
                  height: 20,
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                hint: const Text("Select Leave Type"),
                isExpanded: true,
                items: leaveTypeData!.map((item) {
                  return DropdownMenuItem<String>(
                    value: item["leavetype"],
                    child: Text(item["leavetype"]),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    result["leaveType"] = leaveTypeData!
                        .where((data) => data["leavetype"] == newValue)
                        .toList();
                  });
                },
              ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 150,
                  child: Column(
                    children: [
                      Container(
                        height: 56,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            fromDate == null
                                ? const Text("Select Date",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ))
                                : Text(
                                    "${fromDate?.day}/${fromDate?.month}/${fromDate?.year}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                            IconButton(
                              icon: const Icon(Icons.calendar_month),
                              onPressed: () => _selectDate(context, "fromDate"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 8, 49, 110),
                              width: 2.0,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                        ),
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 8, 49, 110),
                          ),
                          width: 20,
                          height: 20,
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        hint: const Text("From Session"),
                        isExpanded: true,
                        items: sessions.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["session"].toString(),
                            child: Text(item["session"].toString()),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            result["fromSession"] = sessions
                                .where((data) => data["session"] == newValue)
                                .toList();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 150,
                  child: Container(
                    height: 56,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        toDate == null
                            ? const Text("To Date",
                                style: TextStyle(
                                  fontSize: 15,
                                ))
                            : Text(
                                "${toDate?.day}/${toDate?.month}/${toDate?.year}",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: () => _selectDate(context, "toDate"),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 8, 49, 110),
                              width: 2.0,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                        ),
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 8, 49, 110),
                          ),
                          width: 20,
                          height: 20,
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        hint: const Text("To Session"),
                        isExpanded: true,
                        items: sessions.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["session"].toString(),
                            child: Text(item["session"].toString()),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            result["toSession"] = sessions
                                .where((data) => data["session"] == newValue)
                                .toList();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Reason",
                ),
                controller: _remarkController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter you remarks";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 11.0, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  backgroundColor: const Color.fromARGB(255, 8, 49, 110)),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await _saveEmployeeLeaveDetailsJson();
                }
              },
              child: const Text(
                "Apply",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  backgroundColor: const Color.fromARGB(255, 243, 239, 239)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LeaveAvailabilityPage(),
                    ));
              },
              icon: const Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
              iconAlignment: IconAlignment.end,
              label: const Text(
                "Leave Availability",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
