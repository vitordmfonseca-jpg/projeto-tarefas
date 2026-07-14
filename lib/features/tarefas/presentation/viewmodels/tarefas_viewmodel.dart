import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/tarefas/domain/repositories/i_tarefa_repository.dart';
import 'package:tarefas_calendario/features/tarefas/domain/usecases/busca_dias_com_registro_usecase.dart';

class TarefasViewModel extends ChangeNotifier {
  final ITarefaRepository _repository;
  final BuscarDiasComRegistroUsecase _buscarDiasComRegistro;

  TarefasViewModel(this._repository, this._buscarDiasComRegistro);

  List<TarefaEntity> _tarefas = [];
  DateTime _diaSelecionado = DateTime.now();
  Set<DateTime> _diasComRegistro = {};
  bool _carregando = false;
  int _metaMinutosDia = 530;

  List<TarefaEntity> get tarefas => _tarefas;
  DateTime get diaSelecionado => _diaSelecionado;
  Set<DateTime> get diasComRegistro => _diasComRegistro;
  bool get carregando => _carregando;
  int get metaMinutosDia => _metaMinutosDia;

  int get totalMinutosDia => _tarefas.fold(
    0,
    (soma, t) => soma + (t.horasGastas * 60) + t.minutosGastos,
  );

  String get totalFormatadoDia {
    final horas = totalMinutosDia ~/ 60;
    final minutos = totalMinutosDia % 60;
    if (minutos == 0) return '${horas}h';
    return '${horas}h ${minutos}m';
  }

  double get progressoMeta =>
      (totalMinutosDia / metaMinutosDia).clamp(0.0, 1.0);

  bool get bateuMeta => totalMinutosDia >= metaMinutosDia;

  String get textoMeta {
    if (bateuMeta) return 'Meta atingida!';
    final minutosRestantes = metaMinutosDia - totalMinutosDia;
    final horasRest = minutosRestantes ~/ 60;
    final minRest = minutosRestantes % 60;
    return 'Faltam ${horasRest > 0 ? '${horasRest}h ' : ''}${minRest}m';
  }

  Future<void> carregarMeta() async {
    final prefs = await SharedPreferences.getInstance();
    final horas = prefs.getInt('meta_horas') ?? 8;
    final minutos = prefs.getInt('meta_minutos') ?? 50;
    _metaMinutosDia = (horas * 60) + minutos;
    notifyListeners();
  }

  Future<void> selecionarDia(DateTime dia) async {
    _diaSelecionado = dia;
    await _carregarTarefas();
  }

  Future<void> carregarDiasDoMes(int mes, int ano) async {
    _diasComRegistro = await _buscarDiasComRegistro(mes, ano);
    notifyListeners();
  }

  Future<void> salvar(TarefaEntity tarefa) async {
    await _repository.salvar(tarefa);
    await Future.wait([
      _carregarTarefas(),
      carregarDiasDoMes(_diaSelecionado.month, _diaSelecionado.year),
    ]);
  }

  Future<void> deletar(int id) async {
    await _repository.deletar(id);
    await Future.wait([
      _carregarTarefas(),
      carregarDiasDoMes(_diaSelecionado.month, _diaSelecionado.year),
    ]);
  }

  Future<void> _carregarTarefas() async {
    _carregando = true;
    notifyListeners();

    _tarefas = await _repository.buscarPorDia(_diaSelecionado);
    _carregando = false;
    notifyListeners();
  }
}
