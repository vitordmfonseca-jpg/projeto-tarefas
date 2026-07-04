import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/ui_components/calendario/custom_calendario_widget.dart';
import 'package:tarefas_calendario/features/tarefas/data/database_helper.dart';
import 'package:tarefas_calendario/features/tarefas/data/datasources/tarefa_datasource.dart';
import 'package:tarefas_calendario/features/tarefas/data/repositories/tarefa_repository.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/viewmodels/tarefas_viewmodel.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/widgets/painel_tarefas_widget.dart';

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  late final TarefasViewModel _vm;

  @override
  void initState() {
    super.initState();
    final dbHelper = DatabaseHelper.instance;
    final datasource = TarefaDatasource(dbHelper);
    final repository = TarefaRepository(datasource);
    _vm = TarefasViewModel(repository);
    _vm.carregarMeta();
    _vm.selecionarDia(DateTime.now());
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        spacing: 8.0,
        children: [
          Flexible(
            flex: 2,
            child: CustomCalendarioWidget(
              mesAtual: DateTime.now(),
              diaSelecionado: (dia) => _vm.selecionarDia(dia),
            ),
          ),
          Flexible(child: PainelTarefasWidget(vm: _vm)),
        ],
      ),
    );
  }
}
