import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/mis_reports/data/management_services.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';

class StaffBirthday extends ConsumerStatefulWidget {
  const StaffBirthday({super.key});

  @override
  ConsumerState<StaffBirthday> createState() => _StaffBirthdayState();
}

class _StaffBirthdayState extends ConsumerState<StaffBirthday> {
  List<dynamic>? birthdayList; // Change to List to hold multiple birthdays
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBirthdayList();
    });
  }

  Future<void> fetchBirthdayList() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final officeID = ref.watch(loginDataProvider)!.officeId;
    final managementService = ManagementServices();

    try {
      final data = await managementService.getBirthdayList(
        officeId: int.parse(officeID),
        eid: eid,
        encryptionProvider: encryption,
      );

      setState(() {
        birthdayList = data!['Data'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching birthday list: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Staff Birthday'),
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Staff Birthday'),
      body: birthdayList != null && birthdayList!.isNotEmpty
          ? ListView.builder(
              itemCount: birthdayList!.length,
              itemBuilder: (context, index) {
                final birthday = birthdayList![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(4),
                    color: Colors.grey.shade100,
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.blue.shade800, width: 4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 20),
                            Icon(
                              Icons.cake_sharp,
                              size: 50,
                              color: Colors.blue.shade800,
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              // Wrap Column inside Expanded to prevent overflow
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    birthday['employeename'] ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.blue.shade800,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Prevents text overflow
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    birthday['designation'] ?? 'No designation',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Prevents text overflow
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text(
                'No birthdays today.',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
