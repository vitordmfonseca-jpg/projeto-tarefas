import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/utils/app_utils.dart';
import 'package:tarefas_calendario/features/timesheet/domain/enums/modo_timesheet.dart';
import 'package:tarefas_calendario/features/timesheet/presentation/viewmodels/timesheet_viewmodel.dart';
import 'package:tarefas_calendario/features/timesheet/presentation/widgets/timesheet_dia_cell_widget.dart';

class TimesheetGradeWidget extends StatelessWidget {
  final TimesheetViewModel vm;

  const TimesheetGradeWidget({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final dias = vm.calcularDiasDoPeriodo();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: vm.modo == ModoTimesheet.semanal
          ? _TimesheetSemanalWidget(vm: vm, dias: dias)
          : _TimesheetMensalWidget(vm: vm, dias: dias),
    );
  }
}

class _TimesheetSemanalWidget extends StatelessWidget {
  final TimesheetViewModel vm;
  final List<DateTime> dias;

  const _TimesheetSemanalWidget({required this.vm, required this.dias});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: dias.map((dia) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: TimesheetDiaCellWidget(
              dia: dia,
              tarefas: vm.tarefasDoDia(dia),
              isHoje: AppDateUtils.isHoje(dia),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Widget privado — modo mensal
class _TimesheetMensalWidget extends StatelessWidget {
  final TimesheetViewModel vm;
  final List<DateTime> dias;

  const _TimesheetMensalWidget({required this.vm, required this.dias});

  @override
  Widget build(BuildContext context) {
    final semanas = (dias.length / 7).ceil();

    return LayoutBuilder(
      builder: (context, constraints) {
        const espacoEntreItens = 6.0;
        final alturaTotal = constraints.maxHeight;
        final larguraTotal = constraints.maxWidth;
        final alturaCelula =
            (alturaTotal - (semanas - 1) * espacoEntreItens) / semanas;
        final larguraCelula = (larguraTotal - 6 * espacoEntreItens) / 7;
        final ratio = larguraCelula / alturaCelula;

        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: GridView.count(
            crossAxisCount: 7,
            crossAxisSpacing: espacoEntreItens,
            mainAxisSpacing: espacoEntreItens,
            childAspectRatio: ratio,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: dias
                .map(
                  (dia) => TimesheetDiaCellWidget(
                    dia: dia,
                    tarefas: vm.tarefasDoDia(dia),
                    isHoje: AppDateUtils.isHoje(dia),
                    isMesAtual:
                        dia.month == vm.inicioPeriodo.month &&
                        dia.year == vm.inicioPeriodo.year,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
