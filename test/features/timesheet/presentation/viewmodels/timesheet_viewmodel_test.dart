import 'package:flutter_test/flutter_test.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/timesheet/domain/usecases/busca_tarefas_periodo_usecase.dart';
import 'package:tarefas_calendario/features/timesheet/domain/usecases/exportar_timesheet_usecase.dart';
import 'package:tarefas_calendario/features/timesheet/presentation/viewmodels/timesheet_viewmodel.dart';

import '../../../tarefas/fakes/fake_tarefa_repository.dart';

TimesheetViewModel _criarViewModel(FakeTarefaRepository repo) {
  return TimesheetViewModel(
    buscarTarefas: BuscarTarefasPeriodoUsecase(repo),
    exportarTimesheet: ExportarTimesheetUsecase(),
  );
}

void main() {
  test('init carrega as tarefas do período e desliga o loading', () async {
    final repo = FakeTarefaRepository(
      tarefas: [
        TarefaEntity(
          titulo: 'Tarefa',
          data: DateTime.now(),
          minutosGastos: 30,
        ),
      ],
    );
    final vm = _criarViewModel(repo);

    await vm.init();

    expect(vm.carregando, isFalse);
    expect(vm.erro, isNull);
  });

  test(
    'carregando volta a false mesmo quando a busca do período falha',
    () async {
      final repo = FakeTarefaRepository()..lancarErroAoBuscar = true;
      final vm = _criarViewModel(repo);

      await vm.init();

      expect(vm.carregando, isFalse);
      expect(vm.erro, isNotNull);
    },
  );
}
