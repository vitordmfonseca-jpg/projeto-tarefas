import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/ui_components/calendario/custom_calendario_widget.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/actions/tarefas_action.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/viewmodels/tarefas_viewmodel.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/widgets/painel_tarefas_widget.dart';

class TarefasPage extends StatefulWidget {
  final TarefasViewModel viewModel;
  final TarefasAction action;

  const TarefasPage({super.key, required this.viewModel, required this.action});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  TarefasViewModel get _vm => widget.viewModel;

  @override
  void initState() {
    super.initState();
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
          Flexible(
            child: PainelTarefasWidget(vm: _vm, action: widget.action),
          ),
        ],
      ),
    );
  }
}
