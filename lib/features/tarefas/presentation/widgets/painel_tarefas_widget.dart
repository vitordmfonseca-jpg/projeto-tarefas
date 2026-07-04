import 'package:flutter/material.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/enums/modo_dialog.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/viewmodels/tarefas_viewmodel.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/widgets/dialog_adicionar_tarefa.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/widgets/tarefa_card_widget.dart';
import 'package:tarefas_calendario/core/utils/date_utils.dart';

class PainelTarefasWidget extends StatelessWidget {
  final TarefasViewModel vm;

  const PainelTarefasWidget({super.key, required this.vm});

  Future<void> _abrirDialog(
    BuildContext context, {
    TarefaEntity? tarefa,
    ModoDialog modo = ModoDialog.cadastro,
  }) async {
    final resultado = await showDialog<TarefaEntity>(
      context: context,
      builder: (_) => DialogAdicionarTarefa(
        diaSelecionado: vm.diaSelecionado,
        tarefa: tarefa,
        modo: modo,
      ),
    );
    if (resultado != null) await vm.salvar(resultado);
  }

  Future<void> _deletarTarefa(BuildContext context, TarefaEntity tarefa) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir tarefa'),
        content: Text('Deseja excluir "${tarefa.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmar == true) await vm.deletar(tarefa.id!);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        final progresso = (vm.totalMinutosDia / vm.metaMinutosDia).clamp(
          0.0,
          1.0,
        );
        final bateuMeta = vm.totalMinutosDia >= vm.metaMinutosDia;
        final minutosRestantes = vm.metaMinutosDia - vm.totalMinutosDia;
        final horasRest = minutosRestantes ~/ 60;
        final minRest = minutosRestantes % 60;
        final textoMeta = bateuMeta
            ? 'Meta atingida!'
            : 'Faltam ${horasRest > 0 ? '${horasRest}h ' : ''}${minRest}m';

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(10),
            border: Border(
              left: BorderSide(color: colorScheme.primary, width: 3),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header — usa secondary para destacar o dia
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppDateUtils.formatarDiaCompleto(
                                vm.diaSelecionado,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            // Usa secondary para o contador de tarefas
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${vm.tarefas.length} tarefas registradas',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (vm.tarefas.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                vm.totalFormatadoDia,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.primary,
                                ),
                              ),
                              Text(
                                'total do dia',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // Lista
                Expanded(
                  child: vm.carregando
                      ? const Center(child: CircularProgressIndicator())
                      : vm.tarefas.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.assignment_outlined,
                                size: 40,
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Nenhuma tarefa registrada\npara este dia',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: vm.tarefas.length,
                          itemBuilder: (_, i) => TarefaCardWidget(
                            tarefa: vm.tarefas[i],
                            onVisualizar: () => _abrirDialog(
                              context,
                              tarefa: vm.tarefas[i],
                              modo: ModoDialog.visualizacao,
                            ),
                            onEditar: () => _abrirDialog(
                              context,
                              tarefa: vm.tarefas[i],
                              modo: ModoDialog.edicao,
                            ),
                            onDeletar: () =>
                                _deletarTarefa(context, vm.tarefas[i]),
                          ),
                        ),
                ),

                // Rodapé
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton.icon(
                        onPressed: () => _abrirDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Registrar Tarefa'),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Meta do dia',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                                Text(
                                  textoMeta,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    // secondary quando bate a meta
                                    color: bateuMeta
                                        ? colorScheme.secondary
                                        : colorScheme.onSurface.withValues(
                                            alpha: 0.7,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: LinearProgressIndicator(
                                value: progresso,
                                backgroundColor: colorScheme.outline.withValues(
                                  alpha: 0.15,
                                ),
                                // secondary quando bate a meta
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  bateuMeta
                                      ? colorScheme.secondary
                                      : colorScheme.primary,
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
