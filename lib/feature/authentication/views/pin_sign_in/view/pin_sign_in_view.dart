import 'dart:async';

import 'package:flutter/material.dart';
import 'package:keygourd/core/commons/ui.dart';
import 'package:keygourd/core/commons/widgets/text_button.dart';
import 'package:keygourd/core/utilities/app_page_route.dart';
import 'package:keygourd/core/utilities/app_routes.dart';
import 'package:keygourd/feature/authentication/views/pin_sign_in/controller/pin_sign_in_controller.dart';
import 'package:keygourd/feature/authentication/widgets/pin_text_field.dart';
import 'package:keygourd/feature/dashboard/dashboard_view.dart';

class PinSignInView extends StatefulWidget {
  const PinSignInView({super.key});

  @override
  State<PinSignInView> createState() => _PinSignInViewState();
}

class _PinSignInViewState extends State<PinSignInView> {
  final PinSignInController controller = PinSignInController();
  final TextEditingController pinController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  Timer submitOnStoppedTyping = Timer(const Duration(milliseconds: 1), () {});

  @override
  void dispose() {
    pinController.dispose();
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
                  child: PinTextField(
                    textEditingController: pinController,
                    validator: controller.pinValidator,
                    onChanged: (value) {
                      const duration = Duration(milliseconds: 350);
                      submitOnStoppedTyping.cancel();
                      submitOnStoppedTyping = Timer(duration, () {
                        if (value.length == 6) {
                          _onSubmit();
                        }
                      });
                    },
                  )),
              StyledTextButton(
                text: 'Submit',
                onPressed: _onSubmit,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    return controller.onSubmit(
      formKey: formKey,
      pin: pinController.text.trim(),
      onsuccess: () {
        _pushToDashboard(context);
      },
      onFailure: (errorMessage) {
        UI.showMessage(context, message: errorMessage);
      },
    );
  }

  void _pushToDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      AppPageRoute.defaultPageRoute(
          DashBoardView(
            appPin: pinController.text.trim(),
          ),
          routeName: AppRoutes.dashboardView),
    );
  }
}
