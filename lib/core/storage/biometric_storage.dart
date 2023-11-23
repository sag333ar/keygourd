import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BioMetricStorage {
  final String _appPin = 'app_pin';
  final String _doWeHaveSecurePin = 'do_we_have_secure_pin';
  final _storage = const FlutterSecureStorage();

  BioMetricStorage._privateConstructor();

  static final BioMetricStorage _instance =
      BioMetricStorage._privateConstructor();

  factory BioMetricStorage() {
    return _instance;
  }

  Future<bool> doesUserHasBioMetricsSetInTheDevice() async {
    final response = await MethodChannelBiometricStorage().canAuthenticate();
    if (response != CanAuthenticateResponse.success) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> doWeHaveSecurePinStored() async {
    String value = await _storage.read(key: _doWeHaveSecurePin) ?? "";
    return value == "true";
  }

  Future<bool> validatePin(String value) async {
    try {
      final pinFile = await MethodChannelBiometricStorage().getStorage(_appPin);
      final pinValue = await pinFile.read(promptInfo: const PromptInfo());
      if (pinValue == null) {
        return false;
      }
      return pinValue == value;
    } on AuthException catch (e) {
      throw (e.message);
    } catch (exception) {
      if (exception
          .toString()
          .contains("Storage was not initialized $_appPin")) {
        return false;
      } else {
        rethrow;
      }
    }
  }

  Future<void> setSecurePin(String value) async {
    try {
      final BiometricStorageFile bioMetricStorageFile =
          await MethodChannelBiometricStorage().getStorage(_appPin);
      await bioMetricStorageFile.write(value, promptInfo: const PromptInfo());
      await _storage.write(key: _doWeHaveSecurePin, value: 'true');
    } on AuthException catch (e) {
      throw (e.message);
    } catch (e) {
      rethrow;
    }
  }
}
