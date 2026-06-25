import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/theme/cor_padrao.dart';
import 'package:tarefas_calendario/core/ui_components/calendario/custom_calendario_widget.dart';

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          spacing: 8.0,
          children: [
            Flexible(
              flex: 2,
              child: SizedBox(
                child: CustomCalendarioWidget(
                  mesAtual: DateTime.now(),
                  diaSelecionado: (dia) {},
                ),
              ),
            ),
            Flexible(child: Container(color: CorPadrao.corPrimaria)),
          ],
        ),
      ),
    );
  }
}
