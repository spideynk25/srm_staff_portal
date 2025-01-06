import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/mis_reports/data/faculty_services.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';

class LibraryTransaction extends ConsumerStatefulWidget {
  const LibraryTransaction({super.key});

  @override
  ConsumerState<LibraryTransaction> createState() => LibraryTransactionState();
}

class LibraryTransactionState extends ConsumerState<LibraryTransaction>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic>? transactionData;
  List<dynamic>? fineHistoryData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final facultyService = FacultyServices();

    try {
      final transactionsResponse = await facultyService.getLibTrans(
          eid: eid, encryptionProvider: encryption);
      final fineHistoryResponse = await facultyService.getFineHistory(
          eid: eid, encryptionProvider: encryption);

      if (transactionsResponse != null &&
          transactionsResponse['Status'] == 'Success') {
        transactionData = transactionsResponse['Data'];
      }

      if (fineHistoryResponse != null &&
          fineHistoryResponse['Status'] == 'Success') {
        fineHistoryData = fineHistoryResponse['Data'];
      }
    } catch (e) {
      log("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Library Transaction'),
        backgroundColor: Color.fromARGB(255, 243, 239, 239),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Library Transaction',
        tabBar: TabBar(
          unselectedLabelColor: Colors.white,
          indicator: BoxDecoration(
              color: Colors.orange.shade800,
              borderRadius: BorderRadius.circular(16)),
          //indicatorColor: Colors.orange,

          indicatorPadding: const EdgeInsets.all(4),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          controller: _tabController,
          tabs: const [
            Tab(text: 'Transaction'),
            Tab(text: 'Fine History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildTransactionTab(),
          buildFineHistoryTab(),
        ],
      ),
    );
  }

  Widget buildTransactionTab() {
    return transactionData != null && transactionData!.isNotEmpty
        ? ListView.builder(
            itemCount: transactionData!.length,
            itemBuilder: (context, index) {
              final transaction = transactionData![index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.all(4),
                color: Colors.grey.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade800, width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month_rounded,
                                size: 30, color: Colors.blue.shade800),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Issue Date:",
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  transaction['issuedate'] ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.contacts_rounded,
                                size: 30, color: Colors.blue.shade800),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Accession Number:",
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  transaction['accessionno'] ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.title_sharp,
                                size: 30, color: Colors.blue.shade800),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Title:",
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  transaction['title'] ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.calendar_month_rounded,
                                size: 30, color: Colors.blue.shade800),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Due Date:",
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  transaction['duedate'] ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.calendar_month_rounded,
                                size: 30, color: Colors.blue.shade800),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Due Days:",
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  transaction['duedays'] ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.arrow_drop_down_circle_rounded,
                                size: 30, color: Colors.blue.shade800),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Status:",
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  transaction['status'] ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.calendar_month_rounded,
                                size: 30, color: Colors.blue.shade800),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Return Date:",
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  transaction['returndate'] ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : const Center(child: Text('No transactions available.'));
  }

  Widget buildFineHistoryTab() {
    return fineHistoryData != null && fineHistoryData!.isNotEmpty
        ? ListView.builder(
            itemCount: fineHistoryData!.length,
            itemBuilder: (context, index) {
              final fine = fineHistoryData![index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.all(4),
                color: Colors.grey.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade800, width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.money_rounded,
                                size: 30, color: Colors.blue.shade800),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Fine:",
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  fine['fine'] ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.contacts_rounded,
                                size: 30, color: Colors.blue.shade800),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Accession Number:",
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  fine['accessionno'] ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.title_sharp,
                                size: 30, color: Colors.blue.shade800),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Title:",
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  fine['title'] ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.calendar_month_rounded,
                                size: 30, color: Colors.blue.shade800),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Due Date:",
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  fine['duedate'] ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.arrow_drop_down_circle_rounded,
                                size: 30, color: Colors.blue.shade800),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Status:",
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  fine['status'] ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.calendar_month_rounded,
                                size: 30, color: Colors.blue.shade800),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Return Date:",
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  fine['returndate'] ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : const Center(child: Text('No fine history available.'));
  }
}
