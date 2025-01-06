import 'dart:convert';
import 'dart:developer';
import 'package:srm_staff_portal/baseUrl.dart';
import 'package:srm_staff_portal/encryption_provider.dart';


class InternalMarksService {
  Future<List<dynamic>?> getTestComponent(
      {required String eid,
      required EncryptionProvider encryptionProvider}) async {
    //const String namespace = 'http://ws.fipl.com/';
    const String methodName = 'getTestcomponentJson';
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
      return jsonDecode(getData!.stringData!);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<dynamic>?> getInternalBreakups(
      {required int breakupId,
      required String eid,
      required EncryptionProvider encryptionProvider}) async {
    //const String namespace = 'http://ws.fipl.com/';
    const String methodName = 'getInternalBreakupsJson';
    String userData = '';
    userData = '<breakupid>$breakupId</breakupid>';
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

  Future<List<dynamic>?> getStudentsList(
      {required int breakupId,
      required int progSectionId,
      required int internalBreakUpId,
      required String eid,
      required EncryptionProvider encryptionProvider}) async {
    //const String namespace = 'http://ws.fipl.com/';
    const String methodName = 'getStudentsListJson';
    String userData = '';
    userData = '<internalbreakupid>$internalBreakUpId</internalbreakupid>';
    userData += '<progsectionid>$progSectionId</progsectionid>';
    userData += '<breakupid>$breakupId</breakupid>';
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

  Future<Map<String, dynamic>?> saveInternalMarkEntry(
      {required String returnData,
      required int progSectionId,
      required int internalBreakUpId,
      required String eid,
      required String examDate,
      required EncryptionProvider encryptionProvider}) async {
    // log("$returnData programsectionid $progSectionId $internalBreakUpId $eid $examDate");
    log("programsectionid $progSectionId");
    //const String namespace = 'http://ws.fipl.com/';
    const String methodName = 'saveInternalMarkEntry';
    String userData = '';
    userData = '<returndata>$returnData</returndata>';
    userData += '<internalbreakupid>$internalBreakUpId</internalbreakupid>';
    userData += '<programsectionid>$progSectionId</programsectionid>';
    userData += '<employeeid>$eid</employeeid>';
    userData += '<examdate>$examDate</examdate>';
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

  Future<List<dynamic>?> getInternalMarkEntriedDetails(
      {required int progSectionId,
      required int internalBreakUpId,
      required String eid,
      required String examDate,
      required EncryptionProvider encryptionProvider}) async {
    log("$progSectionId $internalBreakUpId $eid $examDate");
    //const String namespace = 'http://ws.fipl.com/';
    const String methodName = 'getInternalMarkEntriedDetailsJson';
    String userData = '';
    userData = '<internalbreakupid>$internalBreakUpId</internalbreakupid>';
    userData += '<progsectionid>$progSectionId</progsectionid>';
    userData += '<examdate>$examDate</examdate>';
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
