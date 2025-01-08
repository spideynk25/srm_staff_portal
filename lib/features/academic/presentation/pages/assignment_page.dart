import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/academic/data/internal_marks_service.dart';
import 'package:srm_staff_portal/features/academic/presentation/pages/enter_marks_page.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';

class AssignmentPage extends ConsumerStatefulWidget {
  final int breakupId;
  final String title;
  final String selectedDate;
  const AssignmentPage(
      {super.key,
      required this.breakupId,
      required this.title,
      required this.selectedDate});

  @override
  ConsumerState<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends ConsumerState<AssignmentPage> {
  List<dynamic>? internalBreakupsData;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInternalBreakups();
    });
    _fetchInternalBreakups();
  }

  Future<void> _fetchInternalBreakups() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final internalMarksService = InternalMarksService();

    try {
      final data = await internalMarksService.getInternalBreakups(
        breakupId: widget.breakupId,
        eid: eid,
        encryptionProvider: encryption,
      );
      log("$data");
      setState(() {
        internalBreakupsData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("Error fetching profile data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: CustomAppBar(title: widget.title),
        backgroundColor: const Color.fromARGB(255, 243, 239, 239),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(title: widget.title),
        body: ListView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: internalBreakupsData?.length,
          itemBuilder: (context, index) {
            final item = internalBreakupsData?[index];
            return Card(
                margin: const EdgeInsets.only(top: 15),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black)),
                    tileColor: item["EnteredCnt"] == "0"
                        ? Colors.white
                        : Colors.green.shade200,
                    title: Text(
                      item["programsection"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.black),
                    onTap: () async {
                      final refetch = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EnterMarksPage(
                              programSectionData: item,
                              breakupId: widget.breakupId,
                              selectedDate: widget.selectedDate,
                            ),
                          ));
                      if (refetch == "refetch") {
                        _fetchInternalBreakups();
                      }
                    }));
          },
        ));
  }
}
