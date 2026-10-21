import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/game_provider.dart';
import 'providers/settings_provider.dart';
import 'services/sound_service.dart';
import 'services/storage_service.dart';
import 'ui/screens/home_screen.dart';

/// Raíz de la aplicación.
///
/// Inyecta las dependencias (servicio de almacenamiento, ajustes y proveedor
/// del juego) y monta la pantalla principal.
class JergadleApp extends StatelessWidget {
  const JergadleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StorageService>(
          create: (_) => StorageService(),
          lazy: false,
        ),
        Provider<SoundService>(
          create: (_) => SoundService()..init(),
          lazy: false,
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (BuildContext context) => SettingsProvider(
            storage: context.read<StorageService>(),
            sound: context.read<SoundService>(),
          )..init(),
          lazy: false,
        ),
        ChangeNotifierProvider<GameProvider>(
          create: (BuildContext context) => GameProvider(
            storage: context.read<StorageService>(),
          )..init(),
          lazy: false,
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (BuildContext context, SettingsProvider settings, _) {
          return MaterialApp(
            title: 'Jergadle',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.settings.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
