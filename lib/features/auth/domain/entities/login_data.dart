import 'package:hive/hive.dart';

part 'login_data.g.dart'; 

@HiveType(typeId: 0) 
class LoginData {
  @HiveField(0)
  final String eid;

  @HiveField(1)
  final String officeId;

  @HiveField(2)
  final String designation;

  @HiveField(3)
  final String department;

  @HiveField(4)
  final List<String> menuIds;

  @HiveField(5)
  final String employeeId;

  @HiveField(6)
  final String employeeName;

  LoginData({
    required this.eid,
    required this.officeId,
    required this.designation,
    required this.department,
    required this.menuIds,
    required this.employeeId,
    required this.employeeName,
  });

  static List<String> refactorMenuIds(String str) {
    return str
        .split(",")
        .map((data) {
          String hashFilter = data.replaceAll("#", "");
          return hashFilter.replaceAll(RegExp(r'\d'), "");
        })
        .toList();
  }

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      eid: json['eid']?.toString() ?? '',
      officeId: json['officeid']?.toString() ?? '',
      designation: json['designation'] ?? '',
      department: json['department'] ?? '',
      menuIds: refactorMenuIds(json['menuids'] ?? ''),
      employeeId: json['employeeid']?.toString() ?? '',
      employeeName: json['employeename'] ?? '',
    );
  }
}
