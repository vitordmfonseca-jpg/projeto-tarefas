import 'package:tarefas_calendario/features/configuracoes/data/datasources/configuracoes_datasource.dart';
import 'package:tarefas_calendario/features/configuracoes/domain/entities/configuracoes_entity.dart';
import 'package:tarefas_calendario/features/configuracoes/domain/enums/app_theme_mode.dart';
import 'package:tarefas_calendario/features/configuracoes/domain/repositories/i_configuracoes_repository.dart';

class ConfiguracoesRepository implements IConfiguracoesRepository {
  final ConfiguracoesDatasource _datasource;

  ConfiguracoesRepository(this._datasource);

  // Converte int salvo no banco para AppThemeMode
  AppThemeMode _toAppThemeMode(int value) => switch (value) {
    1 => AppThemeMode.claro,
    2 => AppThemeMode.escuro,
    _ => AppThemeMode.sistema,
  };

  // Converte AppThemeMode para int para salvar no banco
  int _fromAppThemeMode(AppThemeMode mode) => switch (mode) {
    AppThemeMode.claro => 1,
    AppThemeMode.escuro => 2,
    AppThemeMode.sistema => 0,
  };

  @override
  Future<ConfiguracoesEntity> carregar() async {
    final data = await _datasource.carregar();
    return ConfiguracoesEntity(
      themeMode: _toAppThemeMode(data['themeMode'] as int),
      metaHoras: data['metaHoras'] as int,
      metaMinutos: data['metaMinutos'] as int,
    );
  }

  @override
  Future<void> salvar(ConfiguracoesEntity configuracoes) async {
    await _datasource.salvar(
      themeMode: _fromAppThemeMode(configuracoes.themeMode),
      metaHoras: configuracoes.metaHoras,
      metaMinutos: configuracoes.metaMinutos,
    );
  }

  @override
  Future<String> caminhoDb() => _datasource.caminhoDb();
}
