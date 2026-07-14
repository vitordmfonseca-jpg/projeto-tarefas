import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/extensions/ext_build_context.dart';

class TextFormWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final int maxLines;
  final String? hint;

  const TextFormWidget({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.maxLines = 1,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        TextField(
          controller: controller,
          readOnly: readOnly,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
