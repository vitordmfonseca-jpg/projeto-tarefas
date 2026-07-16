abstract final class DuracaoUtils {
  /// Ex: 90 -> "1h 30m", 30 -> "30m", 120 -> "2h"
  static String formatar(int totalMinutos) {
    final horas = totalMinutos ~/ 60;
    final minutos = totalMinutos % 60;
    if (horas == 0) return '${minutos}m';
    if (minutos == 0) return '${horas}h';
    return '${horas}h ${minutos}m';
  }
}
