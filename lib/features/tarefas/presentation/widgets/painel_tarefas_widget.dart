import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/utils/app_utils.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/actions/tarefas_action.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/enums/modo_dialog.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/viewmodels/tarefas_viewmodel.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/widgets/tarefa_card_widget.dart';

class PainelTarefasWidget extends StatelessWidget {
  final TarefasViewModel vm;
  final TarefasAction action;

  const PainelTarefasWidget({
    super.key,
    required this.vm,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
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
                _PainelHeaderWidget(vm: vm),
                Expanded(child: _PainelListaWidget(vm: vm, action: action)),
                _PainelRodapeWidget(vm: vm, action: action),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PainelHeaderWidget extends StatelessWidget {
  final TarefasViewModel vm;

  const _PainelHeaderWidget({required this.vm});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
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
                  AppDateUtils.formatarDiaCompleto(vm.diaSelecionado),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
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
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (vm.tarefas.isNotEmpty) _TotalDiaBadgeWidget(vm: vm),
        ],
      ),
    );
  }
}

class _TotalDiaBadgeWidget extends StatelessWidget {
  final TarefasViewModel vm;

  const _TotalDiaBadgeWidget({required this.vm});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.4)),
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
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _PainelListaWidget extends StatelessWidget {
  final TarefasViewModel vm;
  final TarefasAction action;

  const _PainelListaWidget({required this.vm, required this.action});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (vm.carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.tarefas.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 40,
              color: colorScheme.onSurface.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 8),
            Text(
              'Nenhuma tarefa registrada\npara este dia',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: vm.tarefas.length,
      itemBuilder: (context, i) => TarefaCardWidget(
        tarefa: vm.tarefas[i],
        onVisualizar: () => action.abrirDialog(
          context,
          tarefa: vm.tarefas[i],
          modo: ModoDialog.visualizacao,
        ),
        onEditar: () => action.abrirDialog(
          context,
          tarefa: vm.tarefas[i],
          modo: ModoDialog.edicao,
        ),
        onDeletar: () => action.deletarTarefa(context, vm.tarefas[i]),
      ),
    );
  }
}

class _PainelRodapeWidget extends StatelessWidget {
  final TarefasViewModel vm;
  final TarefasAction action;

  const _PainelRodapeWidget({required this.vm, required this.action});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            onPressed: () => action.abrirDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Registrar Tarefa'),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      vm.textoMeta,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: vm.bateuMeta
                            ? colorScheme.secondary
                            : colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: vm.progressoMeta,
                    backgroundColor: colorScheme.outline.withValues(
                      alpha: 0.15,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      vm.bateuMeta ? colorScheme.secondary : colorScheme.primary,
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
