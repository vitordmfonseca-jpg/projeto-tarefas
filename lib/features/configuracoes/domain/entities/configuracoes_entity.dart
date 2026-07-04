import 'package:flutter/material.dart';

class ConfiguracoesEntity {
  final ThemeMode themeMode;
  final int metaHoras;
  final int metaMinutos;

  const ConfiguracoesEntity({
    this.themeMode = ThemeMode.system,
    this.metaHoras = 8,
    this.metaMinutos = 50,
  });

  ConfiguracoesEntity copyWith({
    ThemeMode? themeMode,
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
