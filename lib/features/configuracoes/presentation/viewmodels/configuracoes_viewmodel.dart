import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:tarefas_calendario/core/di/app_dependencies.dart';
import 'package:tarefas_calendario/features/configuracoes/domain/entities/configuracoes_entity.dart';
import 'package:tarefas_calendario/features/configuracoes/domain/enums/app_theme_mode.dart';
import 'package:tarefas_calendario/features/configuracoes/domain/repositories/i_configuracoes_repository.dart';

class ConfiguracoesViewModel extends ChangeNotifier {
  final IConfiguracoesRepository _repository;
  final ValueNotifier<ThemeMode> temaNotifier;

  ConfiguracoesViewModel(this._repository, this.temaNotifier);

  ConfiguracoesEntity _configuracoes = const ConfiguracoesEntity();
  bool _carregando = false;
  String? _erro;
  String _caminhoBanco = '';
  bool _iniciarComWindows = false;

  ConfiguracoesEntity get configuracoes => _configuracoes;
  bool get carregando => _carregando;
  String? get erro => _erro;
  String get caminhoBanco => _caminhoBanco;
  bool get iniciarComWindows => _iniciarComWindows;

  int get metaMinutosDia =>
      (_configuracoes.metaHoras * 60) + _configuracoes.metaMinutos;

  void _setCarregando(bool valor) {
    _carregando = valor;
    notifyListeners();
  }

  // Conversão entre o enum de domínio (AppThemeMode) e o ThemeMode
  ThemeMode _paraThemeMode(AppThemeMode modo) => switch (modo) {
    AppThemeMode.claro => ThemeMode.light,
    AppThemeMode.escuro => ThemeMode.dark,
    AppThemeMode.sistema => ThemeMode.system,
  };

  AppThemeMode _paraAppThemeMode(ThemeMode modo) => switch (modo) {
    ThemeMode.light => AppThemeMode.claro,
    ThemeMode.dark => AppThemeMode.escuro,
    ThemeMode.system => AppThemeMode.sistema,
  };

  ThemeMode get themeModeAtual => _paraThemeMode(_configuracoes.themeMode);

  Future<void> init() async {
    _setCarregando(true);
    try {
      _configuracoes = await _repository.carregar();
      temaNotifier.value = _paraThemeMode(_configuracoes.themeMode);
      _caminhoBanco = await _repository.caminhoDb();
      _iniciarComWindows = await launchAtStartup.isEnabled();
      _erro = null;
    } catch (_) {
      _erro = 'Não foi possível carregar as configurações';
    } finally {
      _setCarregando(false);
    }
  }

  Future<bool> salvarTema(ThemeMode modo) async {
    final anterior = _configuracoes;
    _configuracoes = _configuracoes.copyWith(
      themeMode: _paraAppThemeMode(modo),
    );
    temaNotifier.value = modo;
    notifyListeners();

    try {
      await _repository.salvar(_configuracoes);
      return true;
    } catch (_) {
      _configuracoes = anterior;
      temaNotifier.value = _paraThemeMode(anterior.themeMode);
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleIniciarComWindows(bool valor) async {
    try {
      if (valor) {
        await launchAtStartup.enable();
      } else {
        await launchAtStartup.disable();
      }
    } catch (_) {
      return false;
    }
    _iniciarComWindows = valor;
    notifyListeners();
    return true;
  }

  Future<bool> salvarMeta(String horasTexto, String minutosTexto) async {
    final horas = int.tryParse(horasTexto) ?? 8;
    final minutos = int.tryParse(minutosTexto) ?? 50;
    final anterior = _configuracoes;
    _configuracoes = _configuracoes.copyWith(
      metaHoras: horas,
      metaMinutos: minutos,
    );

    try {
      await _repository.salvar(_configuracoes);
      notifyListeners();
      return true;
    } catch (_) {
      _configuracoes = anterior;
      return false;
    }
  }

  Future<String?> exportarBanco() async {
    try {
      final origem = await _repository.caminhoDb();
      final downloads = await getDownloadsDirectory();
      if (downloads == null) return null;

      final destino = join(downloads.path, 'tarefas_backup.db');
      await File(origem).copy(destino);
      return destino;
    } catch (e) {
      debugPrint('Erro ao exportar banco: $e');
      return null;
    }
  }

  Future<bool> importarBanco() async {
    try {
      final resultado = await FilePicker.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (resultado == null || resultado.files.isEmpty) return false;

      final arquivoSelecionado = resultado.files.first.path;
      if (arquivoSelecionado == null) return false;

      final destino = await _repository.caminhoDb();

      // Fecha a conexão com o banco antes de deletar
      await AppDependencies.databaseHelper.fecharBanco();

      //Exclui banco antes de copiar
      final destinoFile = File(destino);
      if (await destinoFile.exists()) {
        await destinoFile.delete();
      }

      await File(arquivoSelecionado).copy(destino);

      // Reinicia o app para recarregar o banco
      Restart.restartApp();
      return true;
    } catch (e) {
      debugPrint('Erro ao importar banco: $e');
      return false;
    }
  }
}
