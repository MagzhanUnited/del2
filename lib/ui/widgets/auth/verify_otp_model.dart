import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class VerifyOtpModel extends ChangeNotifier {
  final code = TextEditingController();
  final phoneNumber = TextEditingController();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;

  bool get isAuthProgress => _isAuthProgress;

  // добавляем метод из apiclient
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();

  Future<void> authCode(BuildContext context) async {
    final otpCode = code.text;
    final phoneNum = "8" + phoneNumber.text;
    if (otpCode.isEmpty) {
      print('Введите код подтверждения');
      _errorMessage = "Введите код подтверждения";
      notifyListeners();
      return;
    }
    _isAuthProgress = true;
    _errorMessage = null;
    notifyListeners();
    String? sessionId;
    String? IsComp;
    String? roleType;
    try {
      final jsondata =
          await _apiClient.authToken(phoneBumber: phoneNum, code: otpCode);

      if (jsondata == 'code error') {
        _errorMessage = 'неверный код подтверждения';
        notifyListeners();
        _isAuthProgress = false;
        return;
      }

      final dynamic json1 = await jsonDecode(jsondata);

      sessionId = json1["AccessToken"].toString();
      IsComp = json1["IsComp"].toString();
      roleType = json1["UserType"].toString();

      print('$sessionId');
      _isAuthProgress = false;
      notifyListeners();
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.Network:
          _errorMessage = 'Повторите попытку. Проверьте интеренет соединение';
          break;
        case ApiClientExceptionType.Auth:
          _errorMessage = 'Неверный логин или пароль';

          break;
        case ApiClientExceptionType.Other:
          _errorMessage = 'Повторите запрос.';

          break;
        case ApiClientExceptionType.SessionExpired:
          // ignore: todo
          break;
        case ApiClientExceptionType.already:
          //
          break;
      }
    }
    _isAuthProgress = false;

    if (_errorMessage != null) {
      notifyListeners();
      return;
    }
    if (sessionId == null) {
      _errorMessage = 'Не получен id сессии';
      notifyListeners();
      return;
    }
    await _sessionDataProvider.setSessionId(sessionId);
    await _sessionDataProvider.setPhoneNumber(phoneNum);
    await _sessionDataProvider.setIsComp(IsComp);
    await _sessionDataProvider.setRoleType(roleType);

    // Navigator.of(context).pushNamed('/main_screen');
    // Navigator.of(context).pushNamed(RouteScreen.mainScreen);
    // Navigator.of(context).pushReplacementNamed(
    //   MainNavigationRouteNames.mainScreen,
    // );

    Navigator.of(context).pushNamedAndRemoveUntil(
        MainNavigationRouteNames.mainScreen, (Route<dynamic> route) => false);
  }
}
