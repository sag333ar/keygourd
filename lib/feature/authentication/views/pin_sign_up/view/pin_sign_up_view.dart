import 'package:flutter/material.dart';
import 'package:keygourd/core/commons/ui.dart';
import 'package:keygourd/core/commons/widgets/text_button.dart';
import 'package:keygourd/feature/authentication/views/pin_sign_up/controller/pin_sign_up_controller.dart';
import 'package:keygourd/feature/authentication/widgets/pin_text_field.dart';
import 'package:keygourd/feature/dashboard/dashboard_view.dart';

class PinSignUpView extends StatefulWidget {
  const PinSignUpView({super.key});

  @override
  State<PinSignUpView> createState() => _PinSignUpViewState();
}

class _PinSignUpViewState extends State<PinSignUpView> {
  final PinSignUpController controller = PinSignUpController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void dispose() {
    pinController.dispose();
    confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          child: Column(
            children: [
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      PinTextField(
                        textEditingController: pinController,
                        validator: controller.pinValidator,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      PinTextField(
                        textEditingController: confirmPinController,
                        validator: (value) {
                          return controller.confirmPinValidator(
                              pinController.text.trim(),
                              confirmPinController.text.trim());
                        },
                      ),
                    ],
                  )),
              StyledTextButton(
                text: 'Submit',
                onPressed: () {
                  controller.onSubmit(
                    formKey: formKey,
                    pin: pinController.text.trim(),
                    onsuccess: () {
                      _pushToDashboard(context);
                    },
                    onFailure: (errorMessage) {
                      UI.showMessage(context, message: errorMessage);
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _pushToDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashBoardView(),
      ),
    );
  }
}
