import 'dart:convert';

import 'package:flutter/foundation.dart';

class NectorUtils {
  static void log(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  String hhMMSSAADateParse(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  String parseBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    }
  }

  String parseMilliseconds(int ms) {
    if (ms < 1000) {
      return '$ms ms';
    }
    return '${(ms / 1000).toStringAsFixed(2)} s';
  }

  String createCurlCommand(String url, String method,
      {String? body,
      Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParams}) {
    final curl = StringBuffer('curl');
    curl.write(' -X "$method" ');
    curl.write(url);

    /// Add headers to cURL
    if (headers != null && headers.isNotEmpty) {
      for (final entry in headers.entries) {
        curl.write(' -H "${entry.key}: ${entry.value.toString()}"');
      }
    }

    /// Add query params to cURL
    if (queryParams != null && queryParams.isNotEmpty) {
      final params = queryParams.entries
          .map((entry) => '${entry.key}=${entry.value.toString()}')
          .join('&');
      curl.write(' -G "$params"');
    }

    /// Add body to cURL
    if (body != null && body.isNotEmpty) {
      curl.write(' -d "${jsonEncode(body)}"');
    }

    return curl.toString();
  }

  String beautifyJson(Map<String, dynamic> jsonObject) {
    if (tryEncode(jsonObject) == null) return jsonObject.toString();
    var encoder = const JsonEncoder.withIndent(" ");
    return encoder.convert(jsonObject);
  }

  String? tryEncode(Map<String, dynamic> data) {
    try {
      return jsonEncode(data);
    } catch (e) {
      return null;
    }
  }
}
