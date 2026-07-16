import 'package:tarefas_calendario/features/tarefas/data/database_helper.dart';

class AppDependencies {
  AppDependencies._();

  static final DatabaseHelper databaseHelper = DatabaseHelper.instance;
}
