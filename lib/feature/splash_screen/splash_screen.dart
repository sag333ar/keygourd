import 'package:flutter/material.dart';
import 'package:keygourd/core/utilities/app_page_route.dart';
import 'package:keygourd/feature/authentication/views/pin_sign_in/view/pin_sign_in_view.dart';
import 'package:keygourd/feature/authentication/views/pin_sign_up/view/pin_sign_up_view.dart';
import 'package:keygourd/feature/authentication/views/set_bio_metric_view.dart';
import 'package:keygourd/feature/splash_screen/controller/splash_view_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    SplashViewController controller = SplashViewController();
    bool doesUserHasBioMetricsSetInTheDevice =
        await controller.doesUserHasBioMetricsSetInTheDevice();
    if (doesUserHasBioMetricsSetInTheDevice) {
      bool doWeHaveSecurePinStored =
          await controller.doWeHaveSecurePinStored();
      if (doWeHaveSecurePinStored) {
        _pushToScreen(const PinSignInView());
      } else {
        _pushToScreen(const PinSignUpView());
      }
    } else {
      _pushToScreen(const SetBioMetricsView());
    }
  }

  void _pushToScreen(Widget screen) {
    Navigator.of(context).pushReplacement(
      AppPageRoute.defaultPageRoute(screen)
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
