import 'package:flutter/services.dart';

class NectorMethodChannel {
  static const channelName = 'nector';
  MethodChannel? methodChannel;

  static final NectorMethodChannel instance = NectorMethodChannel._init();

  NectorMethodChannel._init();

  void configureChannel() {
    methodChannel = MethodChannel(channelName);
    methodChannel!.setMethodCallHandler(this.methodHandler);
  }

  Future<void> methodHandler(MethodCall call) {
    switch (call.method) {
      case "notificationClicked":
        break;
      default:
        print('no method handler for method ${call.method}');
    }
    return Future.value();
  }
}
