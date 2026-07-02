import 'package:flutter/material.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/viewmodels/dialog_adicionar_tarefa_viewmodel.dart';

class DialogAdicionarTarefa extends StatefulWidget {
  final DateTime diaSelecionado;
  final TarefaEntity? tarefaParaEditar;

  const DialogAdicionarTarefa({
    super.key,
    required this.diaSelecionado,
    this.tarefaParaEditar,
  });

  @override
  State<DialogAdicionarTarefa> createState() => _DialogAdicionarTarefaState();
}

class _DialogAdicionarTarefaState extends State<DialogAdicionarTarefa> {
  final _vm = DialogAdicionarTarefaViewModel();
  late final TextEditingController _tituloCtrl;
  late final TextEditingController _descricaoCtrl;
  late final TextEditingController _horasCtrl;
  late final TextEditingController _minutosCtrl;

  bool get _isEdicao => widget.tarefaParaEditar != null;

  @override
  void initState() {
    super.initState();
    final t = widget.tarefaParaEditar;
    _tituloCtrl = TextEditingController(text: t?.titulo ?? '');
    _descricaoCtrl = TextEditingController(text: t?.descricao ?? '');
    _horasCtrl = TextEditingController(
      text: t != null && t.horasGastas > 0 ? '${t.horasGastas}' : '',
    );
    _minutosCtrl = TextEditingController(
      text: t != null && t.minutosGastos > 0 ? '${t.minutosGastos}' : '',
    );
  }

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
        id: widget.tarefaParaEditar?.id,
      );
      Navigator.of(context).pop(tarefa);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
    );

    return ListenableBuilder(
      listenable: _vm,
      builder: (context, _) {
        return AlertDialog(
          title: Text(_isEdicao ? 'Editar Tarefa' : 'Registrar Tarefa'),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_vm.erro != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorScheme.error.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      _vm.erro!,
                      style: TextStyle(color: colorScheme.error, fontSize: 12),
                    ),
                  ),
                TextField(
                  controller: _tituloCtrl,
                  decoration: inputDecoration.copyWith(labelText: 'Título *'),
                  autofocus: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descricaoCtrl,
                  decoration: inputDecoration.copyWith(
                    labelText: 'Descrição (opcional)',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _horasCtrl,
                        decoration: inputDecoration.copyWith(
                          labelText: 'Horas',
                          suffixText: 'h',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _minutosCtrl,
                        decoration: inputDecoration.copyWith(
                          labelText: 'Minutos',
                          suffixText: 'm',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: _salvar,
              child: Text(_isEdicao ? 'Salvar alterações' : 'Registrar'),
            ),
          ],
        );
      },
    );
  }
}
