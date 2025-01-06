class NotificationData {
  final String title;
  final String message;
  final String date;

  NotificationData({
    required this.title,
    required this.message,
    required this.date,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
    );
  }
}

class HomeQuickAccessData {
  final String pendingLeaveCount;
  final String staffPhoto;
  final String pendingDelegationCount;
  final String designation;
  final String birthDayEmployeeName;
  final List<NotificationData> notifications;

  HomeQuickAccessData({
    required this.pendingLeaveCount,
    required this.staffPhoto,
    required this.pendingDelegationCount,
    required this.designation,
    required this.birthDayEmployeeName,
    required this.notifications,
  });

  factory HomeQuickAccessData.fromJson(Map<String, dynamic> json) {
    return HomeQuickAccessData(
      pendingLeaveCount: json['pendingleavecount']?.toString() ?? '0',
      staffPhoto: json['staffphoto']?.toString() ?? '',
      pendingDelegationCount: json['pendingdelegationcount']?.toString() ?? '0',
      designation: json['designation']?.toString() ?? '',
      birthDayEmployeeName: json['birthdayemployeename']?.toString() ?? '',
      notifications: (json['notifications'] as List<dynamic>?) // Fixed key here
              ?.map((item) => NotificationData.fromJson(item))
              .toList() ??
          [],
    );
  }

  
  static HomeQuickAccessData fromJsonList(List<dynamic> jsonList) {
    List<Map<String, dynamic>> notificationsList = [];
    Map<String, dynamic> mergedJson = {};

    for (var item in jsonList) {
      if (item.containsKey('notificationtitle')) {
        notificationsList.add({
          'title': item['notificationtitle'],
          'message': item['message'],
          'date': "${item['notificationdate']} ${item['notificationtime']}",
        });
      } else {
        mergedJson.addAll(item as Map<String, dynamic>);
      }
    }

   
    mergedJson['notifications'] = notificationsList;

    // Parse the final structure
    return HomeQuickAccessData.fromJson(mergedJson);
  }
}
