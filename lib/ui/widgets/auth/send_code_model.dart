import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

import '../../../domain/data_providers/session_data_provider.dart';
import '../../../full/ui/register/step3_client_fiz_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendCodeModel extends ChangeNotifier {
  final phoneNumber = TextEditingController(text: '');
  final login = TextEditingController();
  final pass = TextEditingController();
  final otpCodeModel = TextEditingController();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;

  bool get isAuthProgress => _isAuthProgress;

  // добавляем метод из apiclient
  final _apiClient = ApiClient();

  Future<void> sendCode(BuildContext context) async {
    final phoneNum = phoneNumber.text;
    if (phoneNumber.text.isEmpty) {
      print('auth login or password wasnt typed');
      _errorMessage = "Заполните телефон номер";
      notifyListeners();
      return;
    }
    if (phoneNumber.text.length != 10) {
      print('auth login or password wasnt typed');
      _errorMessage = "Вы неправильно ввели номер телефона";
      notifyListeners();
      return;
    }

    _isAuthProgress = true;
    _errorMessage = null;
    notifyListeners();
    String? otpCode;
    try {
      otpCode = await _apiClient.authPhone(
        phoneBumber: "8${phoneNumber.text}",
        login: login.text.toString(),
        pass: pass.text.toString(),
      );
      if (otpCode.contains('verifed')) {
        _errorMessage = 'Данный номер уже зарегистрирован в системе';
      } else if (otpCode.contains('number has already registerd') ||
          otpCode.contains('occured when guest sending phone number')) {
        _errorMessage = '';

        RegetCode(
          phoneNumber: phoneNumber.text,
        ).send().then((value) {
          print('Response: $value');

          if (value.toString() == '401') {
            final provider = SessionDataProvider();
            provider.setSessionId(null);
            Navigator.of(context).pushNamedAndRemoveUntil(
                MainNavigationRouteNames.changeLang,
                (Route<dynamic> route) => false);
          }
          if (value.contains('no-number')) {
            _errorMessage = "${AppLocalizations.of(context)!.nomernenaiden}";
          } else if (value != 'error') {
            Navigator.of(context).pushNamed(
              MainNavigationRouteNames.verifyOtp,
              arguments: {
                'otpCode': otpCode,
                'phoneNum': phoneNum,
              },
            );
          } else {
            print('Не удалось отправить код');
            _errorMessage = "${AppLocalizations.of(context)!.kodneotpravlen}";
          }
        });
      } else {
        Navigator.of(context).pushNamed(
          MainNavigationRouteNames.verifyOtp,
          arguments: {
            'otpCode': otpCode,
            'phoneNum': phoneNum,
          },
        );
      }
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
          // TODO: Handle this case.
          break;
        case ApiClientExceptionType.already:
          _errorMessage = 'Этот омер телефона уже зарегистрирован системе';
          break;
      }
    }
    _isAuthProgress = false;
    if (_errorMessage != null) {
      notifyListeners();
      return;
    }

    if (otpCode == null) {
      _errorMessage = '${AppLocalizations.of(context)!.kodneotpravlen}';
      notifyListeners();
      return;
    }
  }
}
