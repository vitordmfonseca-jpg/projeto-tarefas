import 'package:flutter/material.dart';

extension ExtBuildContext on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
}
