import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/extensions/ext_build_context.dart';
import 'package:tarefas_calendario/features/timesheet/domain/enums/modo_timesheet.dart';
import 'package:tarefas_calendario/features/timesheet/presentation/viewmodels/timesheet_viewmodel.dart';

class TimesheetHeaderWidget extends StatelessWidget {
  final TimesheetViewModel vm;

  const TimesheetHeaderWidget({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        children: [
          IconButton(
            onPressed: vm.voltarPeriodo,
            icon: const Icon(Icons.arrow_back_ios, size: 16),
            tooltip: 'Período anterior',
          ),
          IconButton(
            onPressed: vm.avancarPeriodo,
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            tooltip: 'Próximo período',
          ),
          const SizedBox(width: 8),
          Text(
            vm.tituloPeriodo,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 12),
          // Botão "Hoje" usa secondary
          OutlinedButton(
            onPressed: vm.irParaHoje,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: colorScheme.secondary,
              side: BorderSide(
                color: colorScheme.secondary.withValues(alpha: 0.6),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: Text('Hoje', style: TextStyle(fontSize: 12)),
            ),
          ),
          const Spacer(),

          IconButton(
            onPressed: () async {
              final caminho = await vm.exportarMd();
              if (!context.mounted) return;
              context.mostrarSnackBar(
                caminho != null ? 'Exportado para Downloads!' : 'Erro ao exportar.',
              );
            },
            icon: const Icon(Icons.download_outlined, size: 20),
            tooltip: 'Exportar como Markdown',
          ),
          const SizedBox(width: 8),

          SegmentedButton<ModoTimesheet>(
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: colorScheme.primary,
              selectedForegroundColor: colorScheme.onPrimary,
              foregroundColor: colorScheme.onSurface.withValues(alpha: 0.6),
              side: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            segments: const [
              ButtonSegment(
                value: ModoTimesheet.semanal,
                label: Text('Semana'),
                icon: Icon(Icons.view_week_outlined, size: 16),
              ),
              ButtonSegment(
                value: ModoTimesheet.mensal,
                label: Text('Mês'),
                icon: Icon(Icons.calendar_month_outlined, size: 16),
              ),
            ],
            selected: {vm.modo},
            onSelectionChanged: (s) => vm.alternarModo(s.first),
          ),
        ],
      ),
    );
  }
}
