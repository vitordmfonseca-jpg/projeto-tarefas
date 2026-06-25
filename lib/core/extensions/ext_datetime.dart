import 'package:intl/intl.dart';

extension ExtDatetime on DateTime {
  String formataMesPt() {
    return DateFormat('MMMM', 'pt_BR').format(this);
  }

  bool isMesmoDia(DateTime dia) {
    return day == dia.day && month == dia.month && year == dia.year;
  }
}
