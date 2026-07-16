import 'package:flutter/material.dart';

extension ExtBuildContext on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  void mostrarSnackBar(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(mensagem, style: TextStyle(color: colorScheme.onSurface)),
        backgroundColor: colorScheme.surfaceContainer,
        behavior: SnackBarBehavior.floating,
        width: 300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.15)),
        ),
      ),
    );
  }
}
