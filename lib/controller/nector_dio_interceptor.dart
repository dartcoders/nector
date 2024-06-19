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
  void onRequest(RequestOptions options, RequestInterceptorHandler handler,
      {bool skipNext = false}) {
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
    if (!skipNext) handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler,
      {bool skipNext = false}) {
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
    if (!skipNext) handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler,
      {bool skipNext = false}) {
    final networkResponse = NectorNetworkResponse()..time = DateTime.now();
    if (err.response == null) {
      networkResponse.statusCode = -1;
      _controller.addResponse(networkResponse, err.requestOptions.hashCode);
    } else {
      networkResponse.statusCode = err.response!.statusCode;
      if (err.response!.data == null) {
        networkResponse
          ..body = ''
          ..size = 0;
      } else {
        networkResponse
          ..body = err.response!.data
          ..size = utf8.encode(err.response!.data.toString()).length;
      }
    }
    final headers = <String, String>{};
    err.response!.headers.forEach((header, values) {
      headers[header] = values.toString();
    });
    networkResponse.headers = headers;
    _controller.addResponse(
      networkResponse,
      err.response!.requestOptions.hashCode,
    );
    if (!skipNext) handler.next(err);
  }
}
