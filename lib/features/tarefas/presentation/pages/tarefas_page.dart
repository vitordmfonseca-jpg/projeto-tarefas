import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/ui_components/calendario/custom_calendario_widget.dart';
import 'package:tarefas_calendario/features/tarefas/data/database_helper.dart';
import 'package:tarefas_calendario/features/tarefas/data/datasources/tarefa_datasource.dart';
import 'package:tarefas_calendario/features/tarefas/data/repositories/tarefa_repository.dart';
import 'package:tarefas_calendario/features/tarefas/domain/usecases/busca_dias_com_registro_usecase.dart';
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
    final buscaDiasRegistro = BuscarDiasComRegistroUsecase(repository);
    _vm = TarefasViewModel(repository, buscaDiasRegistro);
    _vm.carregarMeta();
    _vm.selecionarDia(DateTime.now());
    _vm.carregarDiasDoMes(DateTime.now().month, DateTime.now().year);
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
            child: ListenableBuilder(
              listenable: _vm,
              builder: (context, child) {
                return CustomCalendarioWidget(
                  mesAtual: DateTime.now(),
                  diaSelecionado: (dia) => _vm.selecionarDia(dia),
                  diasComRegistro: _vm.diasComRegistro,
                  onMesAlterado: (mes, ano) => _vm.carregarDiasDoMes(mes, ano),
                );
              },
            ),
          ),
          Flexible(child: PainelTarefasWidget(vm: _vm)),
        ],
      ),
    );
  }
}
