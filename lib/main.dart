import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:tarefas_calendario/core/theme/app_theme.dart';
import 'package:tarefas_calendario/features/splash/presentation/pages/splash_page.dart';
import 'package:window_manager/window_manager.dart'
    show WindowOptions, windowManager;

// Notifier global — ouvido pelo MaterialApp para trocar o tema
final temaNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // launchAtStartup configurado com valores fixos — não depende do PackageInfo
  launchAtStartup.setup(
    appName: 'Calendário de Tarefas',
    appPath: Platform.resolvedExecutable,
    packageName: 'dev.vitor.tarefas_calendario',
  );

  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    minimumSize: Size(1024, 576),
    center: true,
    title: 'Calendário de Tarefas',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setAspectRatio(16 / 9);
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    ValueListenableBuilder<ThemeMode>(
      valueListenable: temaNotifier,
      builder: (_, modo, __) => MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: modo,
        debugShowCheckedModeBanner: false,
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const SplashPage(),
      ),
    ),
  );
}
