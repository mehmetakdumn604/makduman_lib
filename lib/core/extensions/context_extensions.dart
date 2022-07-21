import 'package:flutter/material.dart';

const double defaultLowValue = 4;
const double defaultMidValue = 8;
const double defaultHighValue = 12;

const double buttonLowValue = 35;
const double buttonMidValue = 50;
const double buttonHighValue = 100;

extension SizeExtension on BuildContext {
  Size get size => MediaQuery.of(this).size;
  double get width => size.width;
  double get height => size.height;
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;
}

extension PaddingExtension on BuildContext {
  EdgeInsets paddingHorizontalLow({double horizontal = defaultLowValue}) => EdgeInsets.symmetric(horizontal: horizontal);
  EdgeInsets paddingHorizontalMid({double horizontal = defaultMidValue}) => EdgeInsets.symmetric(horizontal: horizontal);
  EdgeInsets paddingHorizontalHigh({double horizontal = defaultHighValue}) => EdgeInsets.symmetric(horizontal: horizontal);
  EdgeInsets paddingVerticalLow({double vertical = defaultLowValue}) => EdgeInsets.symmetric(vertical: vertical);
  EdgeInsets paddingVerticalMid({double vertical = defaultMidValue}) => EdgeInsets.symmetric(vertical: vertical);
  EdgeInsets paddingVerticalHigh({double vertical = defaultHighValue}) => EdgeInsets.symmetric(vertical: vertical);
}

