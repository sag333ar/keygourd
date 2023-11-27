import 'package:flutter/services.dart';

class MobileBridgedService {
  final String channel = "app.keygourd/bridge";
  late final MethodChannel platform;

  MobileBridgedService() {
    platform = MethodChannel(channel);
  }

  Future<String> validatePostingKey(String userName, String postingKey) async {
    final String chainPropId =
        'validatePostingKey_${DateTime.now().toIso8601String()}';
    final String response = await platform.invokeMethod('validatePostingKey',
        {'id': chainPropId, 'accountName': userName, 'postingKey': postingKey});
    return response;
  }

  Future<String> validateActiveKey(String userName, String activeKey) async {
    final String chainPropId =
        'validateActiveKey_${DateTime.now().toIso8601String()}';
    final String response = await platform.invokeMethod('validateActiveKey',
        {'id': chainPropId, 'accountName': userName, 'activeKey': activeKey});
    return response;
  }

  Future<String> validateMemoKey(String userName, String memoKey) async {
    final String chainPropId =
        'validateMemoKey_${DateTime.now().toIso8601String()}';
    final String response = await platform.invokeMethod('validateMemoKey',
        {'id': chainPropId, 'accountName': userName, 'memoKey': memoKey});
    return response;
  }
}
