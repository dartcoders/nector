import 'package:flutter/material.dart';
import 'package:nector/model/network_response.dart';
import 'package:nector/utils/nector_color.dart';
import 'package:nector/utils/nector_extensions.dart';
import 'package:nector/utils/nector_utils.dart';
import 'package:nector/view/widget/info_text.dart';

class NectorCallResponseView extends StatefulWidget {
  final NectorNetworkResponse response;

  const NectorCallResponseView({super.key, required this.response});

  @override
  State<NectorCallResponseView> createState() => _NectorCallResponseViewState();
}

class _NectorCallResponseViewState extends State<NectorCallResponseView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String? _foundText;
  final List<int> _foundIndices = [];
  final NectorUtils _utils = NectorUtils();
  String data = '';
  bool _isSearchEnabled = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    data = _utils.beautifyJson(widget.response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onTap: () {
                    setState(() {
                      _isSearchEnabled = true;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter keyword...',
                    contentPadding: const EdgeInsets.only(left: 10),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(color: NectorColor.grey),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(color: NectorColor.grey),
                    ),
                    suffixIcon: _isSearchEnabled
                        ? IconButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                _searchController.text = '';
                                _isSearchEnabled = false;
                                _foundIndices.clear();
                                _foundText = null;
                                _currentIndex = 0;
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: NectorColor.black1,
                            ),
                          )
                        : const Icon(
                            Icons.search,
                            color: NectorColor.black1,
                          ),
                  ),
                  controller: _searchController,
                  onChanged: (value) {
                    if (value.length >= 2) {
                      _search(value.toLowerCase());
                    } else if (_foundText?.isNotEmpty ?? false) {
                      setState(() {
                        _foundText = null;
                        _foundIndices.clear();
                      });
                    }
                  },
                ),
              ),
              if (_isSearchEnabled && _foundIndices.length > 1) ...[
                IconButton(
                  onPressed: _moveUp,
                  icon: Icon(
                    Icons.arrow_upward,
                    color: _currentIndex == 0 ? NectorColor.grey : null,
                  ),
                ),
                IconButton(
                  onPressed: _moveDown,
                  icon: Icon(
                    Icons.arrow_downward,
                    color: _currentIndex == _foundIndices.length - 1
                        ? NectorColor.grey
                        : null,
                  ),
                ),
              ]
            ],
          ),
          20.height,
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  CallInfoText(
                    title: 'Response at',
                    description: _utils.hhMMSSAADateParse(widget.response.time),
                  ),
                  CallInfoText(
                    title: 'Response size',
                    description: _utils.parseBytes(widget.response.size),
                  ),
                  CallInfoText(
                    title: 'Status code',
                    description: widget.response.statusCode.toString(),
                  ),
                  const CallInfoText(
                    title: 'Body',
                    description: '',
                  ),
                  10.height,
                  _buildText(data, _foundText),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildText(String text, String? searchTerm) {
    TextStyle textStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: NectorColor.black1,
    );
    if (searchTerm == null || searchTerm.isEmpty) {
      return SelectableText(data, style: textStyle);
    }

    final String searchTermLower = searchTerm.toLowerCase();
    final List<TextSpan> textSpans = <TextSpan>[];

    int startIndex = 0;
    while (true) {
      final String lowerCaseText = text.substring(startIndex).toLowerCase();
      final int matchIndex = lowerCaseText.indexOf(searchTermLower);
      if (matchIndex == -1) {
        break;
      }

      final start = startIndex + matchIndex;
      final end = start + searchTerm.length;

      textSpans.add(TextSpan(text: text.substring(startIndex, start)));
      textSpans.add(TextSpan(
        text: text.substring(start, end),
        style: const TextStyle(
          color: Colors.red,
          backgroundColor: Colors.yellow,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ));
      startIndex = end;
    }
    textSpans.add(TextSpan(text: text.substring(startIndex)));

    return SelectableText.rich(
      TextSpan(children: textSpans, style: textStyle),
    );
  }

  void _search(String searchTerm) {
    _foundIndices.clear();
    int startIndex = 0;
    while (true) {
      final index = widget.response.body
          .toString()
          .toLowerCase()
          .indexOf(searchTerm, startIndex);
      if (index == -1) break;
      _foundIndices.add(index);
      startIndex = index + searchTerm.length;
    }

    if (_foundIndices.isNotEmpty) {
      setState(() {
        _foundText = searchTerm;
      });
      _currentIndex = 0;
      _scrollToIndex();
    } else {
      setState(() {
        _foundText = null;
      });
    }
  }

  void _moveUp() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _scrollToIndex();
    }
  }

  void _moveDown() {
    if (_currentIndex < _foundIndices.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _scrollToIndex();
    }
  }

  void _scrollToIndex() {
    if (_currentIndex >= 0 && _currentIndex < _foundIndices.length) {
      final offset = _foundIndices[_currentIndex];
      _scrollController.animateTo(
        offset + 50,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
