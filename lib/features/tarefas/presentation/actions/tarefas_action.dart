import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/extensions/ext_build_context.dart';
import 'package:tarefas_calendario/core/widgets/dialog/dialog_widget.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/enums/modo_dialog.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/viewmodels/tarefas_viewmodel.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/widgets/dialog_adicionar_tarefa.dart';

class TarefasAction {
  TarefasAction({required TarefasViewModel viewModel}) : _viewModel = viewModel;

  final TarefasViewModel _viewModel;

  Future<void> abrirDialog(
    BuildContext context, {
    TarefaEntity? tarefa,
    ModoDialog modo = ModoDialog.cadastro,
  }) async {
    final resultado = await showDialog<TarefaEntity>(
      context: context,
      builder: (_) => DialogAdicionarTarefa(
        diaSelecionado: _viewModel.diaSelecionado,
        tarefa: tarefa,
        modo: modo,
      ),
    );
    if (resultado != null) await _viewModel.salvar(resultado);
  }

  Future<void> deletarTarefa(BuildContext context, TarefaEntity tarefa) async {
    final colorScheme = context.colorScheme;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => DialogWidget(
        titulo: 'Excluir tarefa',
        largura: context.mediaQuery.size.width * .5,
        conteudo: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Text('Deseja excluir "${tarefa.titulo}"?'),
        ),
        acoes: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmar == true) await _viewModel.deletar(tarefa.id!);
  }
}
