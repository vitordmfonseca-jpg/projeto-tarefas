import 'package:flutter/material.dart';
import 'package:tarefas_calendario/features/configuracoes/presentation/actions/configuracoes_action.dart';
import 'package:tarefas_calendario/features/configuracoes/presentation/viewmodels/configuracoes_viewmodel.dart';

class ConfiguracoesPage extends StatefulWidget {
  final ConfiguracoesViewModel viewModel;
  final ConfiguracoesAction action;

  const ConfiguracoesPage({
    super.key,
    required this.viewModel,
    required this.action,
  });

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  ConfiguracoesViewModel get _vm => widget.viewModel;
  ConfiguracoesAction get _action => widget.action;

  final _horasCtrl = TextEditingController();
  final _minutosCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _vm.init();
    _horasCtrl.text = '${_vm.configuracoes.metaHoras}';
    _minutosCtrl.text = '${_vm.configuracoes.metaMinutos}';
  }

  @override
  void dispose() {
    _horasCtrl.dispose();
    _minutosCtrl.dispose();
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _vm,
      builder: (context, _) {
        if (_vm.carregando) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Configurações',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 32),

              _SecaoWidget(titulo: 'Aparência'),
              const SizedBox(height: 16),
              _CartaoWidget(
                child: Column(
                  children: [
                    _LinhaConfiguracaoWidget(
                      titulo: 'Tema',
                      descricao: 'Define a aparência do aplicativo',
                      trailing: _SeletorTemaWidget(vm: _vm),
                    ),
                    Divider(
                      height: 32,
                      color: colorScheme.outline.withValues(alpha: 0.1),
                    ),
                    _LinhaConfiguracaoWidget(
                      titulo: 'Iniciar com o Windows',
                      descricao:
                          'Abre o app automaticamente ao ligar o computador',
                      trailing: Switch(
                        value: _vm.iniciarComWindows,
                        onChanged: _vm.toggleIniciarComWindows,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              _SecaoWidget(titulo: 'Produtividade'),
              const SizedBox(height: 16),
              _CardMetaWidget(
                horasCtrl: _horasCtrl,
                minutosCtrl: _minutosCtrl,
                onSalvar: () => _action.salvarMeta(
                  context,
                  _horasCtrl.text,
                  _minutosCtrl.text,
                ),
              ),

              const SizedBox(height: 32),

              _SecaoWidget(titulo: 'Dados'),
              const SizedBox(height: 16),
              _CartaoWidget(
                child: Column(
                  children: [
                    _LinhaConfiguracaoWidget(
                      titulo: 'Caminho do banco de dados',
                      descricao: 'Local onde o arquivo do banco é armazenado',
                      crossAxisAlignment: CrossAxisAlignment.center,
                      trailing: SelectableText(
                        _vm.caminhoBanco,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    Divider(
                      height: 32,
                      color: colorScheme.outline.withValues(alpha: 0.1),
                    ),
                    _LinhaConfiguracaoWidget(
                      titulo: 'Exportar banco de dados',
                      descricao: 'Salva uma cópia do banco em Downloads',
                      trailing: OutlinedButton.icon(
                        onPressed: () => _action.exportarBanco(context),
                        icon: const Icon(Icons.download_outlined, size: 16),
                        label: const Text('Exportar'),
                      ),
                    ),
                    Divider(
                      height: 32,
                      color: colorScheme.outline.withValues(alpha: 0.1),
                    ),
                    _LinhaConfiguracaoWidget(
                      titulo: 'Importar banco de dados',
                      descricao:
                          'Substitui o banco atual — o app será reiniciado',
                      trailing: OutlinedButton.icon(
                        onPressed: () => _action.confirmarImportacao(context),
                        icon: const Icon(Icons.upload_outlined, size: 16),
                        label: const Text('Importar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.error,
                          side: BorderSide(
                            color: colorScheme.error.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LinhaConfiguracaoWidget extends StatelessWidget {
  final String titulo;
  final String descricao;
  final Widget trailing;
  final CrossAxisAlignment crossAxisAlignment;

  const _LinhaConfiguracaoWidget({
    required this.titulo,
    required this.descricao,
    required this.trailing,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(descricao, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}

class _SeletorTemaWidget extends StatelessWidget {
  final ConfiguracoesViewModel vm;

  const _SeletorTemaWidget({required this.vm});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SegmentedButton<ThemeMode>(
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: colorScheme.primary,
        selectedForegroundColor: colorScheme.onPrimary,
        foregroundColor: colorScheme.onSurface.withValues(alpha: 0.6),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      segments: const [
        ButtonSegment(
          value: ThemeMode.system,
          label: Text('Sistema'),
          icon: Icon(Icons.brightness_auto_outlined, size: 16),
        ),
        ButtonSegment(
          value: ThemeMode.light,
          label: Text('Claro'),
          icon: Icon(Icons.light_mode_outlined, size: 16),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          label: Text('Escuro'),
          icon: Icon(Icons.dark_mode_outlined, size: 16),
        ),
      ],
      selected: {vm.themeModeAtual},
      onSelectionChanged: (s) => vm.salvarTema(s.first),
    );
  }
}

class _CardMetaWidget extends StatelessWidget {
  final TextEditingController horasCtrl;
  final TextEditingController minutosCtrl;
  final VoidCallback onSalvar;

  const _CardMetaWidget({
    required this.horasCtrl,
    required this.minutosCtrl,
    required this.onSalvar,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return _CartaoWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Meta diária de horas',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Define a meta de horas trabalhadas por dia',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 100,
                child: TextField(
                  controller: horasCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Horas',
                    suffixText: 'h',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: minutosCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Minutos',
                    suffixText: 'm',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              FilledButton(onPressed: onSalvar, child: const Text('Salvar')),
            ],
          ),
        ],
      ),
    );
  }
}

class _SecaoWidget extends StatelessWidget {
  final String titulo;
  const _SecaoWidget({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Text(
      titulo.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
      ),
    );
  }
}

class _CartaoWidget extends StatelessWidget {
  final Widget child;
  const _CartaoWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: child,
    );
  }
}
