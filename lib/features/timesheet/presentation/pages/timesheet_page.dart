import 'package:flutter/material.dart';
import 'package:tarefas_calendario/features/tarefas/data/database_helper.dart';
import 'package:tarefas_calendario/features/tarefas/data/datasources/tarefa_datasource.dart';
import 'package:tarefas_calendario/features/tarefas/data/repositories/tarefa_repository.dart';
import 'package:tarefas_calendario/features/timesheet/presentation/viewmodels/timesheet_viewmodel.dart';
import 'package:tarefas_calendario/features/timesheet/presentation/widgets/timesheet_grade_widget.dart';
import 'package:tarefas_calendario/features/timesheet/presentation/widgets/timesheet_header_widget.dart';

class _RodapeTotalWidget extends StatelessWidget {
  final TimesheetViewModel vm;

  const _RodapeTotalWidget({required this.vm});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Total do período:',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            vm.totalFormatadoPeriodo,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class TimesheetPage extends StatefulWidget {
  const TimesheetPage({super.key});

  @override
  State<TimesheetPage> createState() => TimesheetPageState();
}

class TimesheetPageState extends State<TimesheetPage> {
  late final TimesheetViewModel _vm;

  @override
  void initState() {
    super.initState();
    final dbHelper = DatabaseHelper.instance;
    final datasource = TarefaDatasource(dbHelper);
    final repository = TarefaRepository(datasource);
    _vm = TimesheetViewModel(repository);
    _vm.init();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  // Chamado pela HomePage ao selecionar a aba do Timesheet
  Future<void> refresh() => _vm.init();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _vm,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TimesheetHeaderWidget(vm: _vm),
            const Divider(height: 15),
            Expanded(
              child: _vm.carregando
                  ? const Center(child: CircularProgressIndicator())
                  : TimesheetGradeWidget(vm: _vm),
            ),
            _RodapeTotalWidget(vm: _vm),
          ],
        );
      },
    );
  }
}
