import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nector/nector.dart';

void main() {
  runApp(const NectorExample());
}

class NectorExample extends StatefulWidget {
  const NectorExample({super.key});

  @override
  State<NectorExample> createState() => _NectorExampleState();
}

class _NectorExampleState extends State<NectorExample> {
  late Dio _dio;
  late Nector _nector;
  final GlobalKey<NavigatorState> _mainNavigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _dio = Dio(BaseOptions());
    _nector = Nector(navigatorKey: _mainNavigatorKey);
    _dio.interceptors.add(_nector.getDioInterceptor());

    /// Or if you are using queued interceptors you can add the
    /// interceptors respectively at onRequest, onResponse, onError
    
    // _dio.interceptors.add(QueuedInterceptorsWrapper(
    //   onRequest: (options, handler) => _nector.onRequest(options, handler),
    //   onResponse: (options, handler) => _nector.onResponse(options, handler),
    //   onError: (options, handler) => _nector.onError(options, handler),
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp();
  }
}
