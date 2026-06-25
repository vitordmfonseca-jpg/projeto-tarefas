import 'package:flutter/material.dart';

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

  void diasDoMes(DateTime mesAtual) {
    //Salva o mes inicial
    _mesAtual = mesAtual;

    //Obtem o primeiro dia do mes
    final primeiroDia = DateTime(mesAtual.year, mesAtual.month, 1);

    //Obtem o dia da semana do primeiro dia do mes
    final diaSemana = primeiroDia.weekday;

    //Obtem o espaço em branco antes do primeiro dia do mes
    final espacoDia = diaSemana - 1;

    _diasMes = [];

    //Usei o calendario do windows como base, que tem 6 semanas com 7 dias cada = 42 quadrados
    for (var i = 0; i < 42; i++) {
      final dia = i - espacoDia + 1;

      _diasMes.add(DateTime(mesAtual.year, mesAtual.month, dia));
    }

    notifyListeners();
  }
}
