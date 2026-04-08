// Pure Dart savings rule engine. No Flutter imports on purpose so these
// functions can be unit-tested quickly.

class Transaction {
  const Transaction({
    required this.amountEur,
    required this.category,
    required this.timestamp,
  });

  final double amountEur;
  final String category;
  final DateTime timestamp;
}

double applyRoundUp(Transaction tx) {
  final cents = (tx.amountEur * 100).ceil();
  final rounded = ((cents + 99) ~/ 100) * 100;
  return (rounded - cents) / 100;
}

double applyPaydayPercent(double salary, double percent) {
  return (salary * percent).clamp(0, salary).toDouble();
}

double applyActivityReward({required int steps, required double euroPer10k}) {
  return (steps / 10000) * euroPer10k;
}

double applyBabySavings({required int childrenCount, required double euroPerChild}) {
  return childrenCount * euroPerChild;
}

class RuleRunResult {
  const RuleRunResult({required this.total, required this.byRule});
  final double total;
  final Map<String, double> byRule;
}

RuleRunResult runRules({
  required List<Transaction> transactions,
  required double salary,
  required double paydayPercent,
  required int steps,
  required int childrenCount,
  required Set<String> enabledRules,
}) {
  final byRule = <String, double>{};
  double total = 0;

  if (enabledRules.contains('round_up')) {
    final sum = transactions.fold<double>(0, (acc, t) => acc + applyRoundUp(t));
    byRule['round_up'] = sum;
    total += sum;
  }
  if (enabledRules.contains('payday_percent')) {
    final val = applyPaydayPercent(salary, paydayPercent);
    byRule['payday_percent'] = val;
    total += val;
  }
  if (enabledRules.contains('activity')) {
    final val = applyActivityReward(steps: steps, euroPer10k: 2);
    byRule['activity'] = val;
    total += val;
  }
  if (enabledRules.contains('baby_savings')) {
    final val = applyBabySavings(childrenCount: childrenCount, euroPerChild: 10);
    byRule['baby_savings'] = val;
    total += val;
  }

  return RuleRunResult(total: total, byRule: byRule);
}
