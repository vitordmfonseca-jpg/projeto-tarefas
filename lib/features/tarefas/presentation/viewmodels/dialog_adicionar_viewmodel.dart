import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/utils/duracao_utils.dart';
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
    return DuracaoUtils.formatar((horas * 60) + minutos);
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

  bool _falhaValidacao(String mensagem) {
    erro = mensagem;
    notifyListeners();
    return false;
  }

  bool validar() {
    if (tituloCtrl.text.trim().isEmpty) {
      return _falhaValidacao('Informe o título da tarefa');
    }

    final horas = horasCtrl.text.isEmpty ? 0 : int.tryParse(horasCtrl.text);
    final minutos = minutosCtrl.text.isEmpty
        ? 0
        : int.tryParse(minutosCtrl.text);

    if (horas == null || horas < 0) {
      return _falhaValidacao('Informe um valor válido para horas');
    }

    if (minutos == null || minutos < 0 || minutos > 59) {
      return _falhaValidacao('Minutos deve ser entre 0 e 59');
    }

    if (horas == 0 && minutos == 0) {
      return _falhaValidacao('Informe pelo menos alguns minutos gastos');
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
