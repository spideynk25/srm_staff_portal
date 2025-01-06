import 'dart:convert';
import 'dart:developer';
import 'package:srm_staff_portal/baseUrl.dart';
import 'package:srm_staff_portal/encryption_provider.dart';



class StudentAttendanceService {
  Future<Map<String, dynamic>?> getStudentAttendanceTemplate(
      {required String eid,
      required EncryptionProvider encryptionProvider}) async {
    //const String namespace = 'http://ws.fipl.com/';
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

  Future<List<dynamic>?>? getStudentAttendanceHourWiseCourses(
      {required int attendanceTemplateId,
      required String attendanceData,
      required String eid,
      required EncryptionProvider encryptionProvider}) async {
    //const String namespace = 'http://ws.fipl.com/';
    const String methodName = 'getStudentAttendanceHourWiseCoursesJson';
    String userData = '';
    userData =
        '<attendancetemplateid>$attendanceTemplateId</attendancetemplateid>';
    userData += '<attendancedate>$attendanceData</attendancedate>';
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
      log("str ${getData?.stringData}");
      log("mapdata ${getData?.mapData}");
      if(getData?.mapData!=null){
        return [getData?.mapData];
      }
      return jsonDecode(getData!.stringData!);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<dynamic>?> getSubjectListforDelegation(
      {required int officeId,
      required String programSectionId,
      required String delegateempId,
      required String eid,
      required EncryptionProvider encryptionProvider}) async {
    //const String namespace = 'http://ws.fipl.com/';
    const String methodName = 'getSubjectListforDelegationJson';
  
    String userData = '';
    userData = '<officeid>$officeId</officeid>';
    userData += '<programsectionid>$programSectionId</programsectionid>';
    userData += '<Delegateempid>$delegateempId</Delegateempid>';
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
      log("string  ${getData?.stringData}");
      log("mapdata ${getData?.mapData}");
      return jsonDecode(getData!.stringData!);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<dynamic>?> getStudentAttendanceList(
      {required int subjectId,
      required int officeId,
      required String programSectionId,
      required String eid,
      required EncryptionProvider encryptionProvider}) async {
    log("subjectid $subjectId");
    log("officeID $officeId");
    log(programSectionId);
    //const String namespace = 'http://ws.fipl.com/';
    const String methodName = 'getStudentAttendanceListJson';
   
    String userData = '';
    userData = '<subjectid>$subjectId</subjectid>';
    userData += '<officeid>$officeId</officeid>';
    userData += '<programsectionid>$programSectionId</programsectionid>';
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

   Future<List<dynamic>?> getAttendanceDetails(
    {
      required int transId,
      required String eid,
      required EncryptionProvider encryptionProvider}) async {
    //const String namespace = 'http://ws.fipl.com/';
    const String methodName = 'getAttendanceDetailsJson';
    
    String userData = '';
    userData = '<transid>$transId</transid>';
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
  
   Future<Map<String, dynamic>?> saveStudentAttendance(
    {
      required String returnData,
      required int subjectId,
      required int delegationId,
      required String attendanceDate,
      required int dayOrderId,
      required int hourId,
      required String eid,
      required EncryptionProvider encryptionProvider}) async {
    //const String namespace = 'http://ws.fipl.com/';
    const String methodName = 'saveStudentAttendance';
   
    String userData = '';
    userData = '<returndata>$returnData</returndata>';
    userData += '<subjectid>$subjectId</subjectid>';
    userData += '<delegationid>$delegationId</delegationid>';
    userData += '<attendancedate>$attendanceDate</attendancedate>';
    userData += '<dayorderid>$dayOrderId</dayorderid>';
    userData += '<hourid>$hourId</hourid>';
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
     
        return getData?.mapData;
      
    } catch (e) {
      print(e);
    }
    return null;
  }
   Future<Map<String, dynamic>?> cancelStudentAttendance(
    {
      required int attendanceTransactionId,
      required String eid,
      required EncryptionProvider encryptionProvider}) async {
    //const String namespace = 'http://ws.fipl.com/';
    const String methodName = 'cancelStudentAttendance';
  
    String userData = '';
    userData = '<attendancetransactionid>$attendanceTransactionId</attendancetransactionid>';
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
      return jsonDecode(getData!.stringData!)[0];
    } catch (e) {
      print(e);
    }
    return null;
  }
  
}
