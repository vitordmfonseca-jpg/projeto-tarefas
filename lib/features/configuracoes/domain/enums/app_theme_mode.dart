enum AppThemeMode {
  claro(1),
  escuro(2),
  sistema(0);

  const AppThemeMode(this._codigo);

  final int _codigo;
  int get codigo => _codigo;

  static AppThemeMode fromInt(int valor) {
    return switch (valor) {
      1 => AppThemeMode.claro,
      2 => AppThemeMode.escuro,
      _ => AppThemeMode.sistema,
    };
  }
}
