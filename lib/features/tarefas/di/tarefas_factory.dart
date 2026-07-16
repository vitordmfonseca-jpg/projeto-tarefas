import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/di/app_dependencies.dart';
import 'package:tarefas_calendario/features/tarefas/data/datasources/tarefa_datasource.dart';
import 'package:tarefas_calendario/features/tarefas/data/repositories/tarefa_repository.dart';
import 'package:tarefas_calendario/features/tarefas/domain/repositories/i_tarefa_repository.dart';
import 'package:tarefas_calendario/features/tarefas/domain/usecases/busca_dias_com_registro_usecase.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/actions/tarefas_action.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/pages/tarefas_page.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/viewmodels/tarefas_viewmodel.dart';

class TarefasFactory {
  TarefasFactory._();

  /// Ponto de acesso ao repositório de tarefas para outras features
  static ITarefaRepository criarRepository() {
    return TarefaRepository(TarefaDatasource(AppDependencies.databaseHelper));
  }

  static Widget create() {
    final repository = criarRepository();
    final buscarDiasComRegistro = BuscarDiasComRegistroUsecase(repository);

    final viewModel = TarefasViewModel(repository, buscarDiasComRegistro);
    final action = TarefasAction(viewModel: viewModel);

    return TarefasPage(viewModel: viewModel, action: action);
  }
}
