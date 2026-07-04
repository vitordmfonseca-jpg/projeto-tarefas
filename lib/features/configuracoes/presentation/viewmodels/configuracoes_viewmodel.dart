import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:tarefas_calendario/features/configuracoes/domain/entities/configuracoes_entity.dart';
import 'package:tarefas_calendario/features/configuracoes/domain/repositories/i_configuracoes_repository.dart';
import 'package:tarefas_calendario/features/tarefas/data/database_helper.dart';

class ConfiguracoesViewModel extends ChangeNotifier {
  final IConfiguracoesRepository _repository;
  final ValueNotifier<ThemeMode> temaNotifier;

  ConfiguracoesViewModel(this._repository, this.temaNotifier);

  ConfiguracoesEntity _configuracoes = const ConfiguracoesEntity();
  bool _carregando = false;

  ConfiguracoesEntity get configuracoes => _configuracoes;
  bool get carregando => _carregando;

  int get metaMinutosDia =>
      (_configuracoes.metaHoras * 60) + _configuracoes.metaMinutos;

  set carregando(bool valor) {
    _carregando = valor;
    notifyListeners();
  }

  Future<void> init() async {
    carregando = true;
    _configuracoes = await _repository.carregar();
    temaNotifier.value = _configuracoes.themeMode;
    carregando = false;
  }

  Future<void> salvarTema(ThemeMode modo) async {
    _configuracoes = _configuracoes.copyWith(themeMode: modo);
    temaNotifier.value = modo;
    await _repository.salvar(_configuracoes);
    notifyListeners();
  }

  Future<void> salvarMeta(int horas, int minutos) async {
    _configuracoes = _configuracoes.copyWith(
      metaHoras: horas,
      metaMinutos: minutos,
    );
    await _repository.salvar(_configuracoes);
    notifyListeners();
  }

  Future<String?> exportarBanco() async {
    try {
      final origem = await _repository.caminhoDb();
      final downloads = await getDownloadsDirectory();
      if (downloads == null) return null;

      final destino = join(downloads.path, 'tarefas_backup.db');
      await File(origem).copy(destino);
      return destino;
    } catch (_) {
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
      await DatabaseHelper.instance.fecharBanco();

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
