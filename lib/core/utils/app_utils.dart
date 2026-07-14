abstract final class AppDateUtils {
  static const meses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  static const diasSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  /// Ex: "Seg, 3 de Julho de 2026"
  static String formatarDiaCompleto(DateTime data) {
    final nomeDia = diasSemana[data.weekday - 1];
    final nomeMes = meses[data.month - 1];
    return '$nomeDia, ${data.day} de $nomeMes de ${data.year}';
  }

  /// Ex: "Julho de 2026"
  static String formatarMesAno(DateTime data) {
    return '${meses[data.month - 1]} de ${data.year}';
  }

  /// Ex: "3 de Julho"
  static String formatarDiaMes(DateTime data) {
    return '${data.day} de ${meses[data.month - 1]}';
  }

  /// Ex: "Seg 03"
  static String formatarDiaCurto(DateTime data) {
    final nomeDia = diasSemana[data.weekday - 1];
    return '$nomeDia ${data.day.toString().padLeft(2, '0')}';
  }

  /// Retorna a segunda-feira da semana do dia informado
  static DateTime inicioSemana(DateTime data) {
    return DateTime(data.year, data.month, data.day - (data.weekday - 1));
  }

  /// Retorna o domingo da semana do dia informado
  static DateTime fimSemana(DateTime data) {
    return inicioSemana(data).add(const Duration(days: 6));
  }

  /// Retorna o primeiro dia do mês
  static DateTime inicioDomes(DateTime data) {
    return DateTime(data.year, data.month, 1);
  }

  /// Retorna o último dia do mês
  static DateTime fimDoMes(DateTime data) {
    return DateTime(data.year, data.month + 1, 0);
  }

  /// Retorna o primeiro dia exibido na grade do calendário (42 células),
  /// ou seja, a segunda-feira anterior (ou igual) ao dia 1 do mês.
  static DateTime inicioGradeCalendario(DateTime mesRef) {
    final primeiroDia = DateTime(mesRef.year, mesRef.month, 1);
    final espacoDia = primeiroDia.weekday - 1;
    return primeiroDia.subtract(Duration(days: espacoDia));
  }

  /// Retorna o último dia exibido na grade do calendário (42 células).
  static DateTime fimGradeCalendario(DateTime mesRef) {
    return inicioGradeCalendario(mesRef).add(const Duration(days: 41));
  }

  //Verifica qual é o dia de hj
  static bool isHoje(DateTime data) {
    final hoje = DateTime.now();
    return data.year == hoje.year &&
        data.month == hoje.month &&
        data.day == hoje.day;
  }
}
