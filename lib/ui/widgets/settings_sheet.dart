import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/settings_provider.dart';

/// Hoja de ajustes (tema, sonido, háptica y ayudas).
Future<void> showSettingsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext sheetContext) => const _SettingsSheet(),
  );
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);
    final current = settings.settings;

    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: theme.tileEmptyBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'AJUSTES',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              color: theme.accent,
            ),
          ),
          const SizedBox(height: 14),
          _SwitchRow(
            icon: current.themeMode == ThemeMode.light
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            title: 'Tema claro',
            subtitle: current.themeMode == ThemeMode.light
                ? ' Activado'
                : ' Desactivado',
            value: current.themeMode == ThemeMode.light,
            onChanged: (_) => settings.toggleTheme(),
          ),
          _SwitchRow(
            icon: Icons.volume_up_outlined,
            title: 'Efectos de sonido',
            subtitle: current.soundEnabled ? ' Activados' : ' Desactivados',
            value: current.soundEnabled,
            onChanged: (_) => settings.toggleSound(),
          ),
          _SwitchRow(
            icon: Icons.vibration,
            title: 'Feedback háptico',
            subtitle: current.hapticsEnabled ? ' Activado' : ' Desactivado',
            value: current.hapticsEnabled,
            onChanged: (_) => settings.toggleHaptics(),
          ),
          _SwitchRow(
            icon: Icons.lightbulb_outline,
            title: 'Mostrar consejos',
            subtitle: current.showKeyboardHints
                ? ' Visible en el inicio'
                : ' Ocultos',
            value: current.showKeyboardHints,
            onChanged: (_) => settings.toggleKeyboardHints(),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: theme.tileEmptyBorder),
            ),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

/// Fila con icono, título y switch.
class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 22, color: theme.onBackground),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: theme.subtle),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
