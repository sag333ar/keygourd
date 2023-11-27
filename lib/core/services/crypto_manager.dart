import 'dart:convert';
import 'dart:developer';
import "package:encrypt/encrypt.dart";

class CryptoManager {
  const CryptoManager();

  String getEncryptedData({required String pin, required String value}) {
    String myKey = _makeKeyFromPin(pin);
    final key = Key.fromUtf8(myKey);
    final iv = IV.fromUtf8(utf8.decode('xfpkDQJXIfb3mcnb'.codeUnits));
    final encrypter = Encrypter(AES(key,padding: null));
    final encrypted = encrypter.encrypt(value, iv: iv);
    log(encrypted.base64);
    return encrypted.base64;
  }

  String getDecryptedData({required String pin, required String value}) {
    String myKey = _makeKeyFromPin(pin);
    final key = Key.fromUtf8(myKey);
    final iv = IV.fromUtf8(utf8.decode('xfpkDQJXIfb3mcnb'.codeUnits));
    final encrypter = Encrypter(AES(key,padding: null));
    final decrypted = encrypter.decrypt(Encrypted.from64(value), iv: iv);
    log(decrypted);
    return decrypted;
  }

  String _makeKeyFromPin(String key) {
    String pin = key;
    key = pin;
    if (pin.length < 32) {
      int dif = 32 - pin.length;
      key = pin;
      for (int i = 0; i < dif; i++) {
        key += key[i];
      }
    }
    return key;
  }
}
