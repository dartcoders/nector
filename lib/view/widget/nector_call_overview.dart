import 'package:flutter/material.dart';
import 'package:nector/model/network_call.dart';
import 'package:nector/utils/nector_utils.dart';
import 'package:nector/view/widget/info_text.dart';

class NectorCallOverview extends StatelessWidget {
  final NectorNetworkCall call;
  final NectorUtils _utils = NectorUtils();
  NectorCallOverview({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          CallInfoText(title: 'URL', description: call.uri),
          CallInfoText(title: 'Server', description: call.server),
          CallInfoText(title: 'Endpoint', description: call.endpoint),
          CallInfoText(title: 'Method', description: call.method),
          CallInfoText(
            title: 'Request at',
            description: _utils.hhMMSSAADateParse(call.networkRequest!.time),
          ),
          CallInfoText(
            title: 'Response at',
            description: _utils.hhMMSSAADateParse(call.networkResponse!.time),
          ),
          CallInfoText(
            title: 'Duration',
            description: _utils.parseMilliseconds(call.duration),
          ),
          CallInfoText(
            title: 'Request size',
            description: _utils.parseBytes(call.networkRequest!.size),
          ),
          CallInfoText(
            title: 'Response size',
            description: _utils.parseBytes(call.networkResponse!.size),
          ),
        ],
      ),
    );
  }
}
