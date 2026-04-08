import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/gamification_provider.dart';
import '../providers/savings_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savings = ref.watch(savingsProvider);
    final game = ref.watch(gamificationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gamified Savings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _BalanceCard(balanceEur: savings.balanceEur),
          const SizedBox(height: 16),
          _StatRow(points: game.points, streak: game.streak, level: game.level),
          const SizedBox(height: 24),
          _NavTile(
            emoji: '🪪',
            title: 'Identity verification',
            subtitle: 'Onfido liveness + ID scan',
            onTap: () => context.push('/kyc'),
          ),
          _NavTile(
            emoji: '🏦',
            title: 'Link a bank',
            subtitle: 'Powens DSP2 read-only access',
            onTap: () => context.push('/bank-connect'),
          ),
          _NavTile(
            emoji: '⚙️',
            title: 'Smart rules',
            subtitle: 'Round-ups, payday, activity, baby',
            onTap: () => context.push('/rules'),
          ),
          _NavTile(
            emoji: '🏆',
            title: 'Badges and streaks',
            subtitle: '${game.points} pts, level ${game.level}',
            onTap: () => context.push('/gamification'),
          ),
          _NavTile(
            emoji: '💎',
            title: 'Premium',
            subtitle: 'RevenueCat entitlement',
            onTap: () => context.push('/subscription'),
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balanceEur});
  final double balanceEur;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF26C281), Color(0xFF1E90B5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Saved this month',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 6),
          Text('€${balanceEur.toStringAsFixed(2)}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text('Automatic smart savings - on track for October goal',
              style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.points, required this.streak, required this.level});
  final int points;
  final int streak;
  final int level;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _stat('🏆', '$points', 'points'),
        _stat('🔥', '$streak', 'day streak'),
        _stat('⭐', '$level', 'level'),
      ],
    );
  }

  Widget _stat(String emoji, String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(color: Colors.white54, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white38),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
