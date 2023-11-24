import 'package:flutter/material.dart';
import 'package:keygourd/core/commons/widgets/text_button.dart';
import 'package:keygourd/feature/splash_screen/splash_screen.dart';

class SetBioMetricsView extends StatelessWidget {
  const SetBioMetricsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15),
        child: Column(
          children: [
            const Text(
                "Bio metrics is not set in your device, Please set it up and try again"),
            const SizedBox(
              height: 15,
            ),
            StyledTextButton(
              text: 'Try Again',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SplashView(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
