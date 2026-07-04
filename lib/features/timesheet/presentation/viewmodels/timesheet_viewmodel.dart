import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tarefas_calendario/core/utils/date_utils.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/tarefas/domain/repositories/i_tarefa_repository.dart';

enum ModoTimesheet { semanal, mensal }

class TimesheetViewModel extends ChangeNotifier {
  final ITarefaRepository _repository;

  TimesheetViewModel(this._repository);

  ModoTimesheet _modo = ModoTimesheet.semanal;
  DateTime _referencia = DateTime.now();
  Map<DateTime, List<TarefaEntity>> _tarefasPorDia = {};
  bool _carregando = false;

  ModoTimesheet get modo => _modo;
  Map<DateTime, List<TarefaEntity>> get tarefasPorDia => _tarefasPorDia;
  bool get carregando => _carregando;

  DateTime get inicioPeriodo => _modo == ModoTimesheet.semanal
      ? AppDateUtils.inicioSemana(_referencia)
      : AppDateUtils.inicioDomes(_referencia);

  DateTime get fimPeriodo => _modo == ModoTimesheet.semanal
      ? AppDateUtils.fimSemana(_referencia)
      : AppDateUtils.fimDoMes(_referencia);

  int get totalMinutosPeriodo => tarefasPorDia.values
      .expand((tarefas) => tarefas)
      .fold(0, (soma, t) => soma + (t.horasGastas * 60) + t.minutosGastos);

  String get totalFormatadoPeriodo {
    final horas = totalMinutosPeriodo ~/ 60;
    final minutos = totalMinutosPeriodo % 60;
    if (minutos == 0) return '${horas}h';
    if (horas == 0) return '${minutos}m';
    return '${horas}h ${minutos}m';
  }

  set carregando(bool valor) {
    _carregando = valor;
    notifyListeners();
  }

  Future<void> init() async {
    await _carregarTarefas();
  }

  Future<void> alternarModo(ModoTimesheet modo) async {
    _modo = modo;
    await _carregarTarefas();
  }

  Future<void> avancarPeriodo() async {
    _referencia = _modo == ModoTimesheet.semanal
        ? _referencia.add(const Duration(days: 7))
        : DateTime(_referencia.year, _referencia.month + 1, 1);
    await _carregarTarefas();
  }

  Future<void> voltarPeriodo() async {
    _referencia = _modo == ModoTimesheet.semanal
        ? _referencia.subtract(const Duration(days: 7))
        : DateTime(_referencia.year, _referencia.month - 1, 1);
    await _carregarTarefas();
  }

  Future<void> irParaHoje() async {
    _referencia = DateTime.now();
    await _carregarTarefas();
  }

  Future<String?> exportarMd() async {
    try {
      final buffer = StringBuffer();

      // Título e total
      final titulo = modo == ModoTimesheet.semanal
          ? '# Semana ${AppDateUtils.formatarDiaMes(inicioPeriodo)} - ${AppDateUtils.formatarDiaMes(fimPeriodo)} de ${fimPeriodo.year}'
          : '# ${AppDateUtils.formatarMesAno(inicioPeriodo)}';

      buffer.writeln(titulo);
      buffer.writeln('**Total: $totalFormatadoPeriodo**');
      buffer.writeln();

      // Dias do período
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

  Future<void> _carregarTarefas() async {
    carregando = true;

    final tarefas = await _repository.buscarPorPeriodo(
      inicioPeriodo,
      fimPeriodo,
    );

    // Agrupa as tarefas por dia zerando hora/minuto/segundo para comparação correta
    final mapa = <DateTime, List<TarefaEntity>>{};
    for (final tarefa in tarefas) {
      final dia = DateTime(
        tarefa.data.year,
        tarefa.data.month,
        tarefa.data.day,
      );
      mapa.putIfAbsent(dia, () => []).add(tarefa);
    }

    _tarefasPorDia = mapa;
    carregando = false;
  }
}
