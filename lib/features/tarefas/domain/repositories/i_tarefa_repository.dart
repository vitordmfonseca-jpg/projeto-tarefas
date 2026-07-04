import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';

abstract interface class ITarefaRepository {
  Future<List<TarefaEntity>> buscarPorDia(DateTime dia);
  Future<List<TarefaEntity>> buscarPorPeriodo(DateTime inicio, DateTime fim);
  Future<void> salvar(TarefaEntity tarefa);
  Future<void> deletar(int id);
}
