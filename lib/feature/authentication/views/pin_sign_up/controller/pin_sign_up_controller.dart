import 'package:flutter/material.dart';
import 'package:keygourd/core/storage/biometric_storage.dart';

class PinSignUpController {
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

  String? confirmPinValidator(String pin, String confirmPin) {
    if (pin.isEmpty) {
      return "Pin cannot be empty.";
    } else if (pin.length < 6 || pin.length > 7) {
      return "Pin has to be only 6 characters";
    } else if (pin != confirmPin) {
      return "Pins dont match";
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
        await _bioMetricStorage.setSecurePin(pin);
        onsuccess();
      } catch (e) {
        onFailure(e.toString());
      }
    }
  }
}
