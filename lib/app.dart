import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

/// Raíz de la aplicación.
///
/// En esta fase el `MaterialApp` es mínimo: las capas de modelo, servicio,
/// proveedor y UI se incorporan en las ramas `feature/*` siguientes.
class JergadleApp extends StatelessWidget {
  const JergadleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jergadle',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const Scaffold(
        body: Center(child: Text('Jergadle')),
      ),
    );
  }
}
