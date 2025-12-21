import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  LocalAuthentication localAuthentication = LocalAuthentication();

  Future<bool> authenticateWithBiometrics() async {
    try {
      final isAuthenticated = await localAuthentication.authenticate(
        localizedReason: "Unlock to access private notes",
        biometricOnly: false,
       // useErrorDialogs: true,
       // stickyAuth: true,
      );
      return isAuthenticated;
    } catch (e) {
      print('Biometric authentication error: $e');
      return false;
    }
  }
}
