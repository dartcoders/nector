import 'package:flutter/material.dart';
import 'package:nector/controller/nector_contoller.dart';
import 'package:nector/controller/nector_dio_interceptor.dart';

export 'nector.dart';

class Nector {
  /// Whether you want to see the notification when a new http call happens.
  bool _showNotification = true;

  /// Instance of the nector logic bloc
  late NectorController _controller;

  Nector({
    required GlobalKey<NavigatorState> navigatorKey,
    bool showNotification = true,
    String appName = '',
  }) {
    _showNotification = showNotification;
    _controller = NectorController(
      showNotification: _showNotification,
      navigatorKey: navigatorKey,
      appName: appName,
    );
  }

  /// This should be used to get the instance of dio interceptor
  /// which can be applied to dio instance
  NectorDioInterceptor getDioInterceptor() {
    return NectorDioInterceptor(_controller);
  }

  /// Navigates to API call inspector where all the network calls will be listed.
  void showInspector() {
    _controller.navigateToInspector();
  }
}
