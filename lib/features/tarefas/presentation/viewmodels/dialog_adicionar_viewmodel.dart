import 'package:flutter/material.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';

class DialogAdicionarTarefaViewModel extends ChangeNotifier {
  final tituloCtrl = TextEditingController();
  final descricaoCtrl = TextEditingController();
  final horasCtrl = TextEditingController();
  final minutosCtrl = TextEditingController();

  String? erro;

  String get tempoFormatado {
    final horas = int.tryParse(horasCtrl.text) ?? 0;
    final minutos = int.tryParse(minutosCtrl.text) ?? 0;
    if (horas == 0 && minutos == 0) return '—';
    if (horas == 0) return '${minutos}m';
    if (minutos == 0) return '${horas}h';
    return '${horas}h ${minutos}m';
  }

  void inicializar(TarefaEntity? tarefa) {
    tituloCtrl.text = tarefa?.titulo ?? '';
    descricaoCtrl.text = tarefa?.descricao ?? '';
    horasCtrl.text = tarefa != null && tarefa.horasGastas > 0
        ? '${tarefa.horasGastas}'
        : '';
    minutosCtrl.text = tarefa != null && tarefa.minutosGastos > 0
        ? '${tarefa.minutosGastos}'
        : '';
  }

  bool validar() {
    if (tituloCtrl.text.trim().isEmpty) {
      erro = 'Informe o título da tarefa';
      notifyListeners();
      return false;
    }

    final horas = horasCtrl.text.isEmpty ? 0 : int.tryParse(horasCtrl.text);
    final minutos = minutosCtrl.text.isEmpty
        ? 0
        : int.tryParse(minutosCtrl.text);

    if (horas == null || horas < 0) {
      erro = 'Informe um valor válido para horas';
      notifyListeners();
      return false;
    }

    if (minutos == null || minutos < 0 || minutos > 59) {
      erro = 'Minutos deve ser entre 0 e 59';
      notifyListeners();
      return false;
    }

    if (horas == 0 && minutos == 0) {
      erro = 'Informe pelo menos alguns minutos gastos';
      notifyListeners();
      return false;
    }

    erro = null;
    notifyListeners();
    return true;
  }

  TarefaEntity montar({required DateTime dia, int? id}) {
    return TarefaEntity(
      id: id,
      titulo: tituloCtrl.text.trim(),
      descricao: descricaoCtrl.text.trim().isEmpty
          ? null
          : descricaoCtrl.text.trim(),
      data: dia,
      horasGastas: int.tryParse(horasCtrl.text) ?? 0,
      minutosGastos: int.tryParse(minutosCtrl.text) ?? 0,
    );
  }

  @override
  void dispose() {
    tituloCtrl.dispose();
    descricaoCtrl.dispose();
    horasCtrl.dispose();
    minutosCtrl.dispose();
    super.dispose();
  }
}
