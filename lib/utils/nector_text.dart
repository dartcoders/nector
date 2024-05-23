import 'package:flutter/material.dart';
import 'package:nector/utils/nector_color.dart';

class NectorText {
  static Text textRegular(
      {required String text,
      double fontSize = 14,
      Color color = NectorColor.black0}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static Text textMedium(
      {required String text,
      double fontSize = 14,
      Color color = NectorColor.black0}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static Text textSemiBold(
      {required String text,
      double fontSize = 14,
      Color color = NectorColor.black0}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static Text textBold(
      {required String text,
      double fontSize = 16,
      Color color = NectorColor.black0,
      int maxLines = 1}) {
    return Text(
      text,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
