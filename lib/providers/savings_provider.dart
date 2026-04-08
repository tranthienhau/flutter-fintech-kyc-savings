import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/open_banking_service.dart';

final openBankingServiceProvider = Provider((ref) => OpenBankingService());

class SavingsState {
  const SavingsState({
    required this.balanceEur,
    required this.linkedAccounts,
    required this.enabledRules,
  });

  final double balanceEur;
  final List<LinkedAccount> linkedAccounts;
  final Set<String> enabledRules;

  SavingsState copyWith({
    double? balanceEur,
    List<LinkedAccount>? linkedAccounts,
    Set<String>? enabledRules,
  }) {
    return SavingsState(
      balanceEur: balanceEur ?? this.balanceEur,
      linkedAccounts: linkedAccounts ?? this.linkedAccounts,
      enabledRules: enabledRules ?? this.enabledRules,
    );
  }
}

class SavingsNotifier extends StateNotifier<SavingsState> {
  SavingsNotifier(this._service)
      : super(const SavingsState(
          balanceEur: 328.40,
          linkedAccounts: [],
          enabledRules: {'round_up', 'payday_percent'},
        ));

  final OpenBankingService _service;

  Future<List<Bank>> availableBanks() => _service.listAvailableBanks();

  Future<void> linkBank(Bank bank) async {
    final account = await _service.connectBank(bank);
    state = state.copyWith(
      linkedAccounts: [...state.linkedAccounts, account],
    );
  }

  void toggleRule(String rule) {
    final next = Set<String>.from(state.enabledRules);
    if (next.contains(rule)) {
      next.remove(rule);
    } else {
      next.add(rule);
    }
    state = state.copyWith(enabledRules: next);
  }
}

final savingsProvider =
    StateNotifierProvider<SavingsNotifier, SavingsState>((ref) {
  return SavingsNotifier(ref.watch(openBankingServiceProvider));
});
