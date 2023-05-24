import 'package:flutter/cupertino.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class MyAppModel extends ChangeNotifier {
  final _sessionProvider = SessionDataProvider();
  var _isAuth = false;
  bool get isAuth => _isAuth;

  Future<void> checkAuth() async {
    final sessionId = await _sessionProvider.getSessionId();
    _isAuth = (sessionId != null);
  }

  Future<void> resetSession(BuildContext context) async {
    await _sessionProvider.setSessionId(null);
    await _sessionProvider.setAccountId(null);
    Navigator.of(context).pushNamedAndRemoveUntil(
        MainNavigationRouteNames.auth, (route) => false);
  }
}
