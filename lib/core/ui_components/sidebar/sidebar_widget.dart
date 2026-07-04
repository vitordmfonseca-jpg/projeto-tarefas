import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/ui_components/sidebar/sidebar_item_widget.dart';

class SidebarWidget extends StatefulWidget {
  final int indiceSelecionado;
  final void Function(int) onItemSelecionado;
  final void Function(bool) onExpandida;

  const SidebarWidget({
    super.key,
    required this.indiceSelecionado,
    required this.onItemSelecionado,
    required this.onExpandida,
  });

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  bool _expandida = false;

  static const _larguraExpandida = 200.0;
  static const _larguraRecolhida = 64.0;

  static const _itens = [
    (icone: Icons.calendar_month_outlined, label: 'Calendário'),
    (icone: Icons.access_time_outlined, label: 'Timesheet'),
  ];

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

              ..._itens.asMap().entries.map(
                (e) => SidebarItemWidget(
                  icone: e.value.icone,
                  label: e.value.label,
                  selecionado: widget.indiceSelecionado == e.key,
                  expandida: _expandida,
                  onTap: () => widget.onItemSelecionado(e.key),
                ),
              ),

              const Spacer(),

              Divider(
                indent: 8,
                endIndent: 8,
                color: colorScheme.outline.withValues(alpha: 0.1),
              ),

              SidebarItemWidget(
                icone: Icons.settings_outlined,
                label: 'Configurações',
                selecionado: widget.indiceSelecionado == 2,
                expandida: _expandida,
                onTap: () => widget.onItemSelecionado(2),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
