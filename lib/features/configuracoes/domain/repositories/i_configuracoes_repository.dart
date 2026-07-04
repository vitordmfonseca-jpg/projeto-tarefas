import 'package:tarefas_calendario/features/configuracoes/domain/entities/configuracoes_entity.dart';

abstract interface class IConfiguracoesRepository {
  Future<ConfiguracoesEntity> carregar();
  Future<void> salvar(ConfiguracoesEntity configuracoes);
  Future<String> caminhoDb();
}
