import 'dart:convert';
import 'dart:developer';

import 'package:srm_staff_portal/baseUrl.dart';
import 'package:srm_staff_portal/encryption_provider.dart';

class HomeQuickAccessService {
   Future<List<dynamic>?> dashBoardData({
    required String eid,
    required EncryptionProvider encryptionProvider,
  }) async {
    //const String namespace = "http://ws.fipl.com/";
    const String methodName = "employeeHomePageJson";
    //log("service page for eid $eid");
    String userData = '';
    userData = '<employeeid>$eid</employeeid>';
    userData += '<deviceid>7308f02e728e36a8</deviceid>';
    userData += '<androidversion>14</androidversion>';
    userData += '<model>SM-M336BU</model>';
    userData += '<sdkversion>30</sdkversion>';
    userData += '<appversion>V 1.0.0</appversion>';
    final encryptedUserData = encryptionProvider.getEncryptedData(userData);
    //log("encrypted data: $encryptedUserData");
    try {
      Baseurl bUrl = Baseurl();
      final getData =
          await bUrl.baseUrl(userData, methodName, encryptionProvider);
      // log("string login 2${getData?.stringData}");
      // log("mapdata login 2${getData?.mapData}");
      return jsonDecode(getData!.stringData!);
    } catch (e) {
      throw Exception('Error during login: $e');
    } 
  }
}