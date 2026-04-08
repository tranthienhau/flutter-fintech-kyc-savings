import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/kyc_service.dart';

final kycServiceProvider = Provider((ref) => KycService());

class KycNotifier extends StateNotifier<KycStatus> {
  KycNotifier(this._service) : super(KycStatus.idle);

  final KycService _service;

  Future<void> runKycFlow() async {
    state = KycStatus.running;
    try {
      await _service.verifyLiveness();
      await _service.uploadIdDocument();
      state = await _service.pollKycStatus();
    } catch (_) {
      state = KycStatus.failed;
    }
  }
}

final kycProvider = StateNotifierProvider<KycNotifier, KycStatus>((ref) {
  return KycNotifier(ref.watch(kycServiceProvider));
});
