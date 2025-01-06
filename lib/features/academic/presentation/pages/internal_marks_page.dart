import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/academic/data/internal_marks_service.dart';
import 'package:srm_staff_portal/features/academic/presentation/pages/internal_mark_select_date_page.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:srm_staff_portal/widgets/custom_card_widgets.dart';


class InternalMarksPage extends ConsumerStatefulWidget {
  const InternalMarksPage({super.key});

  @override
  ConsumerState<InternalMarksPage> createState() => _InternalMarksPageState();
}

class _InternalMarksPageState extends ConsumerState<InternalMarksPage> {
  List<dynamic>? internalMarksItems;
  List<dynamic>? internalBreakupsData;
  bool isLoading = true;
 

   late Map<String, dynamic> internalMarksMetaData = {};


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMetaData();
      _fetchTestComponent();
    });
    _fetchTestComponent();
  }

  void _initializeMetaData() {
  internalMarksMetaData ={
    "Assignment": {
      "icon": "assets/icons/icon_markentry.jpg",
      "action": (BuildContext context, breakupId, title) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InternalMarkSelectDatePage(
                breakupId: breakupId,
                title: title,
              ),
            ),
          ),
    },
    "Model Exam": {
      "icon": "assets/icons/icon_markentry.jpg",
      "action": (BuildContext context, breakupId, title) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InternalMarkSelectDatePage(
                breakupId: breakupId,
                title: title,
              ),
            ),
          ),
    },
    "Model Practical": {
      "icon":"assets/icons/icon_markentry.jpg",
      "action": (BuildContext context, breakupId, title) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InternalMarkSelectDatePage(breakupId: breakupId, title: title,),
          ))
    },
    "Record": {
      "icon": "assets/icons/icon_markentry.jpg",
      "action": (BuildContext context, breakupId, title) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InternalMarkSelectDatePage(breakupId: breakupId, title: title,),
          ))
    },
    "Seminar": {
      "icon": "assets/icons/icon_markentry.jpg",
      "action": (BuildContext context, breakupId, title) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InternalMarkSelectDatePage(breakupId: breakupId, title: title,),
          ))
    },
    "Test 1": {
      "icon": "assets/icons/icon_markentry.jpg",
      "action": (BuildContext context, breakupId, title) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InternalMarkSelectDatePage(breakupId: breakupId, title: title,),
          ))
    },
    "Test 2": {
      "icon": "assets/icons/icon_markentry.jpg",
      "action": (BuildContext context, breakupId, title) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InternalMarkSelectDatePage(breakupId: breakupId, title: title),
          ))
    },
   
  };
}


  Future<void> _fetchTestComponent() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final internalMarksService = InternalMarksService();

    try {
      final data = await internalMarksService.getTestComponent(
        eid: eid,
        encryptionProvider: encryption,
      );
      print(data);
      setState(() {
        internalMarksItems = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching profile data: $e");
    }
  }

  // Future<void> _fetchInternalBreakups(int breakupId) async {
  //   final encryption = ref.read(encryptionProvider.notifier);
  //   final eid = ref.watch(loginDataProvider)!.eid;
  //   final internalMarksService = InternalMarksService();

  //   try {
  //     final data = await internalMarksService.getInternalBreakups(
  //       breakupId: breakupId,
  //       eid: eid,
  //       encryptionProvider: encryption,
  //     );
  //     print(data);
  //     setState(() {
  //       internalBreakupsData = data;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print("Error fetching profile data: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: "Internal Marks"),
        backgroundColor: Color.fromARGB(255, 243, 239, 239),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final List<String> internalMarksMetaDataKeys = internalMarksMetaData.keys.toList();
    final internalMarksData = internalMarksItems
        ?.where((data) => internalMarksMetaDataKeys.contains(data["breakupdesc"]))
        .toList();
        print("internal Marks$internalMarksData");
    return Scaffold(
      appBar: const CustomAppBar(title: "Internal Marks"),
        backgroundColor: const Color.fromARGB(255, 243, 239, 239),
        body: ListView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: internalMarksData?.length,
          itemBuilder: (context, index) {
            final item = internalMarksData?[index];
            log("item $item");
            final metaData = internalMarksMetaData[item["breakupdesc"]];
            log("metaData $metaData");
            return CustomCardWidgets(
              name: item["breakupdesc"],
              imagePath: metaData["icon"],
              onTap: () => metaData["action"](context, int.parse(item["breakupid"]), item["breakupdesc"]),
            );
          },
        ));
  }
}
