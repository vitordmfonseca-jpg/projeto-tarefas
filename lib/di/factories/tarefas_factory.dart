import 'package:flutter/material.dart';
import 'package:tarefas_calendario/di/app_dependencies.dart';
import 'package:tarefas_calendario/features/tarefas/data/datasources/tarefa_datasource.dart';
import 'package:tarefas_calendario/features/tarefas/data/repositories/tarefa_repository.dart';
import 'package:tarefas_calendario/features/tarefas/domain/usecases/busca_dias_com_registro_usecase.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/actions/tarefas_action.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/pages/tarefas_page.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/viewmodels/tarefas_viewmodel.dart';

class TarefasFactory {
  TarefasFactory._();

  static Widget create() {
    final datasource = TarefaDatasource(AppDependencies.databaseHelper);
    final repository = TarefaRepository(datasource);
    final buscarDiasComRegistro = BuscarDiasComRegistroUsecase(repository);

    final viewModel = TarefasViewModel(repository, buscarDiasComRegistro);
    final action = TarefasAction(viewModel: viewModel);

    return TarefasPage(viewModel: viewModel, action: action);
  }
}
