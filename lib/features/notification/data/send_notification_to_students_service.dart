import 'dart:convert';
import 'dart:developer';

import 'package:srm_staff_portal/baseUrl.dart';
import 'package:srm_staff_portal/encryption_provider.dart';

class SendNotificationToStudentsService {
   Future<List<dynamic>?> getStaffSubjectsDetails(
      {required String eid,
      required EncryptionProvider encryptionProvider}) async {
    const String methodName = 'getStaffSubjectsJson';
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

   Future<List<dynamic>?> getStudentListDetails(
      {
        required int subjectId,
        required int programSectionId,
        required String eid,
        required EncryptionProvider encryptionProvider
      }) async {
    const String methodName = 'getStudentListJson';
    String userData = '';
    userData = '<subjectid>$subjectId</subjectid>';
    userData += '<programsectionid>$programSectionId</programsectionid>';
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
      return jsonDecode(getData.stringData!);

    } catch (e) {
      print(e);
    }
    return null;
  }

   Future<Map<String, dynamic>?> sendNotification(
      {
        required String returnData,
        required int subjectId,
        required String notificationMessage,
        required String eid,
        required EncryptionProvider encryptionProvider
      }) async {
        log("service returndata $returnData, DataType: ${returnData.runtimeType} \n");
        log("service subjectid $subjectId, DataType: ${subjectId.runtimeType} \n");
        log("service notificationMessage $notificationMessage, DataType: ${notificationMessage.runtimeType} \n");
        log("service eid $eid, DataType: ${eid.runtimeType} \n");
    const String methodName = 'sendNotification';
    String userData = '';
    userData = '<returndata>$returnData</returndata>';
    userData += '<subjectid>$subjectId</subjectid>';
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