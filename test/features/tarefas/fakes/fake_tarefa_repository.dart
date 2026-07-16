import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/tarefas/domain/repositories/i_tarefa_repository.dart';

class FakeTarefaRepository implements ITarefaRepository {
  FakeTarefaRepository({List<TarefaEntity> tarefas = const []})
    : _tarefas = List.of(tarefas);

  final List<TarefaEntity> _tarefas;

  bool lancarErroAoBuscar = false;
  bool lancarErroAoSalvar = false;

  bool _mesmoDia(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Future<List<TarefaEntity>> buscarPorDia(DateTime dia) async {
    if (lancarErroAoBuscar) throw Exception('falha simulada ao buscar');
    return _tarefas.where((t) => _mesmoDia(t.data, dia)).toList();
  }

  @override
  Future<List<TarefaEntity>> buscarPorPeriodo(
    DateTime inicio,
    DateTime fim,
  ) async {
    if (lancarErroAoBuscar) throw Exception('falha simulada ao buscar');
    return _tarefas
        .where((t) => !t.data.isBefore(inicio) && !t.data.isAfter(fim))
        .toList();
  }

  @override
  Future<void> salvar(TarefaEntity tarefa) async {
    if (lancarErroAoSalvar) throw Exception('falha simulada ao salvar');
    _tarefas.add(tarefa);
  }

  @override
  Future<void> deletar(int id) async {
    _tarefas.removeWhere((t) => t.id == id);
  }
}
