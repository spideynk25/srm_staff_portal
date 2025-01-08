import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hex/hex.dart';
import 'package:srm_staff_portal/encryption_state.dart';



class EncryptionProvider extends StateNotifier<EncryptionState> {
  EncryptionProvider() : super(const EncryptionInitial());

  void disposeState() => state = const EncryptionInitial();

  String getEncryptedData(String stringToEncrypt) {
    var strEncryptedData = '';
    try {
      setKey(state.strPrivateKey, state.strPrivateIV);
      // log('length1 ${state.strPrivateKey.length}');
      // log('length2 ${state.strPrivateIV.length}');
      // log('length3 ${state.strCommonKey.length}');
      // log('length4 ${state.strCommonIV.length}');
      final strData = encrypt(stringToEncrypt);
      setKey(state.strCommonKey, state.strCommonIV);
      strEncryptedData = encrypt(strData);
    } catch (e) {
      log('$e');
    }
    return strEncryptedData;
  }

 

  DecryptedData getDecryptedData(String stringToDecrypt) {
    var strDecryptedData = '';
    Map<String, dynamic>? mapData;
    String? stringData;

    try {
      setKey(state.strCommonKey, state.strCommonIV);
      final strDecryptedMData = decrypt(stringToDecrypt);

      setKey(state.strPrivateKey, state.strPrivateIV);
      strDecryptedData = decrypt(strDecryptedMData);
    } catch (e) {
      log('$e');
    }

    try {
      mapData = json.decode(strDecryptedData) as Map<String, dynamic>;
    } catch (e) {
      stringData = strDecryptedData;
    }

    return DecryptedData(mapData: mapData, stringData: stringData);
  }

  bool setKey(String keyString, String ivString) {
    if (keyString.length != 32) {
      return false;
    }
    if (ivString.length != 16) {
      return false;
    }
    state = state.copyWith(
      keyString: keyString,
      ivString: ivString,
    );

    return true;
  }

  String encrypt(String stplaintxt) {
    final key = Key(const Utf8Encoder().convert(state.keyString));
    final iv = IV(const Utf8Encoder().convert(state.ivString));

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(stplaintxt, iv: iv);

    return HEX.encode(encrypted.bytes).toUpperCase();
  }

  String decrypt(String stEncTxt) {
    final key = Key(const Utf8Encoder().convert(state.keyString));
    final iv = IV(const Utf8Encoder().convert(state.ivString));

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = Encrypted(hexToBytes(stEncTxt));

    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    return decrypted;
  }
}

Uint8List hexToBytes(String text) {
  final length = text.length;
  final data = Uint8List(length ~/ 2);

  for (var i = 0; i < length; i += 2) {
    final high = int.parse(text[i], radix: 16) << 4;
    final low = int.parse(text[i + 1], radix: 16);
    data[i ~/ 2] = (high + low).toUnsigned(8);
  }

  return data;
}

class DecryptedData {
  DecryptedData({this.mapData, this.stringData});
  final Map<String, dynamic>? mapData;
  final String? stringData;
}
