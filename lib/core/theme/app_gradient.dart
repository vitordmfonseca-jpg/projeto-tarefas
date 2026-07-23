// ignore_for_file: unintended_html_in_doc_comment

import 'package:flutter/material.dart';

/// Extensão de tema customizada para gradientes do app.
class AppGradient extends ThemeExtension<AppGradient> {
  final LinearGradient headerGradient;

  const AppGradient({required this.headerGradient});

  /// Gera o gradiente do tema escuro a partir da cor primária
  factory AppGradient.dark(Color primary) => AppGradient(
    headerGradient: LinearGradient(
      colors: [primary, Color.lerp(primary, Colors.black, 0.4)!],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
  );

  /// Gera o gradiente do tema claro a partir da cor primária
  factory AppGradient.light(Color primary) => AppGradient(
    headerGradient: LinearGradient(
      colors: [primary, Color.lerp(primary, Colors.white, 0.2)!],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
  );

  @override
  AppGradient copyWith({LinearGradient? headerGradient}) {
    return AppGradient(headerGradient: headerGradient ?? this.headerGradient);
  }

  @override
  AppGradient lerp(ThemeExtension<AppGradient>? other, double t) {
    if (other is! AppGradient) return this;
    return AppGradient(
      headerGradient: LinearGradient.lerp(
        headerGradient,
        other.headerGradient,
        t,
      )!,
    );
  }
}
