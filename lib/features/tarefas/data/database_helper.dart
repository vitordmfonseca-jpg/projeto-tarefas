import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final appSupportDir = await getApplicationSupportDirectory();

    final path = join(appSupportDir.path, 'tarefas.db');

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(version: 1),
    );
  }

  Future<void> fecharBanco() async {
    await _database?.close();
    _database = null;
  }
}
