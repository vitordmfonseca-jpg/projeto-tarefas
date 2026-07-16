import 'package:flutter_test/flutter_test.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/viewmodels/dialog_adicionar_viewmodel.dart';

void main() {
  late DialogAdicionarTarefaViewModel vm;

  setUp(() => vm = DialogAdicionarTarefaViewModel());
  tearDown(() => vm.dispose());

  group('validar', () {
    test('falha quando o título está vazio', () {
      vm.horasCtrl.text = '1';
      expect(vm.validar(), isFalse);
      expect(vm.erro, isNotNull);
    });

    test('falha quando horas é negativo', () {
      vm.tituloCtrl.text = 'Reunião';
      vm.horasCtrl.text = '-1';
      expect(vm.validar(), isFalse);
    });

    test('falha quando minutos está fora de 0-59', () {
      vm.tituloCtrl.text = 'Reunião';
      vm.minutosCtrl.text = '60';
      expect(vm.validar(), isFalse);
    });

    test('falha quando horas e minutos são zero', () {
      vm.tituloCtrl.text = 'Reunião';
      expect(vm.validar(), isFalse);
    });

    test('passa com título e tempo válidos, limpando erro anterior', () {
      vm.tituloCtrl.text = 'Reunião';
      vm.minutosCtrl.text = '60';
      vm.validar(); // gera erro

      vm.minutosCtrl.text = '30';
      expect(vm.validar(), isTrue);
      expect(vm.erro, isNull);
    });
  });

  test('montar monta a entidade com os dados do formulário', () {
    vm.tituloCtrl.text = '  Reunião  ';
    vm.descricaoCtrl.text = '   ';
    vm.horasCtrl.text = '2';
    vm.minutosCtrl.text = '15';
    final dia = DateTime(2026, 7, 15);

    final tarefa = vm.montar(dia: dia);

    expect(tarefa.titulo, 'Reunião');
    expect(tarefa.descricao, isNull); // descrição só com espaços vira null
    expect(tarefa.horasGastas, 2);
    expect(tarefa.minutosGastos, 15);
    expect(tarefa.data, dia);
  });

  test('inicializar preenche os campos a partir de uma tarefa existente', () {
    final tarefa = TarefaEntity(
      id: 7,
      titulo: 'Estudo',
      descricao: 'Flutter',
      data: DateTime(2026, 7, 15),
      horasGastas: 1,
      minutosGastos: 30,
    );

    vm.inicializar(tarefa);

    expect(vm.tituloCtrl.text, 'Estudo');
    expect(vm.descricaoCtrl.text, 'Flutter');
    expect(vm.horasCtrl.text, '1');
    expect(vm.minutosCtrl.text, '30');
  });
}
