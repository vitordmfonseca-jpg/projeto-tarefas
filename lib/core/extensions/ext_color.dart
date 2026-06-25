import 'package:flutter/material.dart';

extension ExtColor on Color {
  Color calculaCorSec() {
    return computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}
