import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/academic/data/delegation_approval_service.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';

class DelegationApprovalPage extends ConsumerStatefulWidget {
  const DelegationApprovalPage({super.key});

  @override
  ConsumerState<DelegationApprovalPage> createState() => _DelegationApprovalPageState();
}

class _DelegationApprovalPageState extends ConsumerState<DelegationApprovalPage> {
  List<dynamic>? delegationApprovalData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDelegationList();
    });
  }

  Future<void> _fetchDelegationList() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final delegationApprovalService = DelegationApprovalService();

    try {
      final data = await delegationApprovalService.getDelegationApprovalDetails(
        eid: eid,
        encryptionProvider: encryption,
      );
      setState(() {
        delegationApprovalData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching profile data: $e");
    }
  }

  Future<void> _approveOrRejectDelegation(int delegationStatus, int delegationId) async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final delegationApprovalService = DelegationApprovalService();

    try {
      final data = await delegationApprovalService.approveOrRejectDelegation(
        delegationId: delegationId,
        delegationStatus: delegationStatus,
        eid: eid,
        encryptionProvider: encryption,
      );
      log("$data");
      _fetchDelegationList();
      
    } catch (e) {
      print("Error fetching profile data: $e");
    }
  } 

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Delegation Approval'),
        backgroundColor: Color.fromARGB(255, 243, 239, 239),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (delegationApprovalData == null || delegationApprovalData!.isEmpty) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Delegation Approval'),
        body:  Center(
          child: Text(
            "No Pending Delegation Applications",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 239, 239),
      appBar: const CustomAppBar(title: 'Delegation Approval'),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: delegationApprovalData!.length,
        itemBuilder: (context, index) {
          final item = delegationApprovalData![index];
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Day Order Hour: ${item['dayorderhour']}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  RichText(
                    text: TextSpan(
                      text: "Delegating Employee: ",
                      style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: item['delegatingemployee'],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)
                        )
                      ]
                    ),
                  ),
                  const SizedBox(height: 10),
                   RichText(
                    text: TextSpan(
                      text: "Receiving Employee: ",
                      style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: item['recevingemployee'],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)
                        )
                      ]
                    ),
                  ),
                   const SizedBox(height: 10),
                   RichText(
                    text: TextSpan(
                      text: "Subject: ",
                      style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: item['subject'],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)
                        )
                      ]
                    ),
                  ),
                   const SizedBox(height: 10),
                   RichText(
                    text: TextSpan(
                      text: "Program Section: ",
                      style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: item['programsection'],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)
                        )
                      ]
                    ),
                  ),
                   const SizedBox(height: 10),
                   RichText(
                    text: TextSpan(
                      text: "Delegation Date: ",
                      style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: item['delegationdate'],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)
                        )
                      ]
                    ),
                  ),
                   const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => _approveOrRejectDelegation(1, int.parse(item?["attendancedelegationid"])),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Approve", style: TextStyle(color: Colors.white),),
                      ),
                      ElevatedButton(
                        onPressed: () => _approveOrRejectDelegation(9, int.parse(item?["attendancedelegationid"])),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Reject", style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
