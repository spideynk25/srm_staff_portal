import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/auth/domain/repos/login_data_provider.dart';
import 'package:srm_staff_portal/features/leave/presentation/components/detailed_row.dart';
import 'package:srm_staff_portal/features/profile/data/profile_service.dart';
import 'package:srm_staff_portal/main.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:srm_staff_portal/widgets/custom_drawer.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final bool isDrawer;
  const ProfilePage({super.key, required this.isDrawer});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProfileData();
    });
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final encryption = ref.read(encryptionProvider.notifier);
    final eid = ref.watch(loginDataProvider)!.eid;
    final profileService = ProfileService();

    try {
      final data = await profileService.getProfileDetails(
        eid: eid,
        encryptionProvider: encryption,
      );
      print(data);
      setState(() {
        profileData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching profile data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final department = ref.watch(loginDataProvider)?.department;
    if (isLoading) {
      return  Scaffold(
        appBar: CustomAppBar(title: 'Profile'),
        backgroundColor: Color.fromARGB(255, 243, 239, 239),
        drawer: widget.isDrawer ? CustomDrawer() : null,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (profileData == null) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Profile'),
        backgroundColor: Color.fromARGB(255, 243, 239, 239),
        drawer: widget.isDrawer ? CustomDrawer() : null,
        body: Center(
          child: Text(
            "Failed to load profile data.",
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    }

    Uint8List? profileImage;
    if (profileData?['staffphoto'] != null) {
      profileImage = base64Decode(profileData!['staffphoto']);
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 239, 239),
      appBar: const CustomAppBar(title: 'Profile'),
      drawer: widget.isDrawer ? CustomDrawer() : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).highlightColor.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black45,
                            width: 1), // Black border with width
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: profileImage == null
                            ? Container(
                                width: 130,
                                height: 130,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.person,
                                  size: 70,
                                  color: Colors.grey,
                                ),
                              )
                            : Image.memory(
                                profileImage,
                                width: 130,
                                height: 130,
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profileData?["Name"] ?? "N/A",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      profileData?["Designation"] ?? "N/A",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      department ?? "N/A",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                DetailedRow(
                  label: "Qualification",
                  value: profileData?['Qualification'],
                  icon: Icons.school,
                ),
                DetailedRow(
                  label: "Email",
                  value: profileData?['Email'],
                  icon: Icons.email,
                ),
                DetailedRow(
                  label: "Date of Birth",
                  value: profileData?['DOB'],
                  icon: Icons.cake,
                ),
                DetailedRow(
                  label: "Date of Joining",
                  value: profileData?['DOJ'],
                  icon: Icons.calendar_today,
                ),
                DetailedRow(
                  label: "Mobile",
                  value: profileData?['Mobile'],
                  icon: Icons.phone,
                ),
                DetailedRow(
                  label: "Division",
                  value: profileData?['Division'],
                  icon: Icons.apartment,
                ),
                DetailedRow(
                  label: "Address",
                  value: profileData?['Address'],
                  icon: Icons.location_on,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
