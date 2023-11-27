import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:keygourd/core/commons/ui.dart';
import 'package:keygourd/core/commons/widgets/icon_text_button.dart';
import 'package:keygourd/core/models/user_key_model.dart';
import 'package:keygourd/core/res/constants/constants.dart';
import 'package:keygourd/core/utilities/app_page_route.dart';
import 'package:keygourd/core/utilities/enum.dart';
import 'package:keygourd/feature/add_user/controller/add_user_controller.dart';
import 'package:keygourd/feature/add_user/view/qr_scanner/qr_scanner_view.dart';
import 'package:keygourd/feature/authentication/widgets/pin_text_field.dart';
import 'package:provider/provider.dart';

class AddUserView extends StatefulWidget {
  const AddUserView(
      {super.key,
      required this.appPin,
      required this.keyType,
      this.userName = "",
      required this.usersKeys});

  final String appPin;
  final KeyType keyType;
  final String userName;
  final List<UserKeyModel> usersKeys;

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  late final AddUserController controller;
  final TextEditingController userNameController = TextEditingController();
  final GlobalKey<FormState> userFormKey = GlobalKey();
  late final bool isEdit;

  @override
  void initState() {
    controller = AddUserController(appPin: widget.appPin);
    userNameController.text = widget.userName;
    isEdit = widget.userName.isNotEmpty;
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      builder: (context, child) {
        return Scaffold(
          body: Padding(
            padding: kScreenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                  key: userFormKey,
                  child: PinTextField(
                    readOnly:  isEdit,
                    isObscure: false,
                    textInputType: TextInputType.name,
                    textEditingController: userNameController,
                    validator:(userName)=> controller.userNameValidator(userName,widget.usersKeys),
                  ),
                ),
                const Gap(15),
                StyledIconTextButton(
                    onPressed: _onPasteButtonTap,
                    icon: Icons.paste,
                    text: "Paste & Import"),
                StyledIconTextButton(
                    onPressed: _onQRScanButtonTap,
                    icon: Icons.qr_code_scanner,
                    text: "Scan & Import")
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onPasteButtonTap() async {
    UserKeyModel? user = await controller.onPasteFromClipboard(
        userFormKey: userFormKey,
        userName: userNameController.text.trim(),
        keyType: widget.keyType,
        usersKeys: widget.usersKeys,
        isEdit: isEdit,
        onError: (errorMessage) {
          UI.showMessage(context, message: errorMessage);
        });
    if (mounted) {
      if (user != null) {
        Navigator.pop(context, [user]);
      }
    }
  }

  Future<void> _onQRScanButtonTap() async {
    List? result = await Navigator.push(
      context,
      AppPageRoute.defaultPageRoute(
        const QRScannerView(),
      ),
    );
    UserKeyModel? addedUser = await controller.onQRScan(
        result: result,
        userFormKey: userFormKey,
        userName: userNameController.text.trim(),
        keyType: widget.keyType,
        usersKeys: widget.usersKeys,
        isEdit: isEdit,
        onError: (errorMessage) {
          UI.showMessage(context, message: errorMessage);
        });
    if (mounted) {
      if (addedUser != null) {
        Navigator.pop(context, [addedUser]);
      }
    }
  }
}
