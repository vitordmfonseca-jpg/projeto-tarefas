import 'package:flutter/material.dart';
import 'package:tarefas_calendario/features/tarefas/presentation/pages/tarefas_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tarefas')),

      body: TarefasPage(),
    );
  }
}
