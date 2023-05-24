import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';

class ClientIndiModel extends ChangeNotifier {
  final fName = TextEditingController();
  final lName = TextEditingController();
  final pName = TextEditingController();
  final iin = TextEditingController();
  final eMail = TextEditingController();
  final token = TextEditingController();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;

  bool get isAuthProgress => _isAuthProgress;

  // добавляем метод из apiclient
  final _apiClient = ApiClient();

  Future<void> sendRegData(BuildContext context) async {
    // final phoneNum = "+7";
    // if (phoneNum.isEmpty) {
    //   print('auth login or password wasnt typed');
    //   _errorMessage = "Заполните телефон номер";
    //   notifyListeners();
    //   return;
    // }
    _isAuthProgress = false;
    _errorMessage = null;
    notifyListeners();
    String? otpCode;
    try {
      final parameters = <String, dynamic>{
        'clientId': 0,
        'photo': 'base64string',
        'firstName': fName.text,
        'lastName': lName.text,
        'email': eMail.text,
        'iin': iin.text
      };

      print(parameters);

      otpCode = await _apiClient.sendRegData(
        data: parameters,
        token1: token.text,
      );

      if (otpCode.contains('Duplicate')) {
        _errorMessage = 'Данный пользователь уже зарегистрирован в системе';
        print(_errorMessage);
        notifyListeners();
        return;
      }

      if (otpCode.contains('success')) {
        _errorMessage = 'Успешная регистрация!';
        print(_errorMessage);
        notifyListeners();

        // final pm = ProfileModel();
        // pm.setupLocale(context);

        // if (pm.token == '') return const SizedBox.shrink();

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => NotifierProvider(
        //       create: () => pm,
        //       child: ProfileView(),
        //       //указываем что виджет управляется не сам
        //       isManagingModel: false,
        //     ),
        //   ),
        // );
        
        return;
      }

      // _errorMessage = otpCode;
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
          break;
      }
    }
    // _isAuthProgress = false;
    // if (_errorMessage != null) {
    //   notifyListeners();
    //   return;
    // }
    // if (otpCode == null) {
    //   _errorMessage = 'Не удалось отправить код проверки';
    //   notifyListeners();
    //   return;
    // }
  }
}
