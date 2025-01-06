class LoginData {
  final String eid;
  final String officeId;
  final String designation;
  final String department;
  final List<String> menuIds;
  final String employeeId;
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