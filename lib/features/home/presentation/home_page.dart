import 'package:flutter/material.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/pages/tarefas_page.dart';

class HomePage extends StatelessWidget {
  final ValueNotifier<ThemeMode> temaNotifier;

  const HomePage({super.key, required this.temaNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: const Text(
          'Tarefas',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: temaNotifier,
            builder: (_, modo, __) => IconButton(
              tooltip: modo == ThemeMode.dark ? 'Modo claro' : 'Modo escuro',
              icon: Icon(
                modo == ThemeMode.dark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
              onPressed: () => temaNotifier.value = modo == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark,
            ),
          ),
        ],
      ),
      body: const TarefasPage(),
    );
  }
}
