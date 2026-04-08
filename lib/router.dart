import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/bank_connect_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/gamification_screen.dart';
import 'screens/kyc_screen.dart';
import 'screens/rules_screen.dart';
import 'screens/subscription_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
      GoRoute(path: '/kyc', builder: (_, __) => const KycScreen()),
      GoRoute(path: '/bank-connect', builder: (_, __) => const BankConnectScreen()),
      GoRoute(path: '/rules', builder: (_, __) => const RulesScreen()),
      GoRoute(path: '/gamification', builder: (_, __) => const GamificationScreen()),
      GoRoute(path: '/subscription', builder: (_, __) => const SubscriptionScreen()),
    ],
  );
});
