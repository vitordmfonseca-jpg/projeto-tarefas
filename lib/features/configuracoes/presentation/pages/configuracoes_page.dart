import 'package:flutter/material.dart';
import 'package:tarefas_calendario/features/configuracoes/data/datasources/configuracoes_datasource.dart';
import 'package:tarefas_calendario/features/configuracoes/data/repositories/configuracoes_repository.dart';
import 'package:tarefas_calendario/features/configuracoes/presentation/viewmodels/configuracoes_viewmodel.dart';

class ConfiguracoesPage extends StatefulWidget {
  final ValueNotifier<ThemeMode> temaNotifier;

  const ConfiguracoesPage({super.key, required this.temaNotifier});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  late final ConfiguracoesViewModel _vm;
  late final TextEditingController _horasCtrl;
  late final TextEditingController _minutosCtrl;

  @override
  void initState() {
    super.initState();
    final datasource = ConfiguracoesDatasource();
    final repository = ConfiguracoesRepository(datasource);
    _vm = ConfiguracoesViewModel(repository, widget.temaNotifier);
    _horasCtrl = TextEditingController();
    _minutosCtrl = TextEditingController();
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

  void _mostrarSnackBar(String mensagem) {
    if (!mounted) return;
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem, style: TextStyle(color: colorScheme.onSurface)),
        backgroundColor: colorScheme.surfaceContainer,
        behavior: SnackBarBehavior.floating,
        width: 300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.15)),
        ),
      ),
    );
  }

  Future<void> _confirmarImportacao() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Importar banco de dados'),
        content: const Text(
          'O banco atual será substituído e o app será reiniciado. Deseja continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Importar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      final sucesso = await _vm.importarBanco();
      if (!sucesso) _mostrarSnackBar('Erro ao importar banco.');
    }
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

              // Seção Aparência
              _SecaoWidget(titulo: 'Aparência'),
              const SizedBox(height: 16),
              _CartaoWidget(
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tema',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Define a aparência do aplicativo',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    SegmentedButton<ThemeMode>(
                      style: SegmentedButton.styleFrom(
                        selectedBackgroundColor: colorScheme.primary,
                        selectedForegroundColor: colorScheme.onPrimary,
                        foregroundColor: colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                        side: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                        ),
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
                      selected: {_vm.configuracoes.themeMode},
                      onSelectionChanged: (s) => _vm.salvarTema(s.first),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Seção Produtividade
              _SecaoWidget(titulo: 'Produtividade'),
              const SizedBox(height: 16),
              _CartaoWidget(
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
                            controller: _horasCtrl,
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
                            controller: _minutosCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Minutos',
                              suffixText: 'm',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        FilledButton(
                          onPressed: () async {
                            final horas = int.tryParse(_horasCtrl.text) ?? 8;
                            final minutos =
                                int.tryParse(_minutosCtrl.text) ?? 50;
                            await _vm.salvarMeta(horas, minutos);
                            _mostrarSnackBar('Meta salva com sucesso!');
                          },
                          child: const Text('Salvar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Seção Dados
              _SecaoWidget(titulo: 'Dados'),
              const SizedBox(height: 16),
              _CartaoWidget(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Exportar banco de dados',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Salva uma cópia do banco em Downloads',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final caminho = await _vm.exportarBanco();
                            _mostrarSnackBar(
                              caminho != null
                                  ? 'Banco exportado para Downloads!'
                                  : 'Erro ao exportar.',
                            );
                          },
                          icon: const Icon(Icons.download_outlined, size: 16),
                          label: const Text('Exportar'),
                        ),
                      ],
                    ),
                    Divider(
                      height: 32,
                      color: colorScheme.outline.withValues(alpha: 0.1),
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Importar banco de dados',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Substitui o banco atual — o app será reiniciado',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _confirmarImportacao,
                          icon: const Icon(Icons.upload_outlined, size: 16),
                          label: const Text('Importar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme.error,
                            side: BorderSide(
                              color: colorScheme.error.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ],
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
