import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/utils/date_utils.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/timesheet/presentation/viewmodels/timesheet_viewmodel.dart';
import 'package:tarefas_calendario/features/timesheet/presentation/widgets/timesheet_dia_cell_widget.dart';

class TimesheetGradeWidget extends StatelessWidget {
  final TimesheetViewModel vm;

  const TimesheetGradeWidget({super.key, required this.vm});

  List<TarefaEntity> _tarefasDoDia(DateTime dia) {
    final chave = DateTime(dia.year, dia.month, dia.day);
    return vm.tarefasPorDia[chave] ?? [];
  }

  bool _isHoje(DateTime dia) {
    final hoje = DateTime.now();
    return dia.year == hoje.year &&
        dia.month == hoje.month &&
        dia.day == hoje.day;
  }

  /// Gera lista de dias do período atual
  List<DateTime> _diasDoPeriodo() {
    final dias = <DateTime>[];
    var dia = vm.inicioPeriodo;
    while (!dia.isAfter(vm.fimPeriodo)) {
      dias.add(dia);
      dia = dia.add(const Duration(days: 1));
    }
    return dias;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dias = _diasDoPeriodo();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Labels dos dias da semana
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          child: Row(
            children: AppDateUtils.diasSemana.map((label) {
              return Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Grade
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: vm.modo == ModoTimesheet.semanal
                ? _buildSemanal(dias)
                : _buildMensal(dias),
          ),
        ),
      ],
    );
  }

  Widget _buildSemanal(List<DateTime> dias) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: dias.map((dia) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: TimesheetDiaCellWidget(
              dia: dia,
              tarefas: _tarefasDoDia(dia),
              isHoje: _isHoje(dia),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMensal(List<DateTime> dias) {
    // Divide os dias em semanas de 7
    final semanas = <List<DateTime>>[];
    for (var i = 0; i < dias.length; i += 7) {
      semanas.add(dias.sublist(i, i + 7 > dias.length ? dias.length : i + 7));
    }

    return Column(
      children: semanas.map((semana) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: semana.map((dia) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: TimesheetDiaCellWidget(
                      dia: dia,
                      tarefas: _tarefasDoDia(dia),
                      isHoje: _isHoje(dia),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }
}
