import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/tarefas/domain/repositories/i_tarefa_repository.dart';

class BuscarTarefasPeriodoUsecase {
  final ITarefaRepository _repository;

  BuscarTarefasPeriodoUsecase(this._repository);

  /// Busca as tarefas do período e retorna agrupadas por dia
  Future<Map<DateTime, List<TarefaEntity>>> call(
    DateTime inicio,
    DateTime fim,
  ) async {
    final tarefas = await _repository.buscarPorPeriodo(inicio, fim);

    final mapa = <DateTime, List<TarefaEntity>>{};
    for (final tarefa in tarefas) {
      final dia = DateTime(
        tarefa.data.year,
        tarefa.data.month,
        tarefa.data.day,
      );
      mapa.putIfAbsent(dia, () => []).add(tarefa);
    }

    return mapa;
  }
}
