import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/utils/app_utils.dart';
import 'package:tarefas_calendario/core/utils/duracao_utils.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';

class TimesheetDiaCellWidget extends StatelessWidget {
  final DateTime dia;
  final List<TarefaEntity> tarefas;
  final bool isHoje;
  final bool isMesAtual;

  const TimesheetDiaCellWidget({
    super.key,
    required this.dia,
    required this.tarefas,
    this.isHoje = false,
    this.isMesAtual = true,
  });

  int get _totalMinutos => tarefas.fold(0, (soma, t) => soma + t.minutosTotais);

  String get _totalFormatado =>
      _totalMinutos == 0 ? '' : DuracaoUtils.formatar(_totalMinutos);

  String _tempoTarefa(TarefaEntity t) => DuracaoUtils.formatar(t.minutosTotais);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final temTarefas = tarefas.isNotEmpty;

    return Opacity(
      opacity: isMesAtual ? 1.0 : 0.35,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isHoje
                ? colorScheme.secondary.withValues(alpha: 0.6)
                : colorScheme.outline.withValues(alpha: 0.1),
            width: isHoje ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isHoje
                    ? colorScheme.secondary.withValues(alpha: 0.12)
                    : colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppDateUtils.formatarDiaCurto(dia),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,

                      color: isHoje
                          ? colorScheme.secondary
                          : colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  if (temTarefas)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _totalFormatado,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              child: temTarefas
                  ? ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: true),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(6),
                        itemCount: tarefas.length,
                        itemBuilder: (_, i) {
                          final tarefa = tarefas[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    _tempoTarefa(tarefa),
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    tarefa.titulo,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.85,
                                      ),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                        '—',
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.2),
                          fontSize: 16,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
