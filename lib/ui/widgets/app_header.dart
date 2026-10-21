import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/game_stats.dart';

/// Cabecera de la aplicación: título, racha actual y botón de estadísticas.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.stats,
    required this.onStatsPressed,
    this.dayNumber,
    this.onBackPressed,
  });

  /// Estadísticas mostradas en la cabecera.
  final GameStats stats;

  /// Callback al pulsar el botón de estadísticas.
  final VoidCallback onStatsPressed;

  /// Número de día del challenge (opcional).
  final int? dayNumber;

  /// Callback al pulsar el botón de volver (opcional).
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
        child: Row(
          children: <Widget>[
            if (onBackPressed != null)
              IconButton(
                tooltip: 'Volver al inicio',
                onPressed: onBackPressed,
                icon: Icon(Icons.arrow_back, color: theme.onBackground),
              )
            else
              const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'JERGADLE',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                      color: theme.accent,
                    ),
                  ),
                  Text(
                    dayNumber != null ? 'Jerga del día #$dayNumber' : 'La jerga del día',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.subtle,
                    ),
                  ),
                ],
              ),
            ),
            _StreakBadge(streak: stats.currentStreak),
            IconButton(
              tooltip: 'Estadísticas',
              onPressed: onStatsPressed,
              icon: Icon(Icons.bar_chart, color: theme.onBackground),
            ),
          ],
        ),
      ),
    );
  }
}

/// Insignia con la racha actual.
class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.tileEmpty,
        border: Border.all(color: theme.tileEmptyBorder),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.local_fire_department,
            color: theme.accent,
            size: 18,
          ),
          const SizedBox(width: 4),
          Text(
            '$streak',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
