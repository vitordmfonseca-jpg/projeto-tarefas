import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/extensions/ext_datetime.dart';
import 'package:tarefas_calendario/core/theme/app_gradient.dart';
import 'package:tarefas_calendario/core/ui_components/calendario/custom_calendario_viewmodel.dart';

class CustomCalendarioWidget extends StatefulWidget {
  const CustomCalendarioWidget({
    super.key,
    required this.mesAtual,
    required this.diaSelecionado,
  });
  final DateTime mesAtual;
  final void Function(DateTime diaSelec) diaSelecionado;

  @override
  State<CustomCalendarioWidget> createState() => _CustomCalendarioWidgetState();
}

class _CustomCalendarioWidgetState extends State<CustomCalendarioWidget> {
  DateTime get _mesAtual => widget.mesAtual;
  final _viewModel = CustomCalendarioViewmodel();

  @override
  void initState() {
    super.initState();
    _viewModel
      ..diaSelecionado = _mesAtual
      ..diasDoMes(_mesAtual);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) => Column(
          spacing: 16.0,
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                gradient: Theme.of(
                  context,
                ).extension<AppGradient>()!.headerGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 32.0),
                    child: IconButton(
                      onPressed: () => _viewModel.mesAnterior(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '${_viewModel.mesAtual.formataMesPt().toUpperCase()} - ${_viewModel.mesAtual.year}',
                    style: TextStyle(color: colorScheme.onPrimary),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _viewModel.irParaHoje();
                          widget.diaSelecionado(DateTime.now());
                        },
                        icon: Icon(
                          Icons.today_outlined,
                          color: colorScheme.onPrimary,
                        ),
                        tooltip: 'Hoje',
                      ),
                      IconButton(
                        onPressed: () => _viewModel.proxMes(),
                        icon: Icon(
                          Icons.arrow_forward,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 8.0,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ..._viewModel.diasSemana.map(
                          (e) => Expanded(
                            child: Text(
                              e,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.6),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...List.generate(
                      6,
                      (idxSemana) => Expanded(
                        child: Row(
                          spacing: 8.0,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: List.generate(7, (idxDia) {
                            final idxDiaSemana = (idxSemana * 7) + idxDia;
                            final dia = _viewModel.diasMes[idxDiaSemana];

                            final isDiaSelecionado =
                                _viewModel.diaSelecionado?.isMesmoDia(dia) ??
                                false;

                            return Expanded(
                              child: _CalendarioDiaWidget(
                                dia: dia,
                                isDiaSelecionado: isDiaSelecionado,
                                isMesAtual:
                                    dia.month == _viewModel.mesAtual.month,
                                isHoje: DateTime.now().isMesmoDia(dia),
                                selecionaDia: () {
                                  _viewModel.diaSelecionado = dia;
                                  widget.diaSelecionado(dia);
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarioDiaWidget extends StatelessWidget {
  const _CalendarioDiaWidget({
    required this.dia,
    required this.isDiaSelecionado,
    required this.isMesAtual,
    required this.isHoje,
    required this.selecionaDia,
  });

  final DateTime dia;
  final bool isDiaSelecionado;
  final bool isMesAtual;
  final bool isHoje;
  final void Function() selecionaDia;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color? corFundo() {
      if (isDiaSelecionado) return colorScheme.primary;
      if (isHoje) return colorScheme.secondary;
      return null;
    }

    Color corTexto() {
      if (isDiaSelecionado) return colorScheme.onPrimary;
      if (isHoje) return colorScheme.onSecondary;
      if (isMesAtual) return colorScheme.onSurface;
      return colorScheme.onSurface.withOpacity(0.3);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: selecionaDia,
        borderRadius: BorderRadius.circular(15),
        overlayColor: WidgetStateProperty.all(
          colorScheme.primary.withValues(alpha: 0.08),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: corFundo(),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                dia.day.toString(),
                style: TextStyle(fontSize: 16.0, color: corTexto()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
