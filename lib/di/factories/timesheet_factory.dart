import 'package:flutter/material.dart';
import 'package:tarefas_calendario/di/app_dependencies.dart';
import 'package:tarefas_calendario/features/tarefas/data/datasources/tarefa_datasource.dart';
import 'package:tarefas_calendario/features/tarefas/data/repositories/tarefa_repository.dart';
import 'package:tarefas_calendario/features/timesheet/domain/usecases/busca_tarefas_periodo_usecase.dart';
import 'package:tarefas_calendario/features/timesheet/domain/usecases/exportar_timesheet_usecase.dart';
import 'package:tarefas_calendario/features/timesheet/presentation/pages/timesheet_page.dart';
import 'package:tarefas_calendario/features/timesheet/presentation/viewmodels/timesheet_viewmodel.dart';

class TimesheetFactory {
  TimesheetFactory._();

  static Widget create() {
    final datasource = TarefaDatasource(AppDependencies.databaseHelper);
    final repository = TarefaRepository(datasource);
    final buscarTarefas = BuscarTarefasPeriodoUsecase(repository);
    final exportarTimesheet = ExportarTimesheetUsecase();

    final viewModel = TimesheetViewModel(
      buscarTarefas: buscarTarefas,
      exportarTimesheet: exportarTimesheet,
    );

    return TimesheetPage(viewModel: viewModel);
  }
}
