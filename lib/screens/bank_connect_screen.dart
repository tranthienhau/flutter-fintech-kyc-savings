import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/savings_provider.dart';
import '../services/open_banking_service.dart';

class BankConnectScreen extends ConsumerStatefulWidget {
  const BankConnectScreen({super.key});

  @override
  ConsumerState<BankConnectScreen> createState() => _BankConnectScreenState();
}

class _BankConnectScreenState extends ConsumerState<BankConnectScreen> {
  late Future<List<Bank>> _banksFuture;

  @override
  void initState() {
    super.initState();
    _banksFuture = ref.read(savingsProvider.notifier).availableBanks();
  }

  @override
  Widget build(BuildContext context) {
    final linked = ref.watch(savingsProvider).linkedAccounts;
    return Scaffold(
      appBar: AppBar(title: const Text('Link a bank')),
      body: FutureBuilder<List<Bank>>(
        future: _banksFuture,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Powens DSP2 read-only access',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 12),
              ...snap.data!.map((bank) {
                final alreadyLinked =
                    linked.any((a) => a.bankId == bank.id);
                return Card(
                  color: const Color(0xFF131B2E),
                  child: ListTile(
                    leading: Text(bank.logoEmoji,
                        style: const TextStyle(fontSize: 28)),
                    title: Text(bank.name,
                        style: const TextStyle(color: Colors.white)),
                    trailing: alreadyLinked
                        ? const Icon(Icons.check_circle,
                            color: Color(0xFF4CD080))
                        : const Icon(Icons.add_link, color: Colors.white54),
                    onTap: alreadyLinked
                        ? null
                        : () async {
                            await ref
                                .read(savingsProvider.notifier)
                                .linkBank(bank);
                            if (context.mounted) setState(() {});
                          },
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
