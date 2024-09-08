import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nector/model/network_request.dart';
import 'package:nector/utils/nector_utils.dart';
import 'package:nector/view/widget/info_text.dart';

class NectorCallRequestView extends StatelessWidget {
  final NectorNetworkRequest request;
  final NectorUtils _utils = NectorUtils();
  NectorCallRequestView({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          CallInfoText(
            title: 'Request at',
            description: _utils.hhMMSSAADateParse(request.time),
          ),
          CallInfoText(
            title: 'Request size',
            description: _utils.parseBytes(request.size),
          ),
          if (request.headers.isNotEmpty) ..._headers(),
          if (request.body != null && request.body != '')
            CallInfoText(
              title: 'Body',
              description: request.body is String
                  ? _utils.beautifyJson(jsonDecode(request.body))
                  : request.body is FormData
                      ? _utils.beautifyJson(_utils.formDataToJson(request.body))
                      : _utils.beautifyJson(request.body),
            ),
          if (request.queryParamters.isNotEmpty)
            CallInfoText(
              title: 'Query parameters',
              description: _utils.beautifyJson(request.queryParamters),
            )
        ],
      ),
    );
  }

  List<Widget> _headers() {
    List<Widget> headers = [];
    for (final entry in request.headers.entries) {
      headers.add(
        CallInfoText(
          title: entry.key,
          description: request.headers[entry.key],
        ),
      );
    }
    return headers;
  }
}
