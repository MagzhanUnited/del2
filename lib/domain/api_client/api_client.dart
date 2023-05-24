import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// перечисление ошибок
enum ApiClientExceptionType { Network, Auth, Other, SessionExpired, already }

//Создаем класс ошибок для этого имплементируем класс Exception
class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException(this.type);
}

enum MediaType { Movie, TV }

extension MediaTypeAsString on MediaType {
  String asString() {
    switch (this) {
      case MediaType.Movie:
        return 'movie';
      case MediaType.TV:
        return 'TV';
    }
  }
}

class ApiClient {
  static String imageUrl(String path) {
    return '$_imageUrl$path';
  }

  final _client = HttpClient();
  static const _host =
      'https://api.themoviedb.org/3'; //куда мы будем отправлять запросы все запросы начинаются с этого урл
  static const _imageUrl =
      'https://image.tmdb.org/t/p/w500'; // если нужны картинки они лежат тут
  static const _apiKey =
      'b0ff4f3b0339894f5389976e46033017'; // апи кей этот ключ в личном кабинете с помощью него можно работать с прогой

  Future<T> _get<T>(
    String path,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? parameters,
  ]) async {
    final url = _makeUri(path, parameters);
    try {
      final request = await _client.getUrl(url);
      final response = await request.close();
      final dynamic json = (await response.jsonDecode());
      _validateResponse(response, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      print(e);
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<T> _post<T>(
    String path,
    Map<String, dynamic> bodyParameters,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? urlParameters,
  ]) async {
    try {
      final url = _makeUri(path, urlParameters);
      final request = await _client.postUrl(
        url,
      );
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyParameters));
      final response = await request.close();
      final dynamic json = (await response.jsonDecode());
      _validateResponse(response, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<String> _postRegData<T>(
    String path,
    Map<String, dynamic> bodyParameters,
    T Function(dynamic json) parser, [
    // ignore: unused_element
    Map<String, dynamic>? urlParameters,
    String? token,
  ]) async {
    try {
      final url = Uri.parse(path);
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      Map<String, Object> jsonMap = {
        "clientIndivisual": bodyParameters,
        "sysUserType": 1
      };
      var response1 = await http
          .post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      )
          .timeout(
        Duration(seconds: 20),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 500); // Replace 500 with your http code.
        },
      );
      print("Response status: ${response1.statusCode}");
      print("Response body: ${response1.body}");

      //server error dublicate

      return response1.body;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<String> _postRegClientCompanyData<T>(
    String path,
    Map<String, dynamic> bodyParameters,
    T Function(dynamic json) parser, [
    // ignore: unused_element
    Map<String, dynamic>? urlParameters,
    String? token,
  ]) async {
    try {
      final url = Uri.parse(path);
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      Map<String, Object> jsonMap = {
        "clientCompany": bodyParameters,
        "sysUserType": 2
      };
      var response1 = await http
          .post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      )
          .timeout(
        Duration(seconds: 20),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 500); // Replace 500 with your http code.
        },
      );
      print("Response status: ${response1.statusCode}");
      print("Response body: ${response1.body}");

      return response1.body;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<String> _post2<T>(
    String path,
    Map<String, dynamic> bodyParameters,
    T Function(dynamic json) parser, [
    // ignore: unused_element
    Map<String, dynamic>? urlParameters,
  ]) async {
    try {
      final url = Uri.parse(path);
      Map<String, String> headers = {"Content-type": "application/json"};

      var response1 = await http
          .post(
        url,
        headers: headers,
        body: jsonEncode(bodyParameters),
      )
          .timeout(Duration(seconds: 20), onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response('Error', 500); // Replace 500 with your http code.
      });
      print("Response status: ${response1.statusCode}");
      print("Response body: ${response1.body}");

      if (response1.body.contains('number has already registerd')) {
        print(response1.body);
        return response1.body.toString();
      } else if (response1.body.contains('verifed')) {
        print(response1.body);
        return response1.body.toString();
      } else {
        final dynamic json1 = await jsonDecode(response1.body);

        final guestCode = json1["guestCode"];
        print(guestCode);
        return guestCode.toString();
      }
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<String> auth(
      {required String username, required String password}) async {
    final token = await _makeToken();
    final validUser = await _validateUser(
        username: username, password: password, requestToken: token);
    final sessionId = await _makeSession(requestToken: validUser);
    return sessionId;
  }

  Future<String> _makeTokenCode({
    required String phoneNumber,
    required String codeSms,
  }) async {
    // final parser = (dynamic json) {
    //   final jsonMap = json as Map<String, dynamic>;
    //   final code = jsonMap as String;
    //   return code;
    // };
    final parameters = <String, dynamic>{
      'phoneNumber': phoneNumber,
      'guestCode': int.parse(codeSms)
    };
    // final result = _post3('http://185.116.193.86:8081/guesttoken', parameters,
    //     parser, <String, dynamic>{'phoneNumber': phoneNumber});

    final url = Uri.parse('http://185.116.193.86:8081/guesttoken');
    Map<String, String> headers = {
      "Content-type": "application/json",
    };

    var response1 = await http
        .post(url, headers: headers, body: jsonEncode(parameters))
        .timeout(Duration(seconds: 20), onTimeout: () {
      // Time has run out, do what you wanted to do.
      return http.Response('Error', 500); // Replace 500 with your http code.
    });

    print("Response status: ${response1.statusCode}");
    print("Response body: ${response1.body}");

    if (response1.statusCode == 500 &&
        response1.body
            .contains('an error occured when verifying the guest code')) {
      return 'code error';
    } else {
      // final dynamic json1 = await jsonDecode(response1.body);
      // final sessionId = json1["AccessToken"];
      // return sessionId;
      return response1.body.toString();
    }
  }

  Future<String> authPhone({
    required String phoneBumber,
    required String login,
    required String pass,
  }) async {
    final token = await _makeCode(
      phoneNumber: phoneBumber,
      login: login,
      pass: pass,
    );
    return token;
  }

  Future<String> sendRegData({
    required Map<String, dynamic> data,
    required String token1,
  }) async {
    final token = await _sendRegData(
      parameters: data,
      token: token1,
    );
    // final validUser = await _validateUser(
    //     username: username, password: password, requestToken: token);
    // final sessionId = await _makeSession(requestToken: validUser);
    return token;
  }

  Future<String> sendRegClientCompanyData({
    required Map<String, dynamic> data,
    required String token1,
  }) async {
    final token = await _sendRegClientCompanyData(
      parameters: data,
      token: token1,
    );
    // final validUser = await _validateUser(
    //     username: username, password: password, requestToken: token);
    // final sessionId = await _makeSession(requestToken: validUser);
    return token;
  }

  Future<String> authToken({
    required String phoneBumber,
    required String code,
  }) async {
    final token = await _makeTokenCode(phoneNumber: phoneBumber, codeSms: code);
    // final validUser = await _validateUser(
    //     username: username, password: password, requestToken: token);
    // final sessionId = await _makeSession(requestToken: validUser);
    return token;
  }

  //функция для создания юрл
  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  Future<String> _makeToken() async {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    };
    final result = _get(
      '/authentication/token/new?api_key=',
      parser,
      <String, dynamic>{'api_key': _apiKey},
    );
    return result;
  }

  Future<String> _makeCode({
    required String phoneNumber,
    required String login,
    required String pass,
  }) async {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final code = jsonMap as String;
      return code;
    };
    final parameters = <String, dynamic>{
      'phoneNumber': phoneNumber,
      'nickName': login,
      'password': pass
    };
    final result = _post2(
      'http://185.116.193.86:8081/createguest',
      parameters,
      parser,
      <String, dynamic>{
        'phoneNumber': phoneNumber,
      },
    );
    return result;
  }

  Future<String> _sendRegData({
    required Map<String, dynamic> parameters,
    required String token,
  }) async {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final code = jsonMap as String;
      return code;
    };
    final result = _postRegData(
      'http://185.116.193.86:8081/complindi',
      parameters,
      parser,
      <String, dynamic>{'phoneNumber': 'phoneNumber'},
      token,
    );
    return result;
  }

  Future<String> _sendRegClientCompanyData({
    required Map<String, dynamic> parameters,
    required String token,
  }) async {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final code = jsonMap as String;
      return code;
    };
    final result = _postRegClientCompanyData(
      'http://185.116.193.86:8081/complcompany',
      parameters,
      parser,
      <String, dynamic>{'phoneNumber': 'phoneNumber'},
      token,
    );
    return result;
  }

  Future<int> getAccountInfo(
    String sessionId,
  ) async {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['id'] as int;
      return result;
    };
    final result = _get(
      '/account',
      parser,
      <String, dynamic>{
        'api_key': _apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }

  Future<String> _validateUser({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final parameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken,
    };
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    };
    final result = _post('/authentication/token/validate_with_login?api_key=',
        parameters, parser, <String, dynamic>{'api_key': _apiKey});
    return result;
  }

  Future<String> _makeSession({
    required String requestToken,
  }) async {
    final parameters = <String, dynamic>{
      'request_token': requestToken,
    };
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final sessionId = jsonMap['session_id'] as String;
      return sessionId;
    };

    final result = _post(
      '/authentication/session/new?api_key=',
      parameters,
      parser,
      <String, dynamic>{
        'api_key': _apiKey,
      },
    );
    return result;
  }

  void _validateResponse(HttpClientResponse responce, dynamic json) {
    if (responce.statusCode == 401) {
      final dynamic status = json['status_code'];
      final code = status is int ? status : 0;
      if (code == 30) {
        throw ApiClientException(ApiClientExceptionType.Auth);
      } else if (code == 3) {
        throw ApiClientException(ApiClientExceptionType.SessionExpired);
      } else {
        throw ApiClientException(ApiClientExceptionType.Other);
      }
    }
  }

  ///для выяснения отмечен фильм или нет добавляем айди сессии
  Future<bool> isFavorite(
    int movieId,
    String sessionId,
  ) async {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = jsonMap['favorite'] as bool;
      return response;
    };
    final result = _get(
      '/movie/$movieId/account_states',
      parser,
      <String, dynamic>{
        'api_key': _apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }

  Future<String> markAsFavorite({
    required int accountId,
    required String sessionId,
    required MediaType mediaType,
    required int mediaId,
    required bool isFavorite,
  }) async {
    final parameters = <String, dynamic>{
      'media_type': mediaType.asString(),
      'media_id': mediaId.toString(),
      'favorite': isFavorite,
    };
    //возвращаем статус удаления \ постановки в избранное
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final message = jsonMap['status_message'] as String;
      print(message);
      return message;
    };
    final result = _post('/account/$accountId/favorite', parameters, parser,
        <String, dynamic>{'api_key': _apiKey, 'session_id': sessionId});
    return result;
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((v) => json.decode(v));
  }
}

///statusCode 30 - wrong login or password
///statusCode 7 - invalid API key
///statusCode 33 - invalid request token
