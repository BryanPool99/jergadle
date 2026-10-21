import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/game_provider.dart';
import 'services/storage_service.dart';
import 'ui/screens/game_screen.dart';

/// Raíz de la aplicación.
///
/// Inyecta las dependencias (servicio de almacenamiento y proveedor del
/// juego) y monta la pantalla principal.
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
        ChangeNotifierProvider<GameProvider>(
          create: (BuildContext context) => GameProvider(
            storage: context.read<StorageService>(),
          )..init(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Jergadle',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const GameScreen(),
      ),
    );
  }
}
