import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/tarefas/domain/repositories/i_tarefa_repository.dart';

class TarefasViewModel extends ChangeNotifier {
  final ITarefaRepository _repository;

  TarefasViewModel(this._repository);

  List<TarefaEntity> _tarefas = [];
  DateTime _diaSelecionado = DateTime.now();
  bool _carregando = false;
  int _metaMinutosDia = 530; // padrão: 8h50m

  List<TarefaEntity> get tarefas => _tarefas;
  DateTime get diaSelecionado => _diaSelecionado;
  bool get carregando => _carregando;
  int get metaMinutosDia => _metaMinutosDia;

  Future<void> carregarMeta() async {
    final prefs = await SharedPreferences.getInstance();
    final horas = prefs.getInt('meta_horas') ?? 8;
    final minutos = prefs.getInt('meta_minutos') ?? 50;
    _metaMinutosDia = (horas * 60) + minutos;
    notifyListeners();
  }

  int get totalMinutosDia {
    return _tarefas.fold(
      0,
      (soma, t) => soma + (t.horasGastas * 60) + t.minutosGastos,
    );
  }

  String get totalFormatadoDia {
    final horas = totalMinutosDia ~/ 60;
    final minutos = totalMinutosDia % 60;
    if (minutos == 0) return '${horas}h';
    return '${horas}h ${minutos}m';
  }

  Future<void> selecionarDia(DateTime dia) async {
    _diaSelecionado = dia;
    await _carregarTarefas();
  }

  Future<void> _carregarTarefas() async {
    _carregando = true;
    notifyListeners();

    _tarefas = await _repository.buscarPorDia(_diaSelecionado);
    _carregando = false;
    notifyListeners();
  }

  Future<void> salvar(TarefaEntity tarefa) async {
    await _repository.salvar(tarefa);
    await _carregarTarefas();
  }

  Future<void> deletar(int id) async {
    await _repository.deletar(id);
    await _carregarTarefas();
  }
}
