import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/utils/app_utils.dart';

class CustomCalendarioViewmodel extends ChangeNotifier {
  final diasSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'];

  var _diasMes = <DateTime>[];
  var _mesAtual = DateTime.now();
  DateTime? _diaSelecionado;

  List<DateTime> get diasMes => _diasMes;
  DateTime get mesAtual => _mesAtual;
  DateTime? get diaSelecionado => _diaSelecionado;

  set diaSelecionado(DateTime valor) {
    _diaSelecionado = valor;
    notifyListeners();
  }

  void mesAnterior() {
    _mesAtual = DateTime(_mesAtual.year, _mesAtual.month - 1, 1);
    diasDoMes(_mesAtual);
  }

  void proxMes() {
    _mesAtual = DateTime(_mesAtual.year, _mesAtual.month + 1, 1);
    diasDoMes(_mesAtual);
  }

  void irParaHoje() {
    final hoje = DateTime.now();
    _diaSelecionado = hoje;
    diasDoMes(hoje);
  }

  void diasDoMes(DateTime mesAtual) {
    _mesAtual = mesAtual;
    final inicioGrade = AppDateUtils.inicioGradeCalendario(mesAtual);

    _diasMes = List.generate(
      42,
      (i) => inicioGrade.add(Duration(days: i)),
    );

    notifyListeners();
  }
}
