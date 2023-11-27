import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:keygourd/core/utilities/app_page_route.dart';
import 'package:keygourd/feature/authentication/views/pin_sign_in/view/pin_sign_in_view.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  final BuildContext context;

  AppLifecycleObserver({required this.context});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        _onUnlock();
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _onUnlock() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
        context, AppPageRoute.defaultPageRoute(const PinSignInView()));
  }
}
