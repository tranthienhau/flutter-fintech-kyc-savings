import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_fintech_kyc_savings/app.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> shoot(WidgetTester tester, String name) async {
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot(name);
  }

  testWidgets('capture fintech savings flow', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SavingsApp()));
    await tester.pumpAndSettle();

    // 01 - Dashboard with balance card, stats and smart-savings nav tiles.
    await shoot(tester, '01-dashboard');

    // 02 - Gamification: badges grid, points / level / streak.
    await tester.tap(find.text('Badges and streaks'));
    await tester.pumpAndSettle();
    await shoot(tester, '02-badges');

    // Back to the dashboard.
    await tester.pageBack();
    await tester.pumpAndSettle();

    // 03 - Smart rules: round-ups, payday %, activity, baby savings toggles.
    await tester.tap(find.text('Smart rules'));
    await tester.pumpAndSettle();
    await shoot(tester, '03-rules');

    // Back to the dashboard.
    await tester.pageBack();
    await tester.pumpAndSettle();

    // 04 - Identity verification (Onfido-style KYC) screen.
    await tester.tap(find.text('Identity verification'));
    await tester.pumpAndSettle();
    await shoot(tester, '04-kyc');
  });
}
