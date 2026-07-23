import 'package:tarefas_calendario/features/configuracoes/data/datasources/configuracoes_datasource.dart';
import 'package:tarefas_calendario/features/configuracoes/domain/entities/configuracoes_entity.dart';
import 'package:tarefas_calendario/features/configuracoes/domain/enums/app_theme_mode.dart';
import 'package:tarefas_calendario/features/configuracoes/domain/repositories/i_configuracoes_repository.dart';

class ConfiguracoesRepository implements IConfiguracoesRepository {
  final ConfiguracoesDatasource _datasource;

  ConfiguracoesRepository(this._datasource);

  @override
  Future<ConfiguracoesEntity> carregar() async {
    final data = await _datasource.carregar();
    return ConfiguracoesEntity(
      themeMode: AppThemeMode.fromInt(data['themeMode'] as int),
      metaHoras: data['metaHoras'] as int,
      metaMinutos: data['metaMinutos'] as int,
    );
  }

  @override
  Future<void> salvar(ConfiguracoesEntity configuracoes) async {
    await _datasource.salvar(
      themeMode: configuracoes.themeMode.codigo,
      metaHoras: configuracoes.metaHoras,
      metaMinutos: configuracoes.metaMinutos,
    );
  }

  @override
  Future<String> caminhoDb() => _datasource.caminhoDb();
}
