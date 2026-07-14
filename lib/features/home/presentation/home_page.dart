import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/ui_components/sidebar/sidebar_widget.dart';
import 'package:tarefas_calendario/di/factories/configuracoes_factory.dart';
import 'package:tarefas_calendario/di/factories/tarefas_factory.dart';
import 'package:tarefas_calendario/di/factories/timesheet_factory.dart';

class HomePage extends StatefulWidget {
  final ValueNotifier<ThemeMode> temaNotifier;

  const HomePage({super.key, required this.temaNotifier});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indiceSelecionado = 0;
  bool _sidebarExpandida = false;
  late Widget _paginaAtual;

  static const double _larguraSidebarRecolhida = 64.0;

  @override
  void initState() {
    super.initState();
    _paginaAtual = _criarPagina(_indiceSelecionado);
  }

  Widget _criarPagina(int indice) => switch (indice) {
    0 => TarefasFactory.create(),
    1 => TimesheetFactory.create(),
    2 => ConfiguracoesFactory.create(temaNotifier: widget.temaNotifier),
    _ => const SizedBox.shrink(),
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          Positioned.fill(
            left: _larguraSidebarRecolhida,
            child: _paginaAtual,
          ),

          Positioned.fill(
            left: _larguraSidebarRecolhida,
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: _sidebarExpandida ? 0.3 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const ColoredBox(color: Colors.black),
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: SidebarWidget(
              indiceSelecionado: _indiceSelecionado,
              onItemSelecionado: (i) {
                if (_indiceSelecionado == i) return;
                setState(() {
                  _indiceSelecionado = i;
                  _paginaAtual = _criarPagina(i);
                });
              },
              onExpandida: (expandida) =>
                  setState(() => _sidebarExpandida = expandida),
            ),
          ),
        ],
      ),
    );
  }
}
