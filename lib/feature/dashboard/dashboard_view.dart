import 'package:flutter/material.dart';
import 'package:keygourd/core/commons/widgets/text_button.dart';
import 'package:keygourd/feature/authentication/views/pin_sign_in/view/pin_sign_in_view.dart';

class DashBoardView extends StatelessWidget {
  const DashBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StyledTextButton(
          text: "To Unlock screen",
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const PinSignInView()));
          },
        ),
      ),
    );
  }
}
