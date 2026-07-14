import 'package:flutter/material.dart';
import 'package:tarefas_calendario/features/configuracoes/data/datasources/configuracoes_datasource.dart';
import 'package:tarefas_calendario/features/configuracoes/data/repositories/configuracoes_repository.dart';
import 'package:tarefas_calendario/features/configuracoes/presentation/actions/configuracoes_action.dart';
import 'package:tarefas_calendario/features/configuracoes/presentation/pages/configuracoes_page.dart';
import 'package:tarefas_calendario/features/configuracoes/presentation/viewmodels/configuracoes_viewmodel.dart';

class ConfiguracoesFactory {
  ConfiguracoesFactory._();

  static Widget create({required ValueNotifier<ThemeMode> temaNotifier}) {
    final datasource = ConfiguracoesDatasource();
    final repository = ConfiguracoesRepository(datasource);

    final viewModel = ConfiguracoesViewModel(repository, temaNotifier);
    final action = ConfiguracoesAction(viewModel: viewModel);

    return ConfiguracoesPage(viewModel: viewModel, action: action);
  }
}
