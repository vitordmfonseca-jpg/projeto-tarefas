import 'package:flutter/material.dart';
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
  final TimesheetViewModel viewModel;

  const TimesheetPage({super.key, required this.viewModel});

  @override
  State<TimesheetPage> createState() => TimesheetPageState();
}

class TimesheetPageState extends State<TimesheetPage> {
  TimesheetViewModel get _vm => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _vm.init();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

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
