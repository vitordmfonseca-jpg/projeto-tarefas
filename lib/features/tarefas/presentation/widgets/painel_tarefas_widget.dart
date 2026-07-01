import 'package:flutter/material.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/viewmodels/tarefas_viewmodel.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/widgets/dialog_adicionar_tarefa.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/widgets/tarefa_card_widget.dart';

class PainelTarefasWidget extends StatelessWidget {
  final TarefasViewModel vm;

  const PainelTarefasWidget({super.key, required this.vm});

  static const _diasSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
  static const _meses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  String _tituloDia(DateTime dia) {
    final nomeDia = _diasSemana[dia.weekday - 1];
    final nomeMes = _meses[dia.month - 1];
    return '$nomeDia, ${dia.day} de $nomeMes de ${dia.year}';
  }

  Future<void> _adicionarTarefa(BuildContext context) async {
    final tarefa = await showDialog(
      context: context,
      builder: (_) => DialogAdicionarTarefa(diaSelecionado: vm.diaSelecionado),
    );
    if (tarefa != null) await vm.salvar(tarefa);
  }

  Future<void> _deletarTarefa(
    BuildContext context,
    int id,
    String titulo,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir tarefa'),
        content: Text('Deseja excluir "$titulo"?'),
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
    if (confirmar == true) await vm.deletar(id);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _tituloDia(vm.diaSelecionado),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${vm.tarefas.length} tarefas registradas',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  if (vm.tarefas.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.4),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            vm.totalFormatadoDia,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            'total do dia',
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Lista
            Expanded(
              child: vm.carregando
                  ? const Center(child: CircularProgressIndicator())
                  : vm.tarefas.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 40,
                            color: Colors.white38,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Nenhuma tarefa registrada\npara este dia',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: vm.tarefas.length,
                      itemBuilder: (_, i) => TarefaCardWidget(
                        tarefa: vm.tarefas[i],
                        onDeletar: () => _deletarTarefa(
                          context,
                          vm.tarefas[i].id!,
                          vm.tarefas[i].titulo,
                        ),
                      ),
                    ),
            ),

            // Botão adicionar
            Padding(
              padding: const EdgeInsets.all(12),
              child: FilledButton.icon(
                onPressed: () => _adicionarTarefa(context),
                icon: const Icon(Icons.add),
                label: const Text('Registrar Tarefa'),
              ),
            ),
          ],
        );
      },
    );
  }
}
