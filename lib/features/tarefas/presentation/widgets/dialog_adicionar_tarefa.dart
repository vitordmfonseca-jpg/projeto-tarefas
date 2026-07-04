import 'package:flutter/material.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/enums/modo_dialog.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/viewmodels/dialog_adicionar_tarefa_viewmodel.dart';

class DialogAdicionarTarefa extends StatefulWidget {
  final DateTime diaSelecionado;
  final TarefaEntity? tarefa;
  final ModoDialog modo;

  const DialogAdicionarTarefa({
    super.key,
    required this.diaSelecionado,
    this.tarefa,
    this.modo = ModoDialog.cadastro,
  });

  @override
  State<DialogAdicionarTarefa> createState() => _DialogAdicionarTarefaState();
}

class _DialogAdicionarTarefaState extends State<DialogAdicionarTarefa> {
  late ModoDialog _modo;
  final _vm = DialogAdicionarTarefaViewModel();
  late final TextEditingController _tituloCtrl;
  late final TextEditingController _descricaoCtrl;
  late final TextEditingController _horasCtrl;
  late final TextEditingController _minutosCtrl;

  bool get _isVisualizacao => _modo == ModoDialog.visualizacao;

  String get _titulo => switch (_modo) {
    ModoDialog.cadastro => 'Registrar Tarefa',
    ModoDialog.edicao => 'Editar Tarefa',
    ModoDialog.visualizacao => 'Detalhes',
  };

  String get _tempoFormatado {
    final horas = int.tryParse(_horasCtrl.text) ?? 0;
    final minutos = int.tryParse(_minutosCtrl.text) ?? 0;
    if (horas == 0 && minutos == 0) return '—';
    if (horas == 0) return '${minutos}m';
    if (minutos == 0) return '${horas}h';
    return '${horas}h ${minutos}m';
  }

  @override
  void initState() {
    super.initState();
    _modo = widget.modo;
    final t = widget.tarefa;
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
        id: widget.tarefa?.id,
      );
      Navigator.of(context).pop(tarefa);
    }
  }

  Widget _buildLabel(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _vm,
      builder: (context, _) {
        return Dialog(
          child: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                  child: Row(
                    children: [
                      Text(
                        _titulo,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      if (_isVisualizacao)
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => Navigator.of(context).pop(),
                          style: IconButton.styleFrom(
                            foregroundColor: colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Conteúdo
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_vm.erro != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
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
                            style: TextStyle(
                              color: colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),

                      _buildLabel('Título'),
                      TextField(
                        controller: _tituloCtrl,
                        readOnly: _isVisualizacao,
                        decoration: const InputDecoration(
                          hintText: 'Nome da tarefa',
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildLabel('Descrição'),
                      TextField(
                        controller: _descricaoCtrl,
                        readOnly: _isVisualizacao,
                        maxLines: _isVisualizacao ? null : 3,
                        decoration: InputDecoration(
                          hintText: _isVisualizacao
                              ? 'Sem descrição'
                              : 'Detalhes opcionais...',
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildLabel('Tempo gasto'),
                      if (_isVisualizacao)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            child: Text(
                              _tempoFormatado,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _horasCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: '0',
                                  suffixText: 'h',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _minutosCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: '0',
                                  suffixText: 'm',
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                // Rodapé com fundo diferente — só nos modos de edição/cadastro
                if (!_isVisualizacao)
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      border: Border(
                        top: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.1),
                        ),
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: _salvar,
                          child: const Text('Gravar'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
