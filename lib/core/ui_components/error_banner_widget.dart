import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/extensions/ext_build_context.dart';

class ErrorBannerWidget extends StatelessWidget {
  final String mensagem;

  const ErrorBannerWidget({super.key, required this.mensagem});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.4)),
      ),
      child: Text(
        mensagem,
        style: TextStyle(color: colorScheme.error, fontSize: 12),
      ),
    );
  }
}
