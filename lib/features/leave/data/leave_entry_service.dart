import 'dart:convert';
import 'package:srm_staff_portal/baseUrl.dart';
import 'package:srm_staff_portal/encryption_provider.dart';


class LeaveEntryService {
  Future<List?> listLeavePeriodJson(
      {required String eid,
      required EncryptionProvider encryptionProvider}) async {
    const String methodName = "listLeavePeriodJson";
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
         if(getData?.stringData==null){
          print(" List ${getData?.mapData.runtimeType}");
          return [getData?.mapData];
        }
        return jsonDecode(getData!.stringData!);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List?> listLeaveTypeJson({required int leavePeriodId,required String eid,
      required EncryptionProvider encryptionProvider}) async{
    const String methodName = "listLeaveTypeJson";
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
      final getData = await bUrl.baseUrl(userData, methodName, encryptionProvider);
        return jsonDecode(getData!.stringData!);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> saveEmployeeLeaveDetailsJson({required int leavePeriodId,required String eid,
      required int leaveTypeId, required String fromDate, required String toDate, required int fromSession, required int toSession, required String reason, required double leaveAppliedDays, required EncryptionProvider encryptionProvider}) async{
        print(leaveAppliedDays);
    const String methodName = "saveEmployeeLeaveDetailsJson";
    String userData = '';
    userData = '<leaveperiodid>$leavePeriodId</leaveperiodid>';
    userData += '<leavetypeid>$leaveTypeId</leavetypeid>';
    userData += '<fromdate>$fromDate</fromdate>';
    userData += '<fromsession>$fromSession</fromsession>';
    userData += '<todate>$toDate</todate>';
    userData += '<tosession>$toSession</tosession>';
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
      final getData = await bUrl.baseUrl(userData, methodName, encryptionProvider);
      return getData!.stringData!;
    } catch (e) {
      print(e);
    }
    return null;
  }
}