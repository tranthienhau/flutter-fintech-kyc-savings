import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/subscriptions_service.dart';

final subscriptionsServiceProvider =
    Provider((ref) => SubscriptionsService());

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() =>
      _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  SubscriptionEntitlement? _entitlement;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final e = await ref
        .read(subscriptionsServiceProvider)
        .isPremiumActive();
    if (mounted) setState(() => _entitlement = e);
  }

  Future<void> _purchase() async {
    setState(() => _busy = true);
    final e = await ref
        .read(subscriptionsServiceProvider)
        .purchasePremium();
    if (mounted) setState(() {
      _entitlement = e;
      _busy = false;
    });
  }

  Future<void> _restore() async {
    setState(() => _busy = true);
    final e = await ref
        .read(subscriptionsServiceProvider)
        .restorePurchases();
    if (mounted) setState(() {
      _entitlement = e;
      _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('RevenueCat-style entitlement gating.',
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _entitlement?.active == true
                        ? 'Premium active ✅'
                        : 'Free tier',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _entitlement == null
                        ? 'Checking...'
                        : 'Plan: ${_entitlement!.plan}',
                    style: const TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _busy ? null : _purchase,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Buy premium yearly'),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _busy ? null : _restore,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Restore purchases'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
