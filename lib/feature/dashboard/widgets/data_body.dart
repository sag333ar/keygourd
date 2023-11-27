import 'package:flutter/material.dart';
import 'package:keygourd/core/models/user_key_model.dart';
import 'package:keygourd/core/utilities/enum.dart';
import 'package:keygourd/feature/dashboard/controller/dashboard_controller.dart';
import 'package:keygourd/feature/dashboard/widgets/drop_down_menu.dart';
import 'package:keygourd/feature/dashboard/widgets/key_item.dart';
import 'package:provider/provider.dart';

class DashBoardDataBody extends StatelessWidget {
  const DashBoardDataBody({
    super.key,
    required this.controller,
  });

  final DashBoardController controller;

  @override
  Widget build(BuildContext context) {
    return Selector<DashBoardController, UserKeyModel>(
        selector: (_, myType) => myType.selectedUserKeyModel,
        builder: (context, selectedUser, child) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Selector<DashBoardController, int>(
                selector: (_, myType) => myType.listOfUsersKeys.length,
                builder: (context, users, child) {
                  return UsersDropDownButton(
                      selectedItem: selectedUser,
                      items: controller.listOfUsersKeys,
                      hintText: 'hintText',
                      onChanged: (value) {
                        controller.changeSelectedUser(value);
                      });
                },
              ),
              Expanded(
                  child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                children: [
                  KeyItem(
                    userKeyModel: selectedUser,
                    text: 'Posting Key',
                    keyValue: selectedUser.posting,
                    keyType: KeyType.posting,
                  ),
                  KeyItem(
                    userKeyModel: selectedUser,
                    text: 'Active Key',
                    keyValue: selectedUser.active,
                    keyType: KeyType.active,
                  ),
                  KeyItem(
                    userKeyModel: selectedUser,
                    text: 'Memo Key',
                    keyValue: selectedUser.memo,
                    keyType: KeyType.memo,
                  ),
                ],
              )),
            ],
          );
        });
  }
}
