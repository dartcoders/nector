import 'package:flutter/material.dart';
import 'package:nector/model/network_response.dart';
import 'package:nector/utils/nector_utils.dart';
import 'package:nector/view/widget/info_text.dart';

class NectorCallResponseView extends StatelessWidget {
  final NectorNetworkResponse response;
  final NectorUtils _utils = NectorUtils();
  NectorCallResponseView({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          CallInfoText(
            title: 'Response at',
            description: _utils.hhMMSSAADateParse(response.time),
          ),
          CallInfoText(
            title: 'Response size',
            description: _utils.parseBytes(response.size),
          ),
          CallInfoText(
            title: 'Status code',
            description: response.statusCode.toString(),
          ),
          CallInfoText(
            title: 'Body',
            description: _utils.beautifyJson(response.body),
          ),
        ],
      ),
    );
  }
}
