import 'package:flutter/material.dart';

extension ExtBuildContext on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
