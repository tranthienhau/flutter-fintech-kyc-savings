// RevenueCat-style premium entitlement check, purchase, and restore.

class SubscriptionEntitlement {
  const SubscriptionEntitlement({
    required this.active,
    required this.plan,
    required this.renewsAt,
  });

  final bool active;
  final String plan;
  final DateTime? renewsAt;
}

class SubscriptionsService {
  SubscriptionEntitlement _entitlement = const SubscriptionEntitlement(
    active: false,
    plan: 'free',
    renewsAt: null,
  );

  Future<SubscriptionEntitlement> isPremiumActive() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _entitlement;
  }

  Future<SubscriptionEntitlement> purchasePremium() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _entitlement = SubscriptionEntitlement(
      active: true,
      plan: 'premium_yearly',
      renewsAt: DateTime.now().add(const Duration(days: 365)),
    );
    return _entitlement;
  }

  Future<SubscriptionEntitlement> restorePurchases() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return _entitlement;
  }
}
