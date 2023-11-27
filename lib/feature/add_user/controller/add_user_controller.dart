import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keygourd/core/models/user_key_model.dart';
import 'package:keygourd/core/res/storage/user_key_storage.dart';
import 'package:keygourd/core/services/api_service.dart';
import 'package:keygourd/core/utilities/enum.dart';

class AddUserController extends ChangeNotifier {
  final UserKeyStorage _userKeyStorage = const UserKeyStorage();
  final ApiService _apiService = ApiService();
  final String appPin;

  AddUserController({required this.appPin});

  String? userNameValidator(String? userName, List<UserKeyModel> userKeys) {
    if (userName!.isEmpty) {
      return "Username cannot be empty.";
    } else if (userKeys.indexWhere((element) => element.name == userName) !=
        -1) {
      return "Username already present";
    } else {
      return null;
    }
  }

  Future<UserKeyModel?> onQRScan(
      {required List? result,
      required Function(String error) onError,
      required String userName,
      required KeyType keyType,
      required bool isEdit,
      required List<UserKeyModel> usersKeys,
      required GlobalKey<FormState> userFormKey}) async {
    try {
      if (result != null) {
        if ((isEdit || userFormKey.currentState!.validate()) &&
            result.isNotEmpty &&
            result[0].isNotEmpty) {
          String key = result[0];
          final bool isValid = await _validateKey(keyType, userName, key);
          if (isValid) {
            if (!isEdit) {
              return await _onAdd(userName, key, usersKeys);
            } else {
              return await _onEdit(userName, key, usersKeys, keyType);
            }
          } else {
            onError('Invalid Key');
          }
        } else {
          onError('Posting key is empty');
        }
      } else {
        onError('No key found');
      }
    } on PlatformException {
      onError('Enable permission to paste data');
    } catch (e) {
      onError(e.toString());
    }
    return null;
  }

  Future<UserKeyModel?> onPasteFromClipboard(
      {required Function(String error) onError,
      required String userName,
      required KeyType keyType,
      required bool isEdit,
      required List<UserKeyModel> usersKeys,
      required GlobalKey<FormState> userFormKey}) async {
    try {
      ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
      String pastedText =
          cdata != null && cdata.text != null ? cdata.text! : "";
      String key = pastedText;
      if (isEdit || userFormKey.currentState!.validate()) {
        if (key.isNotEmpty) {
          final bool isValid = await _validateKey(keyType, userName, key);
          if (isValid) {
            if (!isEdit) {
              return await _onAdd(userName, key, usersKeys);
            } else {
              return await _onEdit(userName, key, usersKeys, keyType);
            }
          } else {
            onError("Invalid Key");
          }
        } else {
          onError('Key cannot be empty');
        }
      }
    } on PlatformException {
      onError('Enable permission to paste data');
    } catch (e) {
      onError(e.toString());
    }
    return null;
  }

  Future<UserKeyModel> _onAdd(
    String userName,
    String key,
    List<UserKeyModel> usersKeysModels,
  ) async {
    UserKeyModel userKeyModel = UserKeyModel(name: userName, posting: key);
    usersKeysModels.add(userKeyModel);
    await _userKeyStorage.updateKeys(usersKeysModels, appPin);
    return userKeyModel;
  }

  Future<UserKeyModel> _onEdit(String userName, String key,
      List<UserKeyModel> usersKeys, KeyType keyType) async {
    int index = usersKeys.indexWhere((element) => element.name == userName);
    UserKeyModel updatedUserKey = usersKeys[index].copyWith(
      posting: keyType == KeyType.posting ? key : null,
      active: keyType == KeyType.active ? key : null,
      memo: keyType == KeyType.memo ? key : null,
    );
    usersKeys[index] = updatedUserKey;
    await _userKeyStorage.updateKeys(usersKeys, appPin);
    return updatedUserKey;
  }

  Future<bool> _validateKey(
      KeyType keyType, String userName, String key) async {
    if (keyType == KeyType.posting) {
      return await _apiService.validatePostingKey(userName, key);
    } else if (keyType == KeyType.active) {
      return await _apiService.validateActiveKey(userName, key);
    } else if (keyType == KeyType.memo) {
      return await _apiService.validateMemoKey(userName, key);
    } else {
      return false;
    }
  }
}
