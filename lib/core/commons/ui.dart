import 'package:flutter/material.dart';

class UI {
  static void showMessage(
    BuildContext context, {
    required String message,
  }) async {
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
