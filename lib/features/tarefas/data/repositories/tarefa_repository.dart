import 'package:tarefas_calendario/features/tarefas/data/datasources/tarefa_datasource.dart';
import 'package:tarefas_calendario/features/tarefas/data/dto/tarefa_dto.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/tarefas/domain/repositories/i_tarefa_repository.dart';

class TarefaRepository implements ITarefaRepository {
  final TarefaDatasource _datasource;

  TarefaRepository(this._datasource);

  String _formatarData(DateTime data) =>
      '${data.year}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}';

  @override
  Future<List<TarefaEntity>> buscarPorDia(DateTime dia) async {
    final dtos = await _datasource.buscarPorDia(_formatarData(dia));
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<TarefaEntity>> buscarPorPeriodo(
    DateTime inicio,
    DateTime fim,
  ) async {
    final dtos = await _datasource.buscarPorPeriodo(
      _formatarData(inicio),
      _formatarData(fim),
    );
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> salvar(TarefaEntity tarefa) async {
    final dto = TarefaDto.fromEntity(tarefa);
    if (tarefa.id == null) {
      await _datasource.inserir(dto);
    } else {
      await _datasource.atualizar(dto);
    }
  }

  @override
  Future<void> deletar(int id) async {
    await _datasource.deletar(id);
  }
}
