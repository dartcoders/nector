import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nector/controller/nector_contoller.dart';
import 'package:nector/model/network_call.dart';
import 'package:nector/utils/nector_color.dart';
import 'package:nector/utils/nector_extensions.dart';
import 'package:nector/utils/nector_text.dart';
import 'package:nector/utils/nector_utils.dart';
import 'package:nector/view/call_detail_view.dart';
import 'package:nector/view/widget/call_detail_tile.dart';

class NectorCallsView extends StatelessWidget {
  final NectorController _controller;
  final NectorUtils _utils = NectorUtils();
  NectorCallsView(this._controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _appBar(context),
        body: StreamBuilder<List<NectorNetworkCall>?>(
          stream: _controller.callsSubject,
          builder: (context, snapshot) {
            List<NectorNetworkCall> calls = snapshot.data ?? [];
            if (calls.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ListView.separated(
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: calls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (!calls[index].isLoading) {
                          _controller.addCallDetailView(
                            OverlayEntry(
                              builder: (context) => NectorCallDetailView(
                                networkCall: calls[index],
                                onClickClose: _controller.removeCallDetailView,
                              ),
                            ),
                          );
                        }
                      },
                      child: CallDetailTile(
                        statusCode:
                            calls[index].networkResponse?.statusCode ?? 0,
                        size: _utils.parseBytes(
                            calls[index].networkResponse?.size ?? 0),
                        isComplete: !calls[index].isLoading,
                        method: calls[index].method,
                        endpoint: calls[index].endpoint,
                        server: calls[index].server,
                        createdAt:
                            _utils.hhMMSSAADateParse(calls[index].createdTime),
                        duration:
                            _utils.parseMilliseconds(calls[index].duration),
                        isSecure: true,
                      ),
                    );
                  },
                ),
              );
            } else {
              return _emptyView();
            }
          },
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: NectorColor.blue,
      leading: GestureDetector(
        onTap: () => _controller.removeCallsListView(),
        child: const Icon(
          Icons.close,
          color: NectorColor.white0,
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NectorText.textSemiBold(
            text: 'Nector',
            fontSize: 18,
            color: NectorColor.white0,
          ),
          4.width,
          if (_controller.appName.isNotEmpty) ...[
            NectorText.textMedium(
              text: '(${_controller.appName} ${kDebugMode ? 'Dev' : ''})',
              color: NectorColor.white1,
            ),
          ],
        ],
      ),
      actions: [
        IconButton(
          padding: const EdgeInsets.only(right: 16),
          onPressed: _controller.onClickClearLogs,
          icon: NectorText.textSemiBold(
            text: 'Clear',
            color: NectorColor.white0,
          ),
        ),
      ],
    );
  }

  Widget _emptyView() {
    return const Center(child: Text('No network calls...'));
  }
}
