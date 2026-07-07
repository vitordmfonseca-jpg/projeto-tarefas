import 'package:tarefas_calendario/core/utils/app_utils.dart';
import 'package:tarefas_calendario/features/tarefas/domain/repositories/i_tarefa_repository.dart';

class BuscarDiasComRegistroUsecase {
  final ITarefaRepository _repository;

  BuscarDiasComRegistroUsecase(this._repository);

  Future<Set<DateTime>> call(int mes, int ano) async {
    final inicio = AppDateUtils.inicioDomes(DateTime(ano, mes));
    final fim = AppDateUtils.fimDoMes(DateTime(ano, mes));

    final tarefas = await _repository.buscarPorPeriodo(inicio, fim);

    return tarefas
        .map((t) => DateTime(t.data.year, t.data.month, t.data.day))
        .toSet();
  }
}
