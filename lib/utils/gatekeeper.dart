import 'package:Passwall/localization/localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';

class GateKeeper {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<bool> authenticator(BuildContext context) async {
    bool _authenticated;
    try {
      _authenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: AppLocalizations.of(context).trans("auth_reason"),
        useErrorDialogs: true,
        stickyAuth: true,
      );
      return _authenticated;
    } catch (e) {
      print(e);
      return (e.code == "OtherOperatingSystem") ? true : false;
    }
  }
}
