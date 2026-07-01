import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tarefas_calendario/core/theme/app_theme.dart';
import 'package:tarefas_calendario/features/home/presentation/home_page.dart';
import 'package:window_manager/window_manager.dart'
    show WindowOptions, windowManager;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o sqflite para desktop (Windows/Linux/macOS)
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    minimumSize: const Size(1024, 576),
    center: true,
    title: 'Calendário de Tarefas',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setAspectRatio(16 / 9);
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      supportedLocales: const [Locale('pt', 'BR')],
      theme: AppTheme.darkTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    ),
  );
}
