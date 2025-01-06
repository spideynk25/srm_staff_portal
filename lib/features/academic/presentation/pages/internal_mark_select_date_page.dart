import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:srm_staff_portal/features/academic/presentation/pages/assignment_page.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';

class InternalMarkSelectDatePage extends ConsumerStatefulWidget {
  final int breakupId;
  final String title;
  const InternalMarkSelectDatePage(
      {super.key, required this.breakupId, required this.title});

  @override
  ConsumerState<InternalMarkSelectDatePage> createState() =>
      _InternalMarkSelectDatePageState();
}

class _InternalMarkSelectDatePageState
    extends ConsumerState<InternalMarkSelectDatePage> {
  DateTime? initialDate = DateTime.now();
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2009),
      lastDate: DateTime.now(),
      initialDate: initialDate,
    );
    setState(() {
      selectedDate = pickedDate;
      initialDate = pickedDate;
    });
    if (pickedDate != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssignmentPage(
              selectedDate:
                  "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}",
              breakupId: widget.breakupId,
              title: widget.title,
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
          title: "Internal Marks Entry"),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () => _selectDate(context),
                  ),
                  selectedDate == null
                      ? const Text("Select Date")
                      : Text(DateFormat('dd/MM/yyyy').format(selectedDate!)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Select a date to enter the marks",
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
