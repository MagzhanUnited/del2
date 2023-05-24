import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  //Указать от кого наследуется
  final loginTextController = TextEditingController(text: 'tolegen095');
  final passwordTextController = TextEditingController();
  final phoneNumber = TextEditingController(text: '+7 707 168 68 99');
  final code = TextEditingController();

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;

  bool get canStartAuth => !_isAuthProgress;

  bool get isAuthProgress => _isAuthProgress;

  // String? _sessionId;
// добавляем метод из apiclient
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;
    if (login.isEmpty || password.isEmpty) {
      print('auth login or password wasnt typed');
      _errorMessage = "Заполните логин и пароль";
      notifyListeners();
      return;
    }
    _isAuthProgress = true;
    _errorMessage = null;
    notifyListeners();
    String? sessionId;
    int? accountId;
    try {
      sessionId = await _apiClient.auth(username: login, password: password);
      accountId = await _apiClient.getAccountInfo(sessionId);
      print('$sessionId');
      print('$accountId');
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.Network:
          _errorMessage = 'Повторите попытку. Проверьте интеренет соединение';
          break;
        case ApiClientExceptionType.Auth:
          _errorMessage = 'Неверный логин или пароль';

          break;
        case ApiClientExceptionType.Other:
          _errorMessage = 'Повторите запрос';

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
    if (sessionId == null || accountId == null) {
      _errorMessage = 'Не получен id сессии';
      notifyListeners();
      return;
    }
    await _sessionDataProvider.setSessionId(sessionId);
    await _sessionDataProvider.setAccountId(accountId);

    // Navigator.of(context).pushNamed('/main_screen');
    // Navigator.of(context).pushNamed(RouteScreen.mainScreen);
    Navigator.of(context)
        .pushReplacementNamed(MainNavigationRouteNames.mainScreen);

    //notifyListeners();
    //_sessionId =_apiKlient.auth(username: login, password: password);
  }

  Future<void> authCode(BuildContext context) async {
    final phoneNum = phoneNumber.text;
    final CodeSms = code.text;
    if (CodeSms.isEmpty) {
      print('auth login or password wasnt typed');
      _errorMessage = "Заполните code";
      notifyListeners();
      return;
    }
    _isAuthProgress = true;
    _errorMessage = null;
    notifyListeners();
    String? sessionId;
    int? accountId;
    try {
      sessionId = await _apiClient.authToken(phoneBumber: phoneNum, code: CodeSms);
      accountId = 1;
      print('$sessionId');
      print('$accountId');
      _isAuthProgress = false;
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
    if (sessionId == null || accountId == null) {
      _errorMessage = 'Не получен id сессии';
      notifyListeners();
      return;
    }
    await _sessionDataProvider.setSessionId(sessionId);
    await _sessionDataProvider.setAccountId(accountId);

    // Navigator.of(context).pushNamed('/main_screen');
    // Navigator.of(context).pushNamed(RouteScreen.mainScreen);
    Navigator.of(context)
        .pushReplacementNamed(MainNavigationRouteNames.mainScreen);

    //notifyListeners();
    //_sessionId =_apiKlient.auth(username: login, password: password);
  }

  Future<void> authPhone(BuildContext context) async {
    final phoneNum = phoneNumber.text;
    if (phoneNum.isEmpty) {
      print('auth login or password wasnt typed');
      _errorMessage = "Заполните телефон номер";
      notifyListeners();
      return;
    }
    _isAuthProgress = true;
    _errorMessage = null;
    notifyListeners();
    String? sessionId;
    try {
      // sessionId = await _apiClient.authPhone(phoneBumber: phoneNum);
      sessionId = await _apiClient.authPhone(phoneBumber: phoneNum, login: '', pass: '');
      _errorMessage = sessionId;
      _isAuthProgress = false;
      notifyListeners();
      // accountId = await _apiClient.getAccountInfo(sessionId);
      // print('$sessionId');
      // print('$accountId');
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
    // _isAuthProgress = false;
    // if (_errorMessage != null) {
    //   notifyListeners();
    //   return;
    // }
    // if (sessionId == null || accountId == null) {
    //   _errorMessage = 'Не получен id сессии';
    //   notifyListeners();
    //   return;
    // }
    // await _sessionDataProvider.setSessionId(sessionId);
    // await _sessionDataProvider.setAccountId(accountId);

    // // Navigator.of(context).pushNamed('/main_screen');
    // // Navigator.of(context).pushNamed(RouteScreen.mainScreen);
    // Navigator.of(context)
    //     .pushReplacementNamed(MainNavigationRouteNames.mainScreen);

    //notifyListeners();
    //_sessionId =_apiKlient.auth(username: login, password: password);
  }
}

// class AuthProvider extends InheritedNotifier {
//   //не забыть поменять от кого наследуется инхерит
//   AuthProvider({Key? key, required this.model, required this.child})
//       : super(key: key, notifier: model, child: child);
//   final AuthModel model;
//   final Widget child;
//
//   static AuthProvider? watch(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<AuthProvider>();
//   }
//
//   static AuthProvider? read(BuildContext context) {
//     final widget =
//         context.getElementForInheritedWidgetOfExactType<AuthProvider>()?.widget;
//     return widget is AuthProvider ? widget : null;
//   }
// }
