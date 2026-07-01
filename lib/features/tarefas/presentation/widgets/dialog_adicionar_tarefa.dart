import 'package:flutter/material.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/viewmodels/dialog_adicionar_tarefa_viewmodel.dart';

class DialogAdicionarTarefa extends StatefulWidget {
  final DateTime diaSelecionado;

  const DialogAdicionarTarefa({super.key, required this.diaSelecionado});

  @override
  State<DialogAdicionarTarefa> createState() => _DialogAdicionarTarefaState();
}

class _DialogAdicionarTarefaState extends State<DialogAdicionarTarefa> {
  final _vm = DialogAdicionarTarefaViewModel();
  final _tituloCtrl = TextEditingController();
  final _descricaoCtrl = TextEditingController();
  final _horasCtrl = TextEditingController();
  final _minutosCtrl = TextEditingController();

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descricaoCtrl.dispose();
    _horasCtrl.dispose();
    _minutosCtrl.dispose();
    _vm.dispose();
    super.dispose();
  }

  void _salvar() {
    final valido = _vm.validar(
      titulo: _tituloCtrl.text,
      horas: _horasCtrl.text,
      minutos: _minutosCtrl.text,
    );

    if (valido) {
      final tarefa = _vm.montar(
        titulo: _tituloCtrl.text,
        descricao: _descricaoCtrl.text,
        horas: _horasCtrl.text,
        minutos: _minutosCtrl.text,
        dia: widget.diaSelecionado,
      );
      Navigator.of(context).pop(tarefa);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _vm,
      builder: (context, _) {
        return AlertDialog(
          title: const Text('Registrar Tarefa'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_vm.erro != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _vm.erro!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                TextField(
                  controller: _tituloCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Título *',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descricaoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Descrição (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _horasCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Horas',
                          border: OutlineInputBorder(),
                          suffixText: 'h',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _minutosCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Minutos',
                          border: OutlineInputBorder(),
                          suffixText: 'm',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(onPressed: _salvar, child: const Text('Salvar')),
          ],
        );
      },
    );
  }
}
