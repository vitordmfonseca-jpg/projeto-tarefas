import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/ui_components/sidebar/aba_principal.dart';
import 'package:tarefas_calendario/core/ui_components/sidebar/sidebar_widget.dart';
import 'package:tarefas_calendario/features/configuracoes/di/configuracoes_factory.dart';
import 'package:tarefas_calendario/features/tarefas/di/tarefas_factory.dart';
import 'package:tarefas_calendario/features/timesheet/di/timesheet_factory.dart';

class HomePage extends StatefulWidget {
  final ValueNotifier<ThemeMode> temaNotifier;

  const HomePage({super.key, required this.temaNotifier});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AbaPrincipal _abaSelecionada = AbaPrincipal.tarefas;
  bool _sidebarExpandida = false;
  late Widget _paginaAtual;

  static const double _larguraSidebarRecolhida = 64.0;

  @override
  void initState() {
    super.initState();
    _paginaAtual = _criarPagina(_abaSelecionada);
  }

  Widget _criarPagina(AbaPrincipal aba) => switch (aba) {
    AbaPrincipal.tarefas => TarefasFactory.create(),
    AbaPrincipal.timesheet => TimesheetFactory.create(),
    AbaPrincipal.configuracoes => ConfiguracoesFactory.create(
      temaNotifier: widget.temaNotifier,
    ),
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
              abaSelecionada: _abaSelecionada,
              onItemSelecionado: (aba) {
                if (_abaSelecionada == aba) return;
                setState(() {
                  _abaSelecionada = aba;
                  _paginaAtual = _criarPagina(aba);
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
