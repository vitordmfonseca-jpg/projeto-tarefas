import 'package:flutter/material.dart';

class ConfiguracoesPage extends StatelessWidget {
  final ValueNotifier<ThemeMode> temaNotifier;

  const ConfiguracoesPage({super.key, required this.temaNotifier});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Configurações — em breve'));
  }
}
