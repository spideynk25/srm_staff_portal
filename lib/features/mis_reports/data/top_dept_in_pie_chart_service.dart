import 'dart:convert';
import 'dart:developer';
import 'package:srm_staff_portal/baseUrl.dart';
import 'package:srm_staff_portal/encryption_provider.dart';


class TopDeptInPieChartService {
  Future<List<dynamic>?> getTopLimitDept(
      {required int officeId,
      required int classworkTypeId,
      required int limit,
      required String eid,
      required EncryptionProvider encryptionProvider}) async {
    const String methodName = 'getTopLimitDeptJson';
    String userData = '';
    userData = '<officeid>$officeId</officeid>';
    userData += '<classworktypeid>$classworkTypeId</classworktypeid>';
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
      log("str ${getData?.stringData}");
      return jsonDecode(getData!.stringData!);
    } catch (e) {
      print(e);
    }
    return null;
  }
}
