import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarefas_calendario/core/utils/duracao_utils.dart';
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
  String? _erro;
  int _metaMinutosDia = 530;

  List<TarefaEntity> get tarefas => _tarefas;
  DateTime get diaSelecionado => _diaSelecionado;
  Set<DateTime> get diasComRegistro => _diasComRegistro;
  bool get carregando => _carregando;
  String? get erro => _erro;
  int get metaMinutosDia => _metaMinutosDia;

  int get totalMinutosDia =>
      _tarefas.fold(0, (soma, t) => soma + t.minutosTotais);

  String get totalFormatadoDia => DuracaoUtils.formatar(totalMinutosDia);

  void _setCarregando(bool valor) {
    _carregando = valor;
    notifyListeners();
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
    try {
      _diasComRegistro = await _buscarDiasComRegistro(mes, ano);
      _erro = null;
    } catch (_) {
      _erro = 'Não foi possível carregar os dias com tarefas registradas';
    }
    notifyListeners();
  }

  Future<bool> salvar(TarefaEntity tarefa) async {
    try {
      await _repository.salvar(tarefa);
    } catch (_) {
      _erro = 'Não foi possível salvar a tarefa';
      notifyListeners();
      return false;
    }
    await Future.wait([
      _carregarTarefas(),
      carregarDiasDoMes(_diaSelecionado.month, _diaSelecionado.year),
    ]);
    return true;
  }

  Future<bool> deletar(int id) async {
    try {
      await _repository.deletar(id);
    } catch (_) {
      _erro = 'Não foi possível excluir a tarefa';
      notifyListeners();
      return false;
    }
    await Future.wait([
      _carregarTarefas(),
      carregarDiasDoMes(_diaSelecionado.month, _diaSelecionado.year),
    ]);
    return true;
  }

  Future<void> _carregarTarefas() async {
    _setCarregando(true);
    try {
      _tarefas = await _repository.buscarPorDia(_diaSelecionado);
      _erro = null;
    } catch (_) {
      _erro = 'Não foi possível carregar as tarefas do dia';
    } finally {
      _setCarregando(false);
    }
  }
}
