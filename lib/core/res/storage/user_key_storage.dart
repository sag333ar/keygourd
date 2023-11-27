import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keygourd/core/services/crypto_manager.dart';
import 'package:keygourd/core/models/user_key_model.dart';

class UserKeyStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final CryptoManager _cryptoManager = const CryptoManager();
  final String _appKeys = 'app_keys';

  const UserKeyStorage();

  Future<List<UserKeyModel>> getKeys(String pin) async {
    String value = await _secureStorage.read(key: _appKeys) ?? "";
    if (value.isEmpty) {
      return [];
    }
    try {
      var decrypted = _cryptoManager.getDecryptedData(pin: pin, value: value);
      return UserKeyModel.fromRawJson(decrypted);
    } catch (e) {
      return [];
    }
  }

  Future<void> updateKeys(List<UserKeyModel> userKeyModel, String pin) async {
    String encodedUsersKeys = json.encode(userKeyModel);
     String encryptedUserskeys =
        _cryptoManager.getEncryptedData(pin: pin, value: encodedUsersKeys);
    await _secureStorage.write(key: _appKeys, value: encryptedUserskeys);
  }
}
