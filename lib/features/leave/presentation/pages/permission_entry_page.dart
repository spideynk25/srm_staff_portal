import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/leave/data/permission_entry_service.dart';
import 'package:srm_staff_portal/features/leave/presentation/pages/leave_availability_page.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:srm_staff_portal/widgets/custom_snackbar.dart';

class PermissionEntryPage extends ConsumerStatefulWidget {
  const PermissionEntryPage({super.key});

  @override
  ConsumerState<PermissionEntryPage> createState() =>
      PermissionEntryPageState();
}

class PermissionEntryPageState extends ConsumerState<PermissionEntryPage> {
  final _remarkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>?>? leaveApprovalData;
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
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  Map<String, dynamic> result = {
    "leavePeriod": null,
    "leaveType": [],
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

  final Map<String, dynamic> errorMessage = {"error": null, "message": null};
  final permissionEntryService = PermissionEntryService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchPermissionEntryData();
    });
  }

  Future<void> _fetchPermissionEntryData() async {
    setState(() {
      isLoading = true;
    });

    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;

    try {
      final data =
          await permissionEntryService.listLeavePeriodandTypeforPermissionJson(
        eid: eid,
        encryptionProvider: encryption,
      );
      //print(data);
      log("permission page ${data?[0]["Data"][1]}");
      log("permission page ${data?[0]["Data"][1].runtimeType}");
      log("permission page ${data?[0]["Data"][2]}");
      log("permission page ${data?[0]["Data"][2].runtimeType}");
      leaveTypeData = [data?[0]["Data"][1], data?[0]["Data"][2]];
      result["leaveType"] = [data?[0]["Data"][1], data?[0]["Data"][2]];
      log("${data?[0]["Data"].runtimeType.toString()}");
      if (data?[0]["Data"].runtimeType.toString() == "List<dynamic>") {
        leaveApprovalData = [
          data?[0]["Data"][0],
        ];
      } else {
        errorMessage["message"] = data?[0]["Data"]["Message"];
      }

      log("$leaveApprovalData");
      result["leavePeriod"] = data?[0]["Data"][0]["leaveperioddesc"];
      log("leaveapprovaldata $leaveApprovalData");
      log("leaveapprovaldata ${leaveApprovalData?[0]}");
      minCalenderDate = data?[0]["Data"][0]["mincalenderdate"];
      maxCalenderDate = data?[0]["Data"][0]["maxcalenderdate"];
      initialDate = data?[0]["Data"][0]["setcalenderdate"];
    } catch (e) {
      print("Error fetching leave approval data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, String type) async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    log("$pickedTime");
    if (pickedTime != null) {
      setState(() {
        if (type == "fromTime") {
          fromTime = pickedTime;
        } else {
          toTime = pickedTime;
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final initialDate = this.initialDate!.split("-");
    final fromDate = minCalenderDate!.split("-");
    final toDate = maxCalenderDate!.split("-");
    print("$initialDate $fromDate $toDate");
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
      setState(() {
        result["fromDate"] =
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
        this.fromDate = pickedDate;
        result["toDate"] =
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
        this.toDate = pickedDate;
      });
    }
  }

  Future<void> _saveEmployeePermissionDetailsJson() async {
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
    if (fromTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackbar.show(title: "Please Enter the From Time"));
      return;
    }
    if (toTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
         CustomSnackbar.show(title: "Please Enter the To Time"));
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
    log("leaveperiod:${leaveApprovalData![0]!["leaveperiodid"].runtimeType} ${leaveApprovalData![0]!["leaveperiodid"]}");
    log("leavetype ${result["leaveType"][0]["leavetypeid"].runtimeType} ${result["leaveType"][0]["leavetypeid"]}");
    log("fromDate ${result["fromDate"].runtimeType} ${result["fromDate"]}");

    log("numberofdays ${numberOfDays.runtimeType} $numberOfDays");
    log("reason ${_remarkController.text.runtimeType} ${_remarkController.text}");
    log("toDate ${result["toDate"].runtimeType} ${result["toDate"]}");
    log("fromtime $fromTime");
    log("totime $toTime");

    try {
      final data =
          await permissionEntryService.saveEmployeePermissionDetailsJson(
        eid: eid,
        encryptionProvider: encryption,
        leavePeriodId: int.parse(leaveApprovalData![0]!["leaveperiodid"]),
        leaveTypeId: int.parse(result["leaveType"][0]["leavetypeid"]),
        fromDate:
            "${result["fromDate"]} ${fromTime?.hour}:${fromTime?.minute}:11",
        leaveAppliedDays: double.parse(numberOfDays!.toStringAsFixed(2)),
        reason: _remarkController.text,
        toDate: "${result["toDate"]} ${toTime?.hour}:${toTime?.minute}:11",
      );
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
        backgroundColor: Color.fromARGB(255, 243, 239, 239),
        appBar: CustomAppBar(title: "Permission Entry"),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage["message"] != null) {
      return Scaffold(
        appBar: const CustomAppBar(title: "Permission Entry"),
        body: Center(
          child: Text(
            "${errorMessage["message"]}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 239, 239),
      appBar: const CustomAppBar(title: "Permission Entry"),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "To be approved by: ${leaveApprovalData?[0]?["reportingofficer"]}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                      value: item!["leaveperioddesc"],
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
              Row(children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 42,
                  child: Container(
                    height: 56,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        fromDate == null
                            ? const Text("Date", style: TextStyle(fontSize: 15))
                            : Text(
                                "${fromDate?.day}/${fromDate?.month}/${fromDate?.year}",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                        IconButton(
                          icon: const Icon(
                            Icons.calendar_month,
                            color: Color.fromARGB(255, 8, 49, 110),
                          ),
                          onPressed: () => _selectDate(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 56,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(fromTime != null
                            ? fromTime!.format(context)
                            : 'From Time'),
                        IconButton(
                          onPressed: () => _selectTime(context, "fromTime"),
                          icon: const Icon(
                            FontAwesomeIcons.clock,
                            color: Color.fromARGB(255, 8, 49, 110),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 56,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(toTime != null
                            ? toTime!.format(context)
                            : 'To Time'),
                        IconButton(
                          onPressed: () => _selectTime(context, "toTime"),
                          icon: const Icon(
                            FontAwesomeIcons.clock,
                            color: Color.fromARGB(255, 8, 49, 110),
                          ),
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
                    labelText: "Enter Remarks",
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
                    await _saveEmployeePermissionDetailsJson();
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    backgroundColor: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LeaveAvailabilityPage(),
                      ));
                },
                child: const Text(
                  "Leave Availability",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
