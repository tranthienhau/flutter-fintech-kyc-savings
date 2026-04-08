import 'package:flutter_riverpod/flutter_riverpod.dart';

class Badge {
  const Badge({required this.id, required this.label, required this.emoji, required this.unlocked});
  final String id;
  final String label;
  final String emoji;
  final bool unlocked;
}

class GamificationState {
  const GamificationState({
    required this.points,
    required this.level,
    required this.streak,
    required this.badges,
  });

  final int points;
  final int level;
  final int streak;
  final List<Badge> badges;
}

class GamificationNotifier extends StateNotifier<GamificationState> {
  GamificationNotifier()
      : super(const GamificationState(
          points: 1240,
          level: 4,
          streak: 17,
          badges: [
            Badge(id: 'first_save', label: 'First Save', emoji: '🌱', unlocked: true),
            Badge(id: 'week_streak', label: '7 Day Streak', emoji: '🔥', unlocked: true),
            Badge(id: 'round_up_50', label: '50 Round-ups', emoji: '🪙', unlocked: true),
            Badge(id: 'payday_pro', label: 'Payday Pro', emoji: '💰', unlocked: true),
            Badge(id: 'first_100', label: 'First 100 EUR', emoji: '💯', unlocked: false),
            Badge(id: 'baby_saver', label: 'Baby Saver', emoji: '👶', unlocked: false),
          ],
        ));

  void addPoints(int delta) {
    state = GamificationState(
      points: state.points + delta,
      level: ((state.points + delta) ~/ 400) + 1,
      streak: state.streak,
      badges: state.badges,
    );
  }
}

final gamificationProvider =
    StateNotifierProvider<GamificationNotifier, GamificationState>((ref) {
  return GamificationNotifier();
});
