import 'dart:convert';
import 'dart:developer';
import 'package:srm_staff_portal/baseUrl.dart';
import 'package:srm_staff_portal/encryption_provider.dart';


class MyTimetableService {
  Future<Map<String, dynamic>?> getStudentAttendanceTemplateJson(
      {required String eid,
      required EncryptionProvider encryptionProvider}) async {
    const String methodName = 'getStudentAttendanceTemplateJson';

    String userData = '';
    userData = '<employeeid>$eid</employeeid>';
    userData += '<deviceid>7308f02e728e36a8</deviceid>';
    userData += '<androidversion>14</androidversion>';
    userData += '<model>SM-M336BU</model>';
    userData += '<sdkversion>30</sdkversion>';
    userData += '<appversion>V 1.0.0</appversion>';

    try {
      Baseurl bUrl = Baseurl();
      final getData =
          await bUrl.baseUrl(userData, methodName, encryptionProvider);
      log("string ${getData?.stringData}");
      log("mapdata ${getData?.mapData}");
      return jsonDecode(getData!.stringData!)[0];
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<dynamic>?> getEmployeeTimeTableJson(
      {required int templateId,
      required String eid,
      required EncryptionProvider encryptionProvider}) async {
    log("service $templateId");
    const String methodName = 'getEmployeeTimeTableJson';
    String userData = '';
    userData = '<templateid>$templateId</templateid>';
    userData += '<employeeid>$eid</employeeid>';
    userData += '<deviceid>7308f02e728e36a8</deviceid>';
    userData += '<androidversion>14</androidversion>';
    userData += '<model>SM-M336BU</model>';
    userData += '<sdkversion>30</sdkversion>';
    userData += '<appversion>V 1.0.0</appversion>';

    try {
      Baseurl bUrl = Baseurl();
      final getData =
          await bUrl.baseUrl(userData, methodName, encryptionProvider);
      log("string ${getData?.stringData}");
      log("mapdata ${getData?.mapData}");
      return jsonDecode(getData!.stringData!);
    } catch (e) {
      print(e);
    }
    return null;
  }
}
