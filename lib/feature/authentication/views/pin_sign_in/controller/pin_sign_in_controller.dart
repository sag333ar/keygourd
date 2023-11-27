import 'package:flutter/material.dart';
import 'package:keygourd/core/res/storage/biometric_storage.dart';

class PinSignInController {
  final BioMetricStorage _bioMetricStorage = BioMetricStorage();

  String? pinValidator(String? pin) {
    if (pin!.isEmpty) {
      return "Pin cannot be empty.";
    } else if (pin.length < 6 || pin.length > 7) {
      return "Pin has to be only 6 characters";
    } else {
      return null;
    }
  }

  void onSubmit(
      {required GlobalKey<FormState> formKey,
      required String pin,
      required VoidCallback onsuccess,
      required Function(String message) onFailure}) async {
    if (formKey.currentState!.validate()) {
      try {
        bool isValid = await _bioMetricStorage.validatePin(pin);
        if (isValid) {
          onsuccess();
        } else {
          onFailure('Pin is not valid');
        }
      } catch (e) {
        onFailure(e.toString());
      }
    }
  }
}
