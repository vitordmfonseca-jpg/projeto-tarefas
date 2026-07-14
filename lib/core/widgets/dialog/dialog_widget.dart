import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/extensions/ext_build_context.dart';

class DialogWidget extends StatelessWidget {
  final String titulo;
  final double? largura;
  final List<Widget> widgetCabecalho;
  final Widget conteudo;
  final List<Widget> acoes;

  const DialogWidget({
    super.key,
    required this.titulo,
    this.largura,
    this.widgetCabecalho = const [],
    required this.conteudo,
    required this.acoes,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Dialog(
      child: SizedBox(
        width: largura,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Row(
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    ...widgetCabecalho,
                  ],
                ),
              ),
              conteudo,
              Container(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.1),
                    ),
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 8.0,
                  children: acoes,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
