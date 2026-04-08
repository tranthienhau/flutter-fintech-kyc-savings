import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/savings_provider.dart';

class RulesScreen extends ConsumerWidget {
  const RulesScreen({super.key});

  static const _rules = [
    _RuleDef('round_up', 'Round-ups', 'Round every purchase to the next euro'),
    _RuleDef('payday_percent', 'Payday %',
        'Auto-transfer a fixed percent on salary day'),
    _RuleDef('activity', 'Activity savings',
        'Reward steps and workouts via HealthKit + Google Fit'),
    _RuleDef('baby_savings', 'Baby savings',
        'Set-aside per child each month'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(savingsProvider).enabledRules;
    return Scaffold(
      appBar: AppBar(title: const Text('Smart rules')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _rules.map((r) {
          return Card(
            color: const Color(0xFF131B2E),
            child: SwitchListTile(
              value: enabled.contains(r.id),
              onChanged: (_) =>
                  ref.read(savingsProvider.notifier).toggleRule(r.id),
              title: Text(r.label,
                  style: const TextStyle(color: Colors.white)),
              subtitle: Text(r.description,
                  style: const TextStyle(color: Colors.white54)),
              activeColor: const Color(0xFF4CD080),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _RuleDef {
  const _RuleDef(this.id, this.label, this.description);
  final String id;
  final String label;
  final String description;
}
