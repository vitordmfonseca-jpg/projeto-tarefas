import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/utils/date_utils.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';

class TimesheetDiaCellWidget extends StatelessWidget {
  final DateTime dia;
  final List<TarefaEntity> tarefas;
  final bool isHoje;

  const TimesheetDiaCellWidget({
    super.key,
    required this.dia,
    required this.tarefas,
    this.isHoje = false,
  });

  int get _totalMinutos => tarefas.fold(
    0,
    (soma, t) => soma + (t.horasGastas * 60) + t.minutosGastos,
  );

  String get _totalFormatado {
    final horas = _totalMinutos ~/ 60;
    final minutos = _totalMinutos % 60;
    if (_totalMinutos == 0) return '';
    if (minutos == 0) return '${horas}h';
    if (horas == 0) return '${minutos}m';
    return '${horas}h ${minutos}m';
  }

  String _tempoTarefa(TarefaEntity t) {
    if (t.horasGastas == 0) return '${t.minutosGastos}m';
    if (t.minutosGastos == 0) return '${t.horasGastas}h';
    return '${t.horasGastas}h ${t.minutosGastos}m';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final temTarefas = tarefas.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isHoje
              ? colorScheme.primary.withValues(alpha: 0.5)
              : colorScheme.outline.withValues(alpha: 0.1),
          width: isHoje ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header da célula
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isHoje
                  ? colorScheme.primary.withValues(alpha: 0.15)
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
                        ? colorScheme.primary
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

          // Lista de tarefas
          Expanded(
            child: temTarefas
                ? ListView.builder(
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
    );
  }
}
