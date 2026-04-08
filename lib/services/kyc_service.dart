// Onfido-style KYC flow: liveness capture, document upload, async polling.
//
// The production integration would hand the Onfido SDK token to the native
// Onfido iOS/Android SDK and listen for completion callbacks. This POC
// simulates the state machine so UI and navigation can be developed first.

enum KycStatus { idle, running, approved, rejected, failed }

class KycService {
  Future<void> verifyLiveness() async {
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  Future<void> uploadIdDocument() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
  }

  Future<KycStatus> pollKycStatus() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return KycStatus.approved;
  }
}
