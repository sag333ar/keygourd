import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppPageRoute {

  static Route<T> defaultPageRoute<T>(Widget widget,
      {String? routeName}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => widget,
    );
  }

  static Route<T> cupertionoPageRoute<T>(Widget widget,
      {String? routeName}) {
    return CupertinoPageRoute(
        settings: RouteSettings(name: routeName), builder: (context) => widget);
  }
}
