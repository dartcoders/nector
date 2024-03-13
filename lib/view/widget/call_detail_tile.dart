import 'package:flutter/material.dart';
import 'package:nector/utils/nector_color.dart';
import 'package:nector/utils/nector_extensions.dart';
import 'package:nector/utils/nector_text.dart';

class CallDetailTile extends StatelessWidget {
  final int statusCode;
  final bool isComplete;
  final bool isSecure;
  final String size;
  final String method;
  final String endpoint;
  final String server;
  final String duration;
  final String createdAt;

  const CallDetailTile({
    super.key,
    required this.statusCode,
    required this.size,
    required this.isComplete,
    required this.isSecure,
    required this.method,
    required this.endpoint,
    required this.server,
    required this.createdAt,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isComplete) ...[
            NectorText.textBold(
              text: statusCode.toString(),
              color: _getColor,
            ),
            20.width,
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NectorText.textBold(
                  text: '$method $endpoint',
                  maxLines: 10,
                  color: isComplete ? _getColor : NectorColor.grey,
                ),
                6.height,
                Row(
                  children: [
                    const Icon(
                      Icons.lock,
                      size: 14,
                      color: NectorColor.grey,
                    ),
                    4.width,
                    NectorText.textRegular(text: server),
                  ],
                ),
                6.height,
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NectorText.textRegular(text: createdAt),
                      if (isComplete) ...[
                        NectorText.textRegular(text: duration),
                        NectorText.textRegular(text: size),
                      ]
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color get _getColor {
    if (statusCode >= 400 && statusCode < 500) {
      return NectorColor.orange;
    } else if (statusCode >= 500) {
      return NectorColor.red;
    } else {
      return NectorColor.black1;
    }
  }
}
