import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nector/controller/nector_contoller.dart';
import 'package:nector/model/network_call.dart';
import 'package:nector/model/network_request.dart';
import 'package:nector/model/network_response.dart';

class NectorDioInterceptor extends Interceptor {
  final NectorController _controller;
  NectorDioInterceptor(this._controller);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final call = NectorNetworkCall(options.hashCode);

    final uri = options.uri;
    call.method = options.method;
    var path = uri.path;
    if (path.isEmpty) path = '/';
    call
      ..endpoint = path
      ..server = uri.host
      ..client = 'Dio'
      ..uri = uri.toString();

    final request = NectorNetworkRequest();

    final dynamic data = options.data;
    if (data == null) {
      request
        ..size = 0
        ..body = '';
    } else {
      request
        ..size = utf8.encode(data.toString()).length
        ..body = data;
    }

    request
      ..time = DateTime.now()
      ..headers = options.headers
      ..contentType = options.contentType.toString()
      ..queryParamters = options.queryParameters;

    call
      ..networkRequest = request
      ..networkResponse = NectorNetworkResponse();

    _controller.addNetworkCall(call);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final networkResponse = NectorNetworkResponse()
      ..statusCode = response.statusCode;

    if (response.data == null) {
      networkResponse
        ..body = ''
        ..size = 0;
    } else {
      networkResponse
        ..body = response.data
        ..size = utf8.encode(response.data.toString()).length;
    }
    networkResponse.time = DateTime.now();
    final headers = <String, String>{};
    response.headers.forEach((header, values) {
      headers[header] = values.toString();
    });
    networkResponse.headers = headers;
    _controller.addResponse(networkResponse, response.requestOptions.hashCode);
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // final networkError = NectorNetworkError()..error = err.toString();
    // if (err is Error) {
    //   final error = err as Error;
    //   networkError.stackTrace = error.stackTrace;
    // }
    // _controller.addError(networkError, err.requestOptions.hashCode);
    // final networkResponse = NectorNetworkResponse()..time = DateTime.now();
    // if (err.response == null) {
    //   networkResponse.statusCode = -1;
    //   _controller.addResponse(networkResponse, err.requestOptions.hashCode);
    // } else {
    //   networkResponse.statusCode = err.response!.statusCode;
    //   if (err.response!.data == null) {
    //     networkResponse
    //       ..body = ''
    //       ..size = 0;
    //   } else {
    //     networkResponse
    //       ..body = err.response!.data
    //       ..size = utf8.encode(err.response!.data.toString()).length;
    //   }
    // }
    // final headers = <String, String>{};
    // err.response!.headers.forEach((header, values) {
    //   headers[header] = values.toString();
    // });
    // networkResponse.headers = headers;
    // _controller.addResponse(
    //   networkResponse,
    //   err.response!.requestOptions.hashCode,
    // );
    // handler.next(err);
    super.onError(err, handler);
  }
}
