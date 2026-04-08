import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/kyc_provider.dart';
import '../services/kyc_service.dart';

class KycScreen extends ConsumerWidget {
  const KycScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(kycProvider);

    String headline;
    Color color;
    switch (status) {
      case KycStatus.idle:
        headline = 'Start identity verification';
        color = Colors.white;
        break;
      case KycStatus.running:
        headline = 'Running liveness + document checks...';
        color = const Color(0xFFF5C242);
        break;
      case KycStatus.approved:
        headline = 'Approved ✅';
        color = const Color(0xFF4CD080);
        break;
      case KycStatus.rejected:
        headline = 'Rejected';
        color = const Color(0xFFF26565);
        break;
      case KycStatus.failed:
        headline = 'Verification failed, please retry';
        color = const Color(0xFFF26565);
        break;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('KYC')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Onfido-style flow: liveness capture, ID document upload, then async status polling.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 32),
            Text(
              headline,
              style: TextStyle(
                  color: color, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: status == KycStatus.running
                  ? null
                  : () => ref.read(kycProvider.notifier).runKycFlow(),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Run KYC flow'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
