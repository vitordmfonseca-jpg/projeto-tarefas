import 'package:flutter_test/flutter_test.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/tarefas/domain/usecases/busca_dias_com_registro_usecase.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/viewmodels/tarefas_viewmodel.dart';

import '../../fakes/fake_tarefa_repository.dart';

void main() {
  late FakeTarefaRepository repo;
  late TarefasViewModel vm;

  setUp(() {
    repo = FakeTarefaRepository();
    vm = TarefasViewModel(repo, BuscarDiasComRegistroUsecase(repo));
  });

  test('selecionarDia carrega as tarefas do dia e desliga o loading', () async {
    final dia = DateTime(2026, 7, 15);
    await repo.salvar(
      TarefaEntity(titulo: 'Reunião', data: dia, minutosGastos: 30),
    );

    await vm.selecionarDia(dia);

    expect(vm.carregando, isFalse);
    expect(vm.tarefas, hasLength(1));
    expect(vm.erro, isNull);
  });

  test(
    'carregando volta a false mesmo quando a busca falha (sem travar o spinner)',
    () async {
      repo.lancarErroAoBuscar = true;

      await vm.selecionarDia(DateTime(2026, 7, 15));

      expect(vm.carregando, isFalse);
      expect(vm.erro, isNotNull);
    },
  );

  test('salvar retorna true e atualiza a lista em caso de sucesso', () async {
    final dia = DateTime(2026, 7, 15);
    await vm.selecionarDia(dia);

    final sucesso = await vm.salvar(
      TarefaEntity(titulo: 'Nova tarefa', data: dia, minutosGastos: 45),
    );

    expect(sucesso, isTrue);
    expect(vm.tarefas, hasLength(1));
  });

  test('salvar retorna false e expõe erro quando o repositório falha', () async {
    repo.lancarErroAoSalvar = true;

    final sucesso = await vm.salvar(
      TarefaEntity(titulo: 'Nova tarefa', data: DateTime(2026, 7, 15)),
    );

    expect(sucesso, isFalse);
    expect(vm.erro, isNotNull);
    expect(vm.carregando, isFalse);
  });
}
