import 'package:flutter/material.dart';
import 'package:tarefas_calendario/core/extensions/ext_datetime.dart';
import 'package:tarefas_calendario/core/theme/app_gradient.dart';
import 'package:tarefas_calendario/core/ui_components/calendario/custom_calendario_viewmodel.dart';

class CustomCalendarioWidget extends StatefulWidget {
  const CustomCalendarioWidget({
    super.key,
    required this.mesAtual,
    required this.diaSelecionado,
    this.diasComRegistro = const {},
    this.onMesAlterado,
  });

  final DateTime mesAtual;
  final void Function(DateTime diaSelec) diaSelecionado;
  final Set<DateTime> diasComRegistro;
  final void Function(int mes, int ano)? onMesAlterado;

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
            _CalendarioHeaderWidget(
              mesFormatado:
                  '${_viewModel.mesAtual.formataMesPt().toUpperCase()} - ${_viewModel.mesAtual.year}',
              onMesAnterior: () {
                _viewModel.mesAnterior();
                widget.onMesAlterado?.call(_mesAtual.month, _mesAtual.year);
              },
              onHoje: () {
                _viewModel.irParaHoje();
                widget.onMesAlterado?.call(_mesAtual.month, _mesAtual.year);
                widget.diaSelecionado(DateTime.now());
              },
              onProxMes: () {
                _viewModel.proxMes();
                widget.onMesAlterado?.call(_mesAtual.month, _mesAtual.year);
              },
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
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
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
                            final chave = DateTime(
                              dia.year,
                              dia.month,
                              dia.day,
                            );

                            return Expanded(
                              child: _CalendarioDiaWidget(
                                dia: dia,
                                isDiaSelecionado: isDiaSelecionado,
                                isMesAtual:
                                    dia.month == _viewModel.mesAtual.month,
                                isHoje: DateTime.now().isMesmoDia(dia),
                                temRegistro: widget.diasComRegistro.contains(
                                  chave,
                                ),
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

class _CalendarioHeaderWidget extends StatelessWidget {
  const _CalendarioHeaderWidget({
    required this.mesFormatado,
    required this.onMesAnterior,
    required this.onHoje,
    required this.onProxMes,
  });

  final String mesFormatado;
  final VoidCallback onMesAnterior;
  final VoidCallback onHoje;
  final VoidCallback onProxMes;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        gradient: Theme.of(context).extension<AppGradient>()!.headerGradient,
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
              onPressed: onMesAnterior,
              icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
            ),
          ),
          Text(mesFormatado, style: TextStyle(color: colorScheme.onPrimary)),
          Row(
            children: [
              IconButton(
                onPressed: onHoje,
                icon: Icon(
                  Icons.today_outlined,
                  color: colorScheme.onPrimary,
                ),
                tooltip: 'Hoje',
              ),
              IconButton(
                onPressed: onProxMes,
                icon: Icon(Icons.arrow_forward, color: colorScheme.onPrimary),
              ),
            ],
          ),
        ],
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
    required this.temRegistro,
    required this.selecionaDia,
  });

  final DateTime dia;
  final bool isDiaSelecionado;
  final bool isMesAtual;
  final bool isHoje;
  final bool temRegistro;
  final void Function() selecionaDia;

  Color? _corFundo(ColorScheme colorScheme) {
    if (isDiaSelecionado) return colorScheme.primary;
    if (isHoje) return colorScheme.secondary;
    return null;
  }

  Color _corTexto(ColorScheme colorScheme) {
    if (isDiaSelecionado) return colorScheme.onPrimary;
    if (isHoje) return colorScheme.onSecondary;
    if (isMesAtual) return colorScheme.onSurface;
    return colorScheme.onSurface.withValues(alpha: 0.3);
  }

  Color _corDot(ColorScheme colorScheme) {
    if (isDiaSelecionado) return colorScheme.onPrimary;
    if (isHoje) return colorScheme.onPrimary;
    return colorScheme.secondary;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: selecionaDia,
        borderRadius: BorderRadius.circular(15),
        overlayColor: WidgetStateProperty.all(
          colorScheme.primary.withValues(alpha: 0.08),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: _corFundo(colorScheme),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  dia.day.toString(),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: _corTexto(colorScheme),
                  ),
                ),
              ),
              if (temRegistro)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,

                    decoration: BoxDecoration(
                      color: _corDot(colorScheme),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
