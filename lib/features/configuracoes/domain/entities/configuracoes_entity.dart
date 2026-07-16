import 'package:tarefas_calendario/features/configuracoes/domain/enums/app_theme_mode.dart';

class ConfiguracoesEntity {
  final AppThemeMode themeMode;
  final int metaHoras;
  final int metaMinutos;

  const ConfiguracoesEntity({
    this.themeMode = AppThemeMode.sistema,
    this.metaHoras = 8,
    this.metaMinutos = 50,
  });

  ConfiguracoesEntity copyWith({
    AppThemeMode? themeMode,
    int? metaHoras,
    int? metaMinutos,
  }) {
    return ConfiguracoesEntity(
      themeMode: themeMode ?? this.themeMode,
      metaHoras: metaHoras ?? this.metaHoras,
      metaMinutos: metaMinutos ?? this.metaMinutos,
    );
  }
}
