import 'package:flutter/material.dart';
import 'package:tarefas_calendario/features/configuracoes/data/datasources/configuracoes_datasource.dart';
import 'package:tarefas_calendario/features/configuracoes/domain/entities/configuracoes_entity.dart';
import 'package:tarefas_calendario/features/configuracoes/domain/repositories/i_configuracoes_repository.dart';

class ConfiguracoesRepository implements IConfiguracoesRepository {
  final ConfiguracoesDatasource _datasource;

  ConfiguracoesRepository(this._datasource);

  // Converte int salvo no banco para ThemeMode do Flutter
  ThemeMode _toThemeMode(int value) => switch (value) {
    1 => ThemeMode.light,
    2 => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  // Converte ThemeMode para int para salvar no banco
  int _fromThemeMode(ThemeMode mode) => switch (mode) {
    ThemeMode.light => 1,
    ThemeMode.dark => 2,
    _ => 0,
  };

  @override
  Future<ConfiguracoesEntity> carregar() async {
    final data = await _datasource.carregar();
    return ConfiguracoesEntity(
      themeMode: _toThemeMode(data['themeMode'] as int),
      metaHoras: data['metaHoras'] as int,
      metaMinutos: data['metaMinutos'] as int,
    );
  }

  @override
  Future<void> salvar(ConfiguracoesEntity configuracoes) async {
    await _datasource.salvar(
      themeMode: _fromThemeMode(configuracoes.themeMode),
      metaHoras: configuracoes.metaHoras,
      metaMinutos: configuracoes.metaMinutos,
    );
  }

  @override
  Future<String> caminhoDb() => _datasource.caminhoDb();
}
