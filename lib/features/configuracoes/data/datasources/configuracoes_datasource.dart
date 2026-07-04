import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfiguracoesDatasource {
  static const _keyThemeMode = 'theme_mode';
  static const _keyMetaHoras = 'meta_horas';
  static const _keyMetaMinutos = 'meta_minutos';

  Future<Map<String, dynamic>> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'themeMode': prefs.getInt(_keyThemeMode) ?? 0,
      'metaHoras': prefs.getInt(_keyMetaHoras) ?? 8,
      'metaMinutos': prefs.getInt(_keyMetaMinutos) ?? 50,
    };
  }

  Future<void> salvar({
    required int themeMode,
    required int metaHoras,
    required int metaMinutos,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, themeMode);
    await prefs.setInt(_keyMetaHoras, metaHoras);
    await prefs.setInt(_keyMetaMinutos, metaMinutos);
  }

  Future<String> caminhoDb() async {
    final dbPath = await getDatabasesPath();
    return join(dbPath, 'tarefas.db');
  }

  Future<String> getDatabasesPath() async {
    final dir = await getApplicationSupportDirectory();
    return dir.path;
  }
}
