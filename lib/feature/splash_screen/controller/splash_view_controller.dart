import 'package:keygourd/core/storage/biometric_storage.dart';

class SplashViewController {
  final BioMetricStorage _bioMetricStorage = BioMetricStorage();

  Future<bool> doesUserHasBioMetricsSetInTheDevice() async {
    return await _bioMetricStorage.doesUserHasBioMetricsSetInTheDevice();
  }

  Future<bool> doWeHaveSecurePinStored() async {
    return await _bioMetricStorage.doWeHaveSecurePinStored();
  }
}
