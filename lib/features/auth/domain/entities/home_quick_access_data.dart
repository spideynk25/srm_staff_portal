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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationData &&
        other.title == title &&
        other.message == message &&
        other.date == date;
  }

  @override
  int get hashCode => title.hashCode ^ message.hashCode ^ date.hashCode;
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
      notifications: (json['notifications'] as List<dynamic>?)
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeQuickAccessData &&
        other.staffPhoto == staffPhoto &&
        other.notifications.length == notifications.length &&
        _listEquals(other.notifications, notifications) &&
        other.pendingLeaveCount == pendingLeaveCount &&
        other.pendingDelegationCount == pendingDelegationCount &&
        other.birthDayEmployeeName == birthDayEmployeeName;
  }

  @override
  int get hashCode {
    return staffPhoto.hashCode ^
        Object.hashAll(notifications) ^ // 🔥 Fixes list hash issue
        pendingLeaveCount.hashCode ^
        pendingDelegationCount.hashCode ^
        birthDayEmployeeName.hashCode;
  }

  bool _listEquals(List<NotificationData> a, List<NotificationData> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false; // Deep object comparison
    }
    return true;
  }
}
