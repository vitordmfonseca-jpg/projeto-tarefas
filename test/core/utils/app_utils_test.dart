import 'package:flutter_test/flutter_test.dart';
import 'package:tarefas_calendario/core/utils/app_utils.dart';

void main() {
  test('domingo pertence à semana que começou na segunda anterior', () {
    final domingo = DateTime(2026, 7, 19);
    expect(AppDateUtils.inicioSemana(domingo), DateTime(2026, 7, 13));
    expect(AppDateUtils.fimSemana(domingo), DateTime(2026, 7, 19));
  });

  test('fevereiro em ano bissexto tem 29 dias', () {
    expect(AppDateUtils.fimDoMes(DateTime(2028, 2, 1)), DateTime(2028, 2, 29));
  });

  test('dezembro vira o ano corretamente', () {
    expect(AppDateUtils.fimDoMes(DateTime(2026, 12, 5)), DateTime(2026, 12, 31));
  });

  test('grade do calendário tem 42 dias e começa numa segunda-feira', () {
    final inicio = AppDateUtils.inicioGradeCalendario(DateTime(2026, 7, 1));
    final fim = AppDateUtils.fimGradeCalendario(DateTime(2026, 7, 1));
    expect(inicio.weekday, DateTime.monday);
    expect(fim.difference(inicio).inDays, 41);
  });
}
