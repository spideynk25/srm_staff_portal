import 'dart:convert';
import 'dart:developer';
import 'package:srm_staff_portal/baseUrl.dart';
import 'package:srm_staff_portal/encryption_provider.dart';



class PermissionEntryService {
 
  Future<List?> listLeavePeriodandTypeforPermissionJson({required String eid,
      required EncryptionProvider encryptionProvider}) async{
    const String methodName = "listLeavePeriodandTypeforPermissionJson";
    String userData = '';
    //userData = '<leaveperiodid>$leavePeriodId</leaveperiodid>';
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
      if(getData!.mapData!.isNotEmpty){
          return [getData.mapData];
        }
      return jsonDecode(getData.stringData!);
    } catch (e) {
      log("$e");
    }
    return null;
  }

  Future<String?> saveEmployeePermissionDetailsJson({required int leavePeriodId,required String eid,
      required int leaveTypeId, required String fromDate, required String toDate, required String reason, required double leaveAppliedDays, required EncryptionProvider encryptionProvider}) async{
        print(leaveAppliedDays);
    const String methodName = "saveEmployeePermissionDetailsJson";
    String userData = '';
    userData = '<leaveperiodid>$leavePeriodId</leaveperiodid>';
    userData += '<leavetypeid>$leaveTypeId</leavetypeid>';
    userData += '<fromdate>$fromDate</fromdate>';
    userData += '<todate>$toDate</todate>';
    userData += '<reason>$reason</reason>';
    userData += '<leaveapplieddays>$leaveAppliedDays</leaveapplieddays>';
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
      return getData!.stringData!;
    } catch (e) {
      log("$e");
    }
    return null;
  }
}