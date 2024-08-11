import 'package:flutter/material.dart';

class NectorTextSearch extends StatefulWidget {
  final String longText;
  const NectorTextSearch({super.key, required this.longText});

  @override
  State<NectorTextSearch> createState() => _NectorTextSearchState();
}

class _NectorTextSearchState extends State<NectorTextSearch> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String? _foundText;
  final List<int> _foundIndices = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: (value) {
            if (value.length >= 3) _search(value);
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: _buildHighlightedText(widget.longText, _foundText),
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightedText(String text, String? searchTerm) {
    if (searchTerm == null || searchTerm.isEmpty) {
      return Text(text);
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

      textSpans.add(TextSpan(
        text: text.substring(startIndex, start),
        style: const TextStyle(color: Colors.black),
      ));
      textSpans.add(TextSpan(
        text: text.substring(start, end),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red,
          backgroundColor: Colors.yellow,
        ),
      ));
      startIndex = end;
    }

    textSpans.add(TextSpan(
      text: text.substring(startIndex),
      style: const TextStyle(color: Colors.black),
    ));

    return RichText(
      text: TextSpan(children: textSpans),
    );
  }

  void _search(String searchTerm) {
    _foundIndices.clear();
    int startIndex = 0;
    while (true) {
      final index = widget.longText.indexOf(searchTerm, startIndex);
      if (index == -1) break;
      _foundIndices.add(index);
      startIndex = index + searchTerm.length;
    }

    if (_foundIndices.isNotEmpty) {
      setState(() {
        _foundText = searchTerm;
      });
      _scrollToIndex(_foundIndices.last);
    } else {
      setState(() {
        _foundText = null;
      });
    }
  }

  void _scrollToIndex(int index) {
    final offset = index * 8.4;
    _scrollController.animateTo(
      offset + 100,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
