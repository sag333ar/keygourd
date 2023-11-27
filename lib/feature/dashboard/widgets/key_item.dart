import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keygourd/core/commons/ui.dart';
import 'package:keygourd/core/models/user_key_model.dart';
import 'package:keygourd/core/utilities/app_page_route.dart';
import 'package:keygourd/core/utilities/enum.dart';
import 'package:keygourd/feature/add_user/view/add_user_view.dart';
import 'package:keygourd/feature/dashboard/controller/dashboard_controller.dart';
import 'package:provider/provider.dart';

class KeyItem extends StatelessWidget {
  const KeyItem({
    super.key,
    required this.text,
    this.keyValue,
    required this.keyType,
    required this.userKeyModel,
  });

  final String text;
  final String? keyValue;
  final KeyType keyType;
  final UserKeyModel userKeyModel;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DashBoardController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        Row(
          children: [
            Visibility(
              visible: keyValue != null,
              child: IconButton(
                onPressed: () => _onCopy(context),
                icon: const Icon(Icons.copy),
              ),
            ),
            Visibility(
              visible: keyValue != null,
              child: IconButton(
                onPressed: () => _onDelete(context, controller, userKeyModel),
                icon: const Icon(Icons.delete),
              ),
            ),
            Visibility(
              visible: keyValue == null,
              child: IconButton(
                onPressed: () => _onAdd(context, controller),
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onAdd(BuildContext context, DashBoardController controller) async {
    List? result = await Navigator.push(
      context,
      AppPageRoute.defaultPageRoute(
        AddUserView(
          appPin: controller.appPin,
          keyType: keyType,
          userName: userKeyModel.name,
          usersKeys: controller.listOfUsersKeys,
        ),
      ),
    );
    if (result != null) {
      controller.editUser(result.first);
    }
  }

  void _onDelete(BuildContext context, DashBoardController controller,
      UserKeyModel userKeyModel) async {
    controller.deleteUserKey(userKeyModel, keyType);
  }

  void _onCopy(BuildContext context) async {
    if (keyValue != null) {
      Clipboard.setData(ClipboardData(text: keyValue!))
          .then((value) => UI.showMessage(context, message: "$_copyKeyMessage copied To Clipboard"));
    }
  }

  String get _copyKeyMessage {
    if (keyType == KeyType.posting) {
      return 'Posting key';
    } else if (keyType == KeyType.active) {
      return 'Active key';
    } else {
      return 'Memo key';
    }
  }
}
