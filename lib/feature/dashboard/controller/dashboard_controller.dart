import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:keygourd/core/models/user_key_model.dart';
import 'package:keygourd/core/res/storage/user_key_storage.dart';
import 'package:keygourd/core/utilities/enum.dart';

class DashBoardController extends ChangeNotifier {
  final UserKeyStorage userKeyStorage = const UserKeyStorage();
  ViewState viewState = ViewState.loading;
  List<UserKeyModel> listOfUsersKeys = [];
  late UserKeyModel selectedUserKeyModel;

  final String appPin;

  DashBoardController({required this.appPin}) {
    _init();
  }

  void _init() async {
    try {
      listOfUsersKeys = await userKeyStorage.getKeys(appPin);
      if (listOfUsersKeys.isEmpty) {
        viewState = ViewState.empty;
      } else {
        viewState = ViewState.data;
        selectedUserKeyModel = listOfUsersKeys.first;
      }
      notifyListeners();
    } catch (e) {
      log(e.toString());
      viewState = ViewState.error;
      notifyListeners();
    }
  }

  void changeSelectedUser(UserKeyModel userKeyModel) {
    if (selectedUserKeyModel != userKeyModel) {
      selectedUserKeyModel = userKeyModel;
      notifyListeners();
    }
  }

  void addUser(UserKeyModel userKeyModel) {
    if (viewState != ViewState.data) {
      viewState = ViewState.data;
    }
      selectedUserKeyModel = userKeyModel;
    notifyListeners();
  }

  void editUser(UserKeyModel userKeyModel) {
    selectedUserKeyModel = userKeyModel;
    notifyListeners();
  }

  void deleteUserKey(UserKeyModel userKey, KeyType keyType) async {
    int index =
        listOfUsersKeys.indexWhere((element) => element.name == userKey.name);
    userKey = UserKeyModel(
        name: userKey.name,
        posting: keyType != KeyType.posting ? userKey.posting : null,
        memo: keyType != KeyType.memo ? userKey.memo : null,
        active: keyType != KeyType.active ? userKey.active : null);
    if (userKey.active != null ||
        userKey.memo != null ||
        userKey.posting != null) {
      listOfUsersKeys[index] = userKey;
      selectedUserKeyModel = userKey;
    } else {
      listOfUsersKeys.removeWhere((element) => element.name == userKey.name);
      if (listOfUsersKeys.isNotEmpty) {
        selectedUserKeyModel = listOfUsersKeys.last;
      } else {
        viewState = ViewState.empty;
      }
    }
    await userKeyStorage.updateKeys(listOfUsersKeys, appPin);
    notifyListeners();
  }
}
