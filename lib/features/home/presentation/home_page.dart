import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/ui_components/sidebar/sidebar_widget.dart';
import 'package:tarefas_calendario/features/configuracoes/presentation/pages/configuracoes_page.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/pages/tarefas_page.dart';
import 'package:tarefas_calendario/features/timesheet/presentation/pages/timesheet_page.dart';

class HomePage extends StatefulWidget {
  final ValueNotifier<ThemeMode> temaNotifier;

  const HomePage({super.key, required this.temaNotifier});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indiceSelecionado = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Row(
        children: [
          SidebarWidget(
            indiceSelecionado: _indiceSelecionado,
            onItemSelecionado: (i) => setState(() => _indiceSelecionado = i),
          ),
          Expanded(
            child: IndexedStack(
              index: _indiceSelecionado,
              children: [
                const TarefasPage(),
                const TimesheetPage(),
                ConfiguracoesPage(temaNotifier: widget.temaNotifier),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
