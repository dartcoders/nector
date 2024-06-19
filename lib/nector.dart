import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nector/controller/nector_contoller.dart';
import 'package:nector/controller/nector_dio_interceptor.dart';

export 'nector.dart';

class Nector {
  /// Instance of the nector logic bloc
  late NectorController _controller;

  /// Instance of dio interceptor
  late NectorDioInterceptor _interceptor;

  Nector({
    required GlobalKey<NavigatorState> navigatorKey,
    bool showNotification = true,
    String appName = '',
  }) {
    _controller = NectorController(
      showNotification: showNotification,
      navigatorKey: navigatorKey,
      appName: appName,
    );
    _interceptor = NectorDioInterceptor(_controller);
  }

  /// This should be used to get the instance of dio interceptor
  /// which can be applied to dio instance
  NectorDioInterceptor getDioInterceptor() {
    return _interceptor;
  }

  /// Add this to the onRequest override of your existing interceptor
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return _interceptor.onRequest(options, handler, skipNext: true);
  }

  /// Add this to the onResponse override of your existing interceptor
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    return _interceptor.onResponse(response, handler, skipNext: true);
  }

  /// Add this to the onError override of your existing interceptor
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return _interceptor.onError(err, handler, skipNext: true);
  }

  /// Navigates to API call inspector where all the network calls will be listed.
  void showInspector() {
    _controller.navigateToInspector();
  }
}
