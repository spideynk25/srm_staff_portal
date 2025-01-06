import 'dart:convert';
import 'dart:developer';

import 'package:srm_staff_portal/baseUrl.dart';
import 'package:srm_staff_portal/encryption_provider.dart';


class SendNotificationToStaffService {
   Future<List<dynamic>?> getEmployeeList(
      {required String eid,
      required EncryptionProvider encryptionProvider}) async {
    const String methodName = 'getEmployeeListJson';
    String userData = '';
    userData = '<employeeid>$eid</employeeid>';
    userData += '<deviceid>7308f02e728e36a8</deviceid>';
    userData += '<androidversion>14</androidversion>';
    userData += '<model>SM-M336BU</model>';
    userData += '<sdkversion>30</sdkversion>';
    userData += '<appversion>V 1.0.0</appversion>';
    try {
      Baseurl bUrl = Baseurl();  
      final getData = await bUrl.baseUrl(userData, methodName, encryptionProvider);
      log("${getData!.mapData}");
      log("${getData.stringData}");
      return jsonDecode(getData.stringData!);

    } catch (e) {
      print(e);
    }
    return null;
  }

   Future<Map<String, dynamic>?> sendNotificationToEmployees(
      {
        required String returnData,
        required String notificationMessage,
        required String eid,
        required EncryptionProvider encryptionProvider
      }) async {
        log("service returndata $returnData datatype ${returnData.runtimeType}");
        log("service notificationMessage $notificationMessage datatype ${notificationMessage.runtimeType}");
        log("service eid $eid datatype ${eid.runtimeType}");
    const String methodName = 'sendNotificationToEmployees';
    String userData = '';
    userData = '<returndata>$returnData</returndata>';
    userData += '<notificationmessage>$notificationMessage</notificationmessage>';
    userData += '<employeeid>$eid</employeeid>';
    userData += '<deviceid>7308f02e728e36a8</deviceid>';
    userData += '<androidversion>14</androidversion>';
    userData += '<model>SM-M336BU</model>';
    userData += '<sdkversion>30</sdkversion>';
    userData += '<appversion>V 1.0.0</appversion>';
    try {
      Baseurl bUrl = Baseurl();  
      final getData = await bUrl.baseUrl(userData, methodName, encryptionProvider);
      log("str ${getData!.stringData}");
      log("map ${getData.mapData}");
      return getData.mapData!;

    } catch (e) {
      print(e);
    }
    return null;
  }
}