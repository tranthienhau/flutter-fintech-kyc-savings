import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/gamification_provider.dart';

class GamificationScreen extends ConsumerWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gamificationProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Badges and streaks')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _summary(game.points, game.level, game.streak),
            const SizedBox(height: 24),
            const Text('Badges',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: game.badges.map((b) {
                  return Container(
                    decoration: BoxDecoration(
                      color: b.unlocked
                          ? const Color(0xFF4CD080).withOpacity(0.12)
                          : const Color(0xFF131B2E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: b.unlocked
                            ? const Color(0xFF4CD080)
                            : Colors.white12,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: b.unlocked ? 1 : 0.3,
                          child: Text(b.emoji,
                              style: const TextStyle(fontSize: 32)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          b.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: b.unlocked
                                  ? Colors.white
                                  : Colors.white54,
                              fontSize: 11),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            FilledButton(
              onPressed: () =>
                  ref.read(gamificationProvider.notifier).addPoints(50),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('+50 points (simulate action)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summary(int points, int level, int streak) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _stat('$points', 'Points'),
          _stat('$level', 'Level'),
          _stat('$streak', 'Streak'),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white54)),
      ],
    );
  }
}
