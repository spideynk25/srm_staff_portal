import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:srm_staff_portal/encryption_provider.dart';


class Baseurl {
  Future<DecryptedData?> baseUrl(String userData, String methodName,
      EncryptionProvider encryptionProvider) async {
    final http.Client client = http.Client();
    const String soapAction = 'http://ws.fipl.com/';
    const String url =
        'http://115.244.251.14/evarsitywebserviceforflutter/EmployeeAndroid?wsdl';
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
      log("${response.statusCode}");
      log(response.body);

      if (response.statusCode == 200) {
        final xmlResponse = response.body;
        const startTag = '<return>';
        const endTag = '</return>';
        final startIndex = xmlResponse.indexOf(startTag) + startTag.length;
        final endIndex = xmlResponse.indexOf(endTag);
        final data = xmlResponse.substring(startIndex, endIndex);
        log("data: $data");
        final str1 = encryptionProvider.getDecryptedData(data);
        log("str${str1.stringData}");
        log("map ${str1.mapData}");
        return str1;
      }
    } catch (e) {
      log("$e");
    }
    return null;
  }
}
