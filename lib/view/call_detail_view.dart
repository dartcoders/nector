import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nector/model/network_call.dart';
import 'package:nector/utils/nector_color.dart';
import 'package:nector/utils/nector_extensions.dart';
import 'package:nector/utils/nector_text.dart';
import 'package:nector/utils/nector_utils.dart';
import 'package:nector/view/widget/nector_call_overview.dart';
import 'package:nector/view/widget/nector_call_request.dart';
import 'package:nector/view/widget/nector_call_response.dart';

class NectorCallDetailView extends StatelessWidget {
  final NectorNetworkCall networkCall;
  final VoidCallback onClickClose;
  final NectorUtils _utils = NectorUtils();
  NectorCallDetailView(
      {super.key, required this.networkCall, required this.onClickClose});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _getTabBars().length,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: NectorColor.white0,
        appBar: AppBar(
          leading: IconButton(
            onPressed: onClickClose,
            icon: const Icon(
              Icons.arrow_back,
              color: NectorColor.white0,
            ),
          ),
          backgroundColor: NectorColor.blue,
          title: NectorText.textSemiBold(
              text: 'Call Details', fontSize: 16, color: NectorColor.white0),
          bottom: TabBar(
            indicatorColor: NectorColor.white0,
            dividerHeight: 1.5,
            tabs: _getTabBars(),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 66,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _onClickCopyRequest,
                    child: NectorText.textSemiBold(
                        text: 'Copy request', color: NectorColor.black1),
                  ),
                ),
                20.width,
                Expanded(
                  child: OutlinedButton(
                    onPressed: _onClickCopyResponse,
                    child: NectorText.textSemiBold(
                        text: 'Copy response', color: NectorColor.black1),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: _getTabBarViewList(),
        ),
      ),
    );
  }

  _onClickCopyRequest() {
    Clipboard.setData(
      ClipboardData(
        text: _utils.createCurlCommand(
          networkCall.uri,
          networkCall.method,
          body: networkCall.networkRequest?.body,
          headers: networkCall.networkRequest?.headers,
          queryParams: networkCall.networkRequest?.queryParamters,
        ),
      ),
    );
  }

  _onClickCopyResponse() {
    Clipboard.setData(ClipboardData(
      text: _utils.beautifyJson(networkCall.networkResponse?.body ?? {}),
    ));
  }

  List<Widget> _getTabBars() {
    return const [
      Tab(text: 'Overview'),
      Tab(text: 'Request'),
      Tab(text: 'Response'),
    ];
  }

  List<Widget> _getTabBarViewList() {
    return [
      NectorCallOverview(call: networkCall),
      NectorCallRequestView(request: networkCall.networkRequest!),
      NectorCallResponseView(response: networkCall.networkResponse!),
    ];
  }
}
