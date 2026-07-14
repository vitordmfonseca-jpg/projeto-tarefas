import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/utils/app_utils.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/timesheet/domain/enums/modo_timesheet.dart';
import 'package:tarefas_calendario/features/timesheet/domain/usecases/busca_tarefas_periodo_usecase.dart';
import 'package:tarefas_calendario/features/timesheet/domain/usecases/exportar_timesheet_usecase.dart';

class TimesheetViewModel extends ChangeNotifier {
  final BuscarTarefasPeriodoUsecase _buscarTarefas;
  final ExportarTimesheetUsecase _exportarTimesheet;

  ModoTimesheet _modo = ModoTimesheet.semanal;
  DateTime _referencia = DateTime.now();
  Map<DateTime, List<TarefaEntity>> _tarefasPorDia = {};
  bool _carregando = false;

  TimesheetViewModel({
    required BuscarTarefasPeriodoUsecase buscarTarefas,
    required ExportarTimesheetUsecase exportarTimesheet,
  }) : _buscarTarefas = buscarTarefas,
       _exportarTimesheet = exportarTimesheet;

  ModoTimesheet get modo => _modo;
  Map<DateTime, List<TarefaEntity>> get tarefasPorDia => _tarefasPorDia;
  bool get carregando => _carregando;

  DateTime get inicioPeriodo => _modo == ModoTimesheet.semanal
      ? AppDateUtils.inicioSemana(_referencia)
      : AppDateUtils.inicioDomes(_referencia);

  DateTime get fimPeriodo => _modo == ModoTimesheet.semanal
      ? AppDateUtils.fimSemana(_referencia)
      : AppDateUtils.fimDoMes(_referencia);

  int get totalMinutosPeriodo => _tarefasPorDia.values
      .expand((tarefas) => tarefas)
      .fold(0, (soma, t) => soma + (t.horasGastas * 60) + t.minutosGastos);

  String get totalFormatadoPeriodo {
    final horas = totalMinutosPeriodo ~/ 60;
    final minutos = totalMinutosPeriodo % 60;
    if (minutos == 0) return '${horas}h';
    if (horas == 0) return '${minutos}m';
    return '${horas}h ${minutos}m';
  }

  Future<void> init() async {
    await _carregarTarefas();
  }

  Future<void> alternarModo(ModoTimesheet modo) async {
    _modo = modo;
    _referencia = DateTime.now();
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

  String get tituloPeriodo {
    if (_modo == ModoTimesheet.semanal) {
      final inicio = inicioPeriodo;
      final fim = fimPeriodo;
      if (inicio.month == fim.month) {
        return '${inicio.day} - ${fim.day} de ${AppDateUtils.meses[inicio.month - 1]} de ${inicio.year}';
      }
      return '${inicio.day} ${AppDateUtils.meses[inicio.month - 1].substring(0, 3)} - ${fim.day} ${AppDateUtils.meses[fim.month - 1].substring(0, 3)} de ${fim.year}';
    }
    return AppDateUtils.formatarMesAno(inicioPeriodo);
  }

  Future<String?> exportarMd() => _exportarTimesheet(
    tarefasPorDia: _tarefasPorDia,
    inicioPeriodo: inicioPeriodo,
    fimPeriodo: fimPeriodo,
    modo: _modo,
    totalFormatado: totalFormatadoPeriodo,
  );

  List<DateTime> calcularDiasDoPeriodo() {
    final inicio = _modo == ModoTimesheet.mensal
        ? AppDateUtils.inicioGradeCalendario(_referencia)
        : inicioPeriodo;
    final fim = _modo == ModoTimesheet.mensal
        ? AppDateUtils.fimGradeCalendario(_referencia)
        : fimPeriodo;

    final dias = <DateTime>[];
    var dia = inicio;
    while (!dia.isAfter(fim)) {
      dias.add(dia);
      dia = dia.add(const Duration(days: 1));
    }
    return dias;
  }

  List<TarefaEntity> tarefasDoDia(DateTime dia) {
    final chave = DateTime(dia.year, dia.month, dia.day);
    return _tarefasPorDia[chave] ?? [];
  }

  Future<void> _carregarTarefas() async {
    _carregando = true;
    notifyListeners();

    _tarefasPorDia = await _buscarTarefas(inicioPeriodo, fimPeriodo);

    _carregando = false;
    notifyListeners();
  }
}
