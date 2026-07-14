import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/extensions/ext_build_context.dart';
import 'package:tarefas_calendario/core/widgets/dialog/dialog_widget.dart';
import 'package:tarefas_calendario/features/configuracoes/presentation/viewmodels/configuracoes_viewmodel.dart';

class ConfiguracoesAction {
  ConfiguracoesAction({required ConfiguracoesViewModel viewModel})
    : _viewModel = viewModel;

  final ConfiguracoesViewModel _viewModel;

  void _mostrarSnackBar(BuildContext context, String mensagem) {
    if (!context.mounted) return;
    final colorScheme = context.colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
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

  Future<void> salvarMeta(
    BuildContext context,
    String horasTexto,
    String minutosTexto,
  ) async {
    await _viewModel.salvarMeta(horasTexto, minutosTexto);
    if (!context.mounted) return;
    _mostrarSnackBar(context, 'Meta salva com sucesso!');
  }

  Future<void> exportarBanco(BuildContext context) async {
    final caminho = await _viewModel.exportarBanco();
    if (!context.mounted) return;
    _mostrarSnackBar(
      context,
      caminho != null ? 'Banco exportado para Downloads!' : 'Erro ao exportar.',
    );
  }

  Future<void> confirmarImportacao(BuildContext context) async {
    final colorScheme = context.colorScheme;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => DialogWidget(
        titulo: 'Importar banco de dados',
        conteudo: const Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Text(
            'O banco atual será substituído e o app será reiniciado. Deseja continuar?',
          ),
        ),
        acoes: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
            child: const Text('Importar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final sucesso = await _viewModel.importarBanco();
    if (!sucesso && context.mounted) {
      _mostrarSnackBar(context, 'Erro ao importar banco.');
    }
  }
}
