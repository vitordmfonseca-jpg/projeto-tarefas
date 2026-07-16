import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tarefas_calendario/core/ui_components/sidebar/aba_principal.dart';
import 'package:tarefas_calendario/core/ui_components/sidebar/sidebar_item_widget.dart';
import 'package:yaml/yaml.dart';

class SidebarWidget extends StatefulWidget {
  final AbaPrincipal abaSelecionada;
  final void Function(AbaPrincipal) onItemSelecionado;
  final void Function(bool) onExpandida;

  const SidebarWidget({
    super.key,
    required this.abaSelecionada,
    required this.onItemSelecionado,
    required this.onExpandida,
  });

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  bool _expandida = false;
  late final Future<String> _versaoFuture;

  static const _larguraExpandida = 200.0;
  static const _larguraRecolhida = 64.0;

  static const _itens = [
    (
      aba: AbaPrincipal.tarefas,
      icone: Icons.calendar_month_outlined,
      label: 'Calendário',
    ),
    (
      aba: AbaPrincipal.timesheet,
      icone: Icons.access_time_outlined,
      label: 'Timesheet',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _versaoFuture = _lerVersao();
  }

  Future<String> _lerVersao() async {
    final yaml = await rootBundle.loadString('pubspec.yaml');
    final doc = loadYaml(yaml);
    return doc['version'].toString().split('+').first;
  }

  void _setExpandida(bool valor) {
    setState(() => _expandida = valor);
    widget.onExpandida(valor);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => _setExpandida(true),
      onExit: (_) => _setExpandida(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: _expandida ? _larguraExpandida : _larguraRecolhida,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          border: Border(
            right: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: ClipRect(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              ..._itens.map(
                (item) => SidebarItemWidget(
                  icone: item.icone,
                  label: item.label,
                  selecionado: widget.abaSelecionada == item.aba,
                  expandida: _expandida,
                  onTap: () => widget.onItemSelecionado(item.aba),
                ),
              ),

              const Spacer(),

              SidebarItemWidget(
                icone: Icons.settings_outlined,
                label: 'Configurações',
                selecionado: widget.abaSelecionada == AbaPrincipal.configuracoes,
                expandida: _expandida,
                onTap: () => widget.onItemSelecionado(AbaPrincipal.configuracoes),
              ),

              Divider(
                indent: 8,
                endIndent: 8,
                color: colorScheme.outline.withValues(alpha: 0.1),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<String>(
                    future: _versaoFuture,
                    builder: (_, snap) {
                      if (!snap.hasData) return const SizedBox.shrink();
                      return Text(
                        'v${snap.data}',
                        style: TextStyle(
                          fontSize: 10,
                          color: colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
