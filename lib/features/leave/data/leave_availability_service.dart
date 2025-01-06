import 'dart:convert';
import 'dart:developer';
import 'package:srm_staff_portal/baseUrl.dart';
import 'package:srm_staff_portal/encryption_provider.dart';


class LeaveAvailabilityService {
  Future<List?> getLeaveAvailability(
      {required String eid,
       required EncryptionProvider encryptionProvider,
       required int leavePeriodId 
    }) async {
    //const String namespace = 'http://ws.fipl.com/';
    const String methodName = "listLeaveAvailability";
    String userData = '';
    userData = '<leaveperiodid>$leavePeriodId</leaveperiodid>';
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