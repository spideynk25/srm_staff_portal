import 'dart:convert';
import 'dart:developer';

import 'package:srm_staff_portal/baseUrl.dart';
import 'package:srm_staff_portal/encryption_provider.dart';


class LmsReportService {
  Future<List<dynamic>?> getOfficesList(
      {required String eid,
      required EncryptionProvider encryptionProvider}) async {
    const String methodName = 'getOfficesListJson';
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
      log("map ${getData?.mapData}");
      log("string ${getData?.stringData}");
      return jsonDecode(getData!.stringData!);

    } catch (e) {
      log("$e");
    }
    return null;
  }

  Future<List<dynamic>?> getDivisionsList(
      {
        required int officeId,
        required String eid,
        required EncryptionProvider encryptionProvider
      }) async {
    const String methodName = 'getDivisionsListJson';
    String userData = '';
    userData = '<officeid>$officeId</officeid>';
    userData += '<employeeid>$eid</employeeid>';
    userData += '<deviceid>7308f02e728e36a8</deviceid>';
    userData += '<androidversion>14</androidversion>';
    userData += '<model>SM-M336BU</model>';
    userData += '<sdkversion>30</sdkversion>';
    userData += '<appversion>V 1.0.0</appversion>';
    try {
      Baseurl bUrl = Baseurl();  
      final getData = await bUrl.baseUrl(userData, methodName, encryptionProvider);
      log("map ${getData?.mapData}");
      log("string ${getData?.stringData}");
      return jsonDecode(getData!.stringData!);

    } catch (e) {
      log("$e");
    }
    return null;
  }

  Future<List<dynamic>?> getClassWorkTypeList(
      {
        required String eid,
        required EncryptionProvider encryptionProvider
      }) async {
    const String methodName = 'getClassWorkTypeListJson';
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
      log("map ${getData?.mapData}");
      log("string ${getData?.stringData}");
      return jsonDecode(getData!.stringData!);

    } catch (e) {
      log("$e");
    }
    return null;
  }

   Future<List<dynamic>?> getTopFaculty(
      {required int officeId,
      required int cwtId,
      required int limit,
      required String eid,
      required EncryptionProvider encryptionProvider}) async {
    const String methodName = 'getTopLimitFacultyJson';
    String userData = '';
    userData = '<officeid>$officeId</officeid>';
    userData += '<classworktypeid>$cwtId</classworktypeid>';
    userData += '<limit>$limit</limit>';
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
      log("map ${getData?.mapData}");
      log("string ${getData?.stringData}");
      return jsonDecode(getData!.stringData!);
    } catch (e) {
      log("$e");
    }
    return null;
  }

  Future<List<dynamic>?> getUsedNotUsedCount(
      {required int officeId,
      required int divisionId,
      required String eid,
      required EncryptionProvider encryptionProvider}) async {
    const String methodName = 'getUsedNotUsedFacultyCountJson';
    String userData = '';
    userData = '<officeid>$officeId</officeid>';
    userData += '<divisionid>$divisionId</divisionid>';
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
      log("map ${getData?.mapData}");
      log("string ${getData?.stringData}");
      return jsonDecode(getData!.stringData!);
    } catch (e) {
      log("$e");
    }
    return null;
  }

  Future<List<dynamic>?> getNotUsedList(
      {required int officeId,
      required int divisionId,
      required String eid,
      required EncryptionProvider encryptionProvider}) async {
    const String methodName = 'getLMSNotUsedEmployeesListJson';
    String userData = '';
    userData = '<officeid>$officeId</officeid>';
    userData += '<divisionid>$divisionId</divisionid>';
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
      log("map ${getData?.mapData}");
      log("string ${getData?.stringData}");
      return jsonDecode(getData!.stringData!);
    } catch (e) {
      log("$e");
    }
    return null;
  }
}
