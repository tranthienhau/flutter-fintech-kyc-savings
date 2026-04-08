// Powens-style DSP2 open banking client.
//
// In production this would call the Powens API over HTTPS with short-lived
// access tokens. For this POC we simulate the account linking and balance
// polling flow so the rest of the app can be built and tested end-to-end.

class Bank {
  const Bank({required this.id, required this.name, required this.logoEmoji});
  final String id;
  final String name;
  final String logoEmoji;
}

class LinkedAccount {
  const LinkedAccount({
    required this.id,
    required this.bankId,
    required this.iban,
    required this.holder,
    required this.balanceEur,
  });

  final String id;
  final String bankId;
  final String iban;
  final String holder;
  final double balanceEur;
}

class OpenBankingService {
  Future<List<Bank>> listAvailableBanks() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const [
      Bank(id: 'bnp', name: 'BNP Paribas', logoEmoji: '🏦'),
      Bank(id: 'sg', name: 'Societe Generale', logoEmoji: '💳'),
      Bank(id: 'ca', name: 'Credit Agricole', logoEmoji: '🌾'),
      Bank(id: 'boursorama', name: 'Boursorama', logoEmoji: '📈'),
      Bank(id: 'revolut', name: 'Revolut', logoEmoji: '🚀'),
    ];
  }

  Future<LinkedAccount> connectBank(Bank bank) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return LinkedAccount(
      id: 'acct_${bank.id}',
      bankId: bank.id,
      iban: 'FR76 1234 ${bank.id.toUpperCase().padRight(4, 'X')} 0000 0000 000',
      holder: 'Jane Doe',
      balanceEur: 2340.15,
    );
  }
}
