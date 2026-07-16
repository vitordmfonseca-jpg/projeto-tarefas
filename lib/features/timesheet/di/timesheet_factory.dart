import 'package:flutter/material.dart';
import 'package:tarefas_calendario/features/tarefas/di/tarefas_factory.dart';
import 'package:tarefas_calendario/features/timesheet/domain/usecases/busca_tarefas_periodo_usecase.dart';
import 'package:tarefas_calendario/features/timesheet/domain/usecases/exportar_timesheet_usecase.dart';
import 'package:tarefas_calendario/features/timesheet/presentation/pages/timesheet_page.dart';
import 'package:tarefas_calendario/features/timesheet/presentation/viewmodels/timesheet_viewmodel.dart';

class TimesheetFactory {
  TimesheetFactory._();

  static Widget create() {
    final repository = TarefasFactory.criarRepository();
    final buscarTarefas = BuscarTarefasPeriodoUsecase(repository);
    final exportarTimesheet = ExportarTimesheetUsecase();

    final viewModel = TimesheetViewModel(
      buscarTarefas: buscarTarefas,
      exportarTimesheet: exportarTimesheet,
    );

    return TimesheetPage(viewModel: viewModel);
  }
}
