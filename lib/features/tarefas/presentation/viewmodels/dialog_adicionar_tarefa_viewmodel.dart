import 'package:flutter/material.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';

class DialogAdicionarTarefaViewModel extends ChangeNotifier {
  String? erro;

  bool validar({
    required String titulo,
    required String horas,
    required String minutos,
  }) {
    if (titulo.trim().isEmpty) {
      erro = 'Informe o título da tarefa';
      notifyListeners();
      return false;
    }

    final horasInt = int.tryParse(horas.isEmpty ? '0' : horas);
    final minutosInt = int.tryParse(minutos.isEmpty ? '0' : minutos);

    if (horasInt == null || horasInt < 0) {
      erro = 'Informe um valor válido para horas';
      notifyListeners();
      return false;
    }

    if (minutosInt == null || minutosInt < 0 || minutosInt > 59) {
      erro = 'Minutos deve ser entre 0 e 59';
      notifyListeners();
      return false;
    }

    if (horasInt == 0 && minutosInt == 0) {
      erro = 'Informe pelo menos alguns minutos gastos';
      notifyListeners();
      return false;
    }

    erro = null;
    notifyListeners();
    return true;
  }

  TarefaEntity montar({
    required String titulo,
    required String descricao,
    required String horas,
    required String minutos,
    required DateTime dia,
    int? id,
  }) {
    return TarefaEntity(
      id: id,
      titulo: titulo.trim(),
      descricao: descricao.trim().isEmpty ? null : descricao.trim(),
      data: dia,
      horasGastas: int.tryParse(horas) ?? 0,
      minutosGastos: int.tryParse(minutos) ?? 0,
    );
  }
}
