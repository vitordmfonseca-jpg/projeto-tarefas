import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/ui_components/sidebar/sidebar_item_widget.dart';

class SidebarWidget extends StatefulWidget {
  final int indiceSelecionado;
  final void Function(int) onItemSelecionado;

  const SidebarWidget({
    super.key,
    required this.indiceSelecionado,
    required this.onItemSelecionado,
  });

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  bool _expandida = false;

  static const _larguraExpandida = 200.0;
  static const _larguraRecolhida = 65.0;

  static const _itens = [
    (icone: Icons.calendar_month_outlined, label: 'Calendário'),
    (icone: Icons.access_time_outlined, label: 'Timesheet'),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _expandida = true),
      onExit: (_) => setState(() => _expandida = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
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
        // ClipRect evita overflow durante a animação
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: [
              // Itens principais
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

              // Configurações no rodapé
              SidebarItemWidget(
                icone: Icons.settings_outlined,
                label: 'Configurações',
                selecionado: widget.indiceSelecionado == 2,
                expandida: _expandida,
                onTap: () => widget.onItemSelecionado(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
