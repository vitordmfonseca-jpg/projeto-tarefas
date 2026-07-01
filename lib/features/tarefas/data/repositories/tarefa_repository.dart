import 'package:tarefas_calendario/features/tarefas/data/datasources/tarefa_datasource.dart';
import 'package:tarefas_calendario/features/tarefas/data/dto/tarefa_dto.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/tarefas/domain/repositories/i_tarefa_repository.dart';

class TarefaRepository implements ITarefaRepository {
  final TarefaDatasource _datasource;

  TarefaRepository(this._datasource);

  @override
  Future<List<TarefaEntity>> buscarPorDia(DateTime dia) async {
    final dataStr =
        '${dia.year}-${dia.month.toString().padLeft(2, '0')}-${dia.day.toString().padLeft(2, '0')}';

    final dtos = await _datasource.buscarPorDia(dataStr);
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
