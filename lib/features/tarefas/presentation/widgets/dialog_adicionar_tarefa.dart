import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/extensions/ext_build_context.dart';
import 'package:tarefas_calendario/core/ui_components/error_banner_widget.dart';
import 'package:tarefas_calendario/core/widgets/campo_texto/text_form_widget.dart';
import 'package:tarefas_calendario/core/widgets/dialog/dialog_widget.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/enums/modo_dialog.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/viewmodels/dialog_adicionar_viewmodel.dart';

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

  bool get _isVisualizacao => _modo == ModoDialog.visualizacao;

  String get _titulo => switch (_modo) {
    ModoDialog.cadastro => 'Registrar Tarefa',
    ModoDialog.edicao => 'Editar Tarefa',
    ModoDialog.visualizacao => 'Detalhes',
  };

  @override
  void initState() {
    super.initState();
    _modo = widget.modo;
    _vm.inicializar(widget.tarefa);
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_vm.validar()) return;

    final tarefa = _vm.montar(
      dia: widget.diaSelecionado,
      id: widget.tarefa?.id,
    );
    Navigator.of(context).pop(tarefa);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _vm,
      builder: (context, _) {
        return DialogWidget(
          titulo: _titulo,
          largura: context.mediaQuery.size.width * .5,
          widgetCabecalho: [
            if (_isVisualizacao)
              _CampoTempoGastoWidget(tempoFormatado: _vm.tempoFormatado),
          ],
          conteudo: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16.0,
              children: [
                _DialogConteudoWidget(vm: _vm, somenteLeitura: _isVisualizacao),
                if (!_isVisualizacao)
                  Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _vm.horasCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '0',
                            suffixText: 'h',
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _vm.minutosCtrl,
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
          acoes: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            if (!_isVisualizacao)
              FilledButton(onPressed: _salvar, child: const Text('Gravar')),
          ],
        );
      },
    );
  }
}

class _DialogConteudoWidget extends StatelessWidget {
  const _DialogConteudoWidget({required this.vm, required this.somenteLeitura});

  final DialogAdicionarTarefaViewModel vm;
  final bool somenteLeitura;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: 16.0,
      children: [
        if (vm.erro != null) ...[ErrorBannerWidget(mensagem: vm.erro!)],
        TextFormWidget(
          label: 'Título',
          controller: vm.tituloCtrl,
          readOnly: somenteLeitura,
          hint: 'Nome da tarefa',
        ),
        TextFormWidget(
          label: 'Descrição',
          controller: vm.descricaoCtrl,
          readOnly: somenteLeitura,
          maxLines: 6,
          hint: somenteLeitura ? 'Sem descrição' : 'Detalhes opcionais...',
        ),
      ],
    );
  }
}

class _CampoTempoGastoWidget extends StatelessWidget {
  const _CampoTempoGastoWidget({required this.tempoFormatado});

  final String tempoFormatado;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      constraints: BoxConstraints(maxWidth: 200.0),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.4)),
      ),
      child: Text(
        tempoFormatado,
        maxLines: 1,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
