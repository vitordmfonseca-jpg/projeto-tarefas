import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:tarefas_calendario/core/utils/app_utils.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/timesheet/domain/enums/modo_timesheet.dart';

class ExportarTimesheetUsecase {
  /// Monta o conteúdo Markdown e salva em Downloads
  Future<String?> call({
    required Map<DateTime, List<TarefaEntity>> tarefasPorDia,
    required DateTime inicioPeriodo,
    required DateTime fimPeriodo,
    required ModoTimesheet modo,
    required String totalFormatado,
  }) async {
    try {
      final buffer = StringBuffer();

      // Título
      final titulo = modo == ModoTimesheet.semanal
          ? '# Semana ${AppDateUtils.formatarDiaMes(inicioPeriodo)} - ${AppDateUtils.formatarDiaMes(fimPeriodo)} de ${fimPeriodo.year}'
          : '# ${AppDateUtils.formatarMesAno(inicioPeriodo)}';

      buffer.writeln(titulo);
      buffer.writeln('**Total: $totalFormatado**');
      buffer.writeln();

      // Itera os dias do período
      var dia = inicioPeriodo;
      while (!dia.isAfter(fimPeriodo)) {
        final chave = DateTime(dia.year, dia.month, dia.day);
        final tarefas = tarefasPorDia[chave] ?? [];

        buffer.writeln('## ${AppDateUtils.formatarDiaCurto(dia)}');

        if (tarefas.isEmpty) {
          buffer.writeln('_Sem registros_');
        } else {
          for (final t in tarefas) {
            final horas = t.horasGastas == 0 ? '' : '${t.horasGastas}h ';
            final minutos = t.minutosGastos == 0 ? '' : '${t.minutosGastos}m';
            buffer.writeln('- $horas$minutos— ${t.titulo}');
          }
        }
        buffer.writeln();
        dia = dia.add(const Duration(days: 1));
      }

      // Salva em Downloads
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) return null;

      final nomeArquivo = modo == ModoTimesheet.semanal
          ? 'timesheet_semana_${inicioPeriodo.year}-${inicioPeriodo.month.toString().padLeft(2, '0')}-${inicioPeriodo.day.toString().padLeft(2, '0')}.md'
          : 'timesheet_mes_${inicioPeriodo.year}-${inicioPeriodo.month.toString().padLeft(2, '0')}.md';

      final arquivo = File('${downloadsDir.path}/$nomeArquivo');
      await arquivo.writeAsString(buffer.toString());

      return arquivo.path;
    } catch (_) {
      return null;
    }
  }
}
