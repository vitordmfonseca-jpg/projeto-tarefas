import 'package:tarefas_calendario/features/tarefas/data/database_helper.dart';
import 'package:tarefas_calendario/features/tarefas/data/dto/tarefa_dto.dart';

class TarefaDatasource {
  final DatabaseHelper _dbHelper;

  TarefaDatasource(this._dbHelper) {
    _initTabela();
  }

  Future<void> _initTabela() async {
    final db = await _dbHelper.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tarefas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descricao TEXT,
        data TEXT NOT NULL,
        horas_gastas INTEGER NOT NULL DEFAULT 0,
        minutos_gastos INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<List<TarefaDto>> buscarPorDia(String data) async {
    final db = await _dbHelper.database;
    final resultado = await db.query(
      'tarefas',
      where: 'data = ?',
      whereArgs: [data],
      orderBy: 'id ASC',
    );
    return resultado.map((map) => TarefaDto.fromMap(map)).toList();
  }

  Future<void> inserir(TarefaDto dto) async {
    final db = await _dbHelper.database;
    await db.insert('tarefas', dto.toMap());
  }

  Future<void> atualizar(TarefaDto dto) async {
    final db = await _dbHelper.database;
    await db.update(
      'tarefas',
      dto.toMap(),
      where: 'id = ?',
      whereArgs: [dto.id],
    );
  }

  Future<void> deletar(int id) async {
    final db = await _dbHelper.database;
    await db.delete('tarefas', where: 'id = ?', whereArgs: [id]);
  }
}
