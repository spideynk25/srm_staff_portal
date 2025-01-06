import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:srm_staff_portal/encryption_provider.dart';

class ManagementServices {
  Future<Map<String, dynamic>?> getAdmissionList(
      {required String eid,
      required EncryptionProvider encryptionProvider}) async {
    final http.Client client = http.Client();
    //const String namespace = 'http://ws.fipl.com/';
    const String methodName = 'getCurrentYearAdmissionShift';
    const String soapAction = 'http://ws.fipl.com/';
    const String url =
        'http://115.244.251.14/evarsitywebserviceforflutter/EmployeeAndroid?wsdl';
    const int flag = 0;

    String userData = '';
    userData = '<flag>$flag</flag>';
    userData += '<employeeid>$eid</employeeid>';
    userData += '<deviceid>7308f02e728e36a8</deviceid>';
    userData += '<androidversion>14</androidversion>';
    userData += '<model>SM-M336BU</model>';
    userData += '<sdkversion>30</sdkversion>';
    userData += '<appversion>V 1.0.0</appversion>';

    final encryptedUserData = encryptionProvider.getEncryptedData(userData);
    String body = """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:exam="http://ws.fipl.com/">
      <soapenv:Header/>
      <soapenv:Body>
        <exam:$methodName>
            <EncryptedData i:type="d:string">$encryptedUserData</EncryptedData>
        </exam:$methodName>
      </soapenv:Body>
    </soapenv:Envelope>
    """;
    final headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': '$soapAction$methodName',
    };

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: utf8.encode(body),
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final xmlResponse = response.body;
        const startTag = '<return>';
        const endTag = '</return>';
        final startIndex = xmlResponse.indexOf(startTag) + startTag.length;
        final endIndex = xmlResponse.indexOf(endTag);
        final data = xmlResponse.substring(startIndex, endIndex);
        print("data: $data");
        final str1 = encryptionProvider.getDecryptedData(data);
        print("str${str1.stringData}");
        print("map ${str1.mapData}");
        return str1.mapData;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getDeptAdmission(
      {required int officeId,
      required String eid,
      required EncryptionProvider encryptionProvider}) async {
    final http.Client client = http.Client();
    // log("$returnData programsectionid $progSectionId $internalBreakUpId $eid $examDate");
    log("office id $officeId");
    //const String namespace = 'http://ws.fipl.com/';
    const String methodName = 'getDeptWiseAdmission';
    const String soapAction = 'http://ws.fipl.com/';
    const String url =
        'http://115.244.251.14/evarsitywebserviceforflutter/EmployeeAndroid?wsdl';
    String userData = '';
    userData = '<officeid>$officeId</officeid>';
    userData += '<employeeid>$eid</employeeid>';
    userData += '<deviceid>7308f02e728e36a8</deviceid>';
    userData += '<androidversion>14</androidversion>';
    userData += '<model>SM-M336BU</model>';
    userData += '<sdkversion>30</sdkversion>';
    userData += '<appversion>V 1.0.0</appversion>';

    final encryptedUserData = encryptionProvider.getEncryptedData(userData);
    log("userdata $encryptedUserData");
    String body = """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:exam="http://ws.fipl.com/">
      <soapenv:Header/>
      <soapenv:Body>
        <exam:$methodName>
            <EncryptedData i:type="d:string">$encryptedUserData</EncryptedData>
        </exam:$methodName>
      </soapenv:Body>
    </soapenv:Envelope>
    """;
    final headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': '$soapAction$methodName',
    };

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: utf8.encode(body),
      );
      log('${response.statusCode}');
      print(response.body);

      if (response.statusCode == 200) {
        final xmlResponse = response.body;
        const startTag = '<return>';
        const endTag = '</return>';
        final startIndex = xmlResponse.indexOf(startTag) + startTag.length;
        final endIndex = xmlResponse.indexOf(endTag);
        final data = xmlResponse.substring(startIndex, endIndex);
        print("data: $data");
        final str1 = encryptionProvider.getDecryptedData(data);
        log("str ${str1.stringData}");
        log("map ${str1.mapData}");
        return str1.mapData!;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getBirthdayList(
      {required int officeId,
      required String eid,
      required EncryptionProvider encryptionProvider}) async {
    final http.Client client = http.Client();
    //const String namespace = 'http://ws.fipl.com/';
    const String methodName = 'getTodayBirthDayListForMgmtandFaculty';
    const String soapAction = 'http://ws.fipl.com/';
    const String url =
        'http://115.244.251.14/evarsitywebserviceforflutter/EmployeeAndroid?wsdl';
    String userData = '';
    userData = '<breakupid>$officeId</breakupid>';
    userData += '<employeeid>$eid</employeeid>';
    userData += '<deviceid>7308f02e728e36a8</deviceid>';
    userData += '<androidversion>14</androidversion>';
    userData += '<model>SM-M336BU</model>';
    userData += '<sdkversion>30</sdkversion>';
    userData += '<appversion>V 1.0.0</appversion>';

    final encryptedUserData = encryptionProvider.getEncryptedData(userData);
    String body = """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:exam="http://ws.fipl.com/">
      <soapenv:Header/>
      <soapenv:Body>
        <exam:$methodName>
            <EncryptedData i:type="d:string">$encryptedUserData</EncryptedData>
        </exam:$methodName>
      </soapenv:Body>
    </soapenv:Envelope>
    """;
    final headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': '$soapAction$methodName',
    };

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: utf8.encode(body),
      );
      print(response.statusCode);
      //print(response.body);

      if (response.statusCode == 200) {
        final xmlResponse = response.body;
        const startTag = '<return>';
        const endTag = '</return>';
        final startIndex = xmlResponse.indexOf(startTag) + startTag.length;
        final endIndex = xmlResponse.indexOf(endTag);
        final data = xmlResponse.substring(startIndex, endIndex);
        print("data: $data");
        final str1 = encryptionProvider.getDecryptedData(data);
        print("str${str1.stringData}");
        print("map ${str1.mapData}");
        return str1.mapData!;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getStaffDetails(
      {required String eid,
      required EncryptionProvider encryptionProvider}) async {
    final http.Client client = http.Client();
    //const String namespace = 'http://ws.fipl.com/';
    const String methodName = 'getStaffLeaveDetails';
    const String soapAction = 'http://ws.fipl.com/';
    const String url =
        'http://115.244.251.14/evarsitywebserviceforflutter/EmployeeAndroid?wsdl';
    const String dashEmpId = '0';

    String userData = '';
    userData = '<dashboardemployeeid>$dashEmpId</dashboardemployeeid>';
    userData += '<employeeid>$eid</employeeid>';
    userData += '<deviceid>7308f02e728e36a8</deviceid>';
    userData += '<androidversion>14</androidversion>';
    userData += '<model>SM-M336BU</model>';
    userData += '<sdkversion>30</sdkversion>';
    userData += '<appversion>V 1.0.0</appversion>';

    final encryptedUserData = encryptionProvider.getEncryptedData(userData);
    String body = """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:exam="http://ws.fipl.com/">
      <soapenv:Header/>
      <soapenv:Body>
        <exam:$methodName>
            <EncryptedData i:type="d:string">$encryptedUserData</EncryptedData>
        </exam:$methodName>
      </soapenv:Body>
    </soapenv:Envelope>
    """;
    final headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': '$soapAction$methodName',
    };

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: utf8.encode(body),
      );
      log('${response.statusCode}');
      log(response.body);

      if (response.statusCode == 200) {
        final xmlResponse = response.body;
        const startTag = '<return>';
        const endTag = '</return>';
        final startIndex = xmlResponse.indexOf(startTag) + startTag.length;
        final endIndex = xmlResponse.indexOf(endTag);
        final data = xmlResponse.substring(startIndex, endIndex);
        print("data: $data");
        final str1 = encryptionProvider.getDecryptedData(data);
        print("str${str1.stringData}");
        print("map ${str1.mapData}");
        return str1.mapData!;
      }
    } catch (e) {
      print(e);
    }
    log('hi!!!!');
    return null;
  }
}
