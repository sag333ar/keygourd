import 'package:keygourd/core/services/mobile_service.dart';

class ApiService {
  final MobileBridgedService _bridgedService = MobileBridgedService();

  Future<bool> validatePostingKey(String userName, String postingKey) async {
    String response =
        await _bridgedService.validatePostingKey(userName, postingKey);
    if (response == 'true') {
      return true;
    } else if (response == 'false') {
      return false;
    } else {
      throw (response);
    }
  }

  Future<bool> validateActiveKey(String userName, String activeKey) async {
    String response =
        await _bridgedService.validateActiveKey(userName, activeKey);
    if (response == 'true') {
      return true;
    } else if (response == 'false') {
      return false;
    } else {
      throw (response);
    }
  }

  Future<bool> validateMemoKey(String userName, String memoKey) async {
    String response = await _bridgedService.validateMemoKey(userName, memoKey);
    if (response == 'true') {
      return true;
    } else if (response == 'false') {
      return false;
    } else {
      throw (response);
    }
  }
}
