import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';

String serverApi = "185.116.193.86"; //ecarnet.kz

//драйвер жумысшы косу
class AddCompanyDriver {
  final String fName;
  final String lName;
  final String pName;
  final String iin;
  final String token;
  final String base64Img;
  final String email;

  AddCompanyDriver({
    required this.fName,
    required this.lName,
    required this.pName,
    required this.iin,
    required this.token,
    required this.base64Img,
    required this.email,
  });

  Future<String> Add() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/companydriver');

      final parameters = <String, dynamic>{
        'clientId': 0,
        // 'photo': base64Img,
        'photo': '',
        'firstName': fName,
        'lastName': lName,
        'thirdName': pName,
        'email': email,
        'iin': iin
      };
      Map<String, Object> jsonMap = {
        "clientIndivisual": parameters,
        "sysUserType": 5
      };
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return 'Успешная регистрация!';
      } else if (response.body.contains('Duplicate')) {
        return 'Данный пользователь уже зарегистрирован в системе';
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//драйвер машина косу
class AddCompanyCar {
  final dynamic jdata;
  final String token;

  AddCompanyCar({
    required this.jdata,
    required this.token,
  });

  Future<String> Add() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/companycar');

      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jdata),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return 'Успешная регистрация!';
      } else if (response.body.contains('Duplicate')) {
        return 'Данный пользователь уже зарегистрирован в системе';
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

class RegisterDriverCompany {
  final String iin;
  final String driverCode;
  final String token;

  RegisterDriverCompany({
    required this.iin,
    required this.driverCode,
    required this.token,
  });

  Future<String> register() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/findcomp');

      Map<String, Object> jsonMap = {'driverCode': driverCode, 'iin': iin};
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return 'Успешная регистрация!';
      } else if (response.body.contains('Duplicate')) {
        return 'Данный пользователь уже зарегистрирован в системе';
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

class RegisterDbClienIndi {
  final String fName;
  final String lName;
  final String pName;
  final String iin;
  final String eMail;
  final String token;
  final String base64Img;

  RegisterDbClienIndi({
    required this.fName,
    required this.lName,
    required this.pName,
    required this.iin,
    required this.eMail,
    required this.token,
    required this.base64Img,
  });

  Future<String> register() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/complindi');

      final parameters = <String, dynamic>{
        'clientId': 0,
        'photo': base64Img,
        'firstName': fName,
        'lastName': lName,
        'thirdName': pName,
        'email': eMail,
        'iin': iin
      };
      Map<String, Object> jsonMap = {
        "clientIndivisual": parameters,
        "sysUserType": 1
      };
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return 'Успешная регистрация!';
      } else if (response.body.contains('Duplicate')) {
        return 'Данный пользователь уже зарегистрирован в системе';
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

class RegisterDbDriverIndi {
  final dynamic docs;
  final dynamic regData;
  final String token;

  RegisterDbDriverIndi({
    required this.docs,
    required this.regData,
    required this.token,
  });

  Future<String> register() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/driver');

      Map<String, Object> jsonMap = {
        "clientIndivisual": regData,
        "sysUserType": 3
      };

      print(regData);

      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return 'Успешная регистрация!';
      } else if (response.body.contains('Duplicate')) {
        return 'Данный пользователь уже зарегистрирован в системе';
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

class RegisterDbClienComp {
  final int id;
  final String img;
  final String name;
  final String iin;
  final String adress;
  final String email;
  final String token;

  RegisterDbClienComp({
    required this.id,
    required this.img,
    required this.name,
    required this.iin,
    required this.adress,
    required this.email,
    required this.token,
  });

  Future<String> register() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/complcompany');

      final parameters = <String, dynamic>{
        "clientId": id,
        "photo": img,
        "companyName": name,
        "companyIIN": iin,
        "companyAddress": adress,
        "companyAddressru": adress,
        "companyAddressen": adress,
        "email": email
      };
      Map<String, Object> jsonMap = {
        "clientCompany": parameters,
        "sysUserType": 2
      };
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return 'Успешная регистрация!';
      } else if (response.body.contains('Duplicate')) {
        return 'Компания уже зарегистрирована в системе';
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

class RegisterDbDriverComp {
  final String name;
  final String iin;
  final String adress;
  final String email;
  final String token;
  final String base64;
  final dynamic jdata;

  RegisterDbDriverComp({
    required this.name,
    required this.iin,
    required this.adress,
    required this.email,
    required this.token,
    required this.base64,
    required this.jdata,
  });

  Future<String> register() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/complcompany');

      final parameters = <String, dynamic>{
        "clientId": 0,
        "photo": base64,
        "companyName": name,
        "companyIIN": iin,
        "companyAddress": adress,
        "companyAddressru": adress,
        "companyAddressen": adress,
        "email": email
      };
      Map<String, Object> jsonMap = {
        "clientCompany": parameters,
        "sysUserType": 4
      };
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return 'Успешная регистрация!';
      } else if (response.body.contains('Duplicate')) {
        return 'Компания уже зарегистрирована в системе';
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }

  Future<String> update() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/complcompany');

      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jdata),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return 'Успешная регистрация!';
      } else if (response.body.contains('Duplicate')) {
        return 'Компания уже зарегистрирована в системе';
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

class GetSysType {
  final String token;
  final String sysUserType;

  GetSysType({required this.token, required this.sysUserType});

  Future<String> getSysType() async {
    Uri url = Uri.parse('http://${serverApi}:8081/updatedriver');

    if (sysUserType == '0' ||
        sysUserType == '1' ||
        sysUserType == '2' ||
        sysUserType == '4' ||
        sysUserType == '5') {
      url = Uri.parse('http://${serverApi}:8081/updateclient');
    }

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final sysUserType = result["sysUserType"];
        print(sysUserType);
        final _sessionDataProvider = SessionDataProvider();
        await _sessionDataProvider.setRoleType(sysUserType.toString());
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

class SwapeRoleSysType {
  final String token;
  final int sysUserType;
  final String TargetSysUserType;

  SwapeRoleSysType({
    required this.TargetSysUserType,
    required this.token,
    required this.sysUserType,
  });

  Future<String> rolechange() async {
    Uri url = Uri.parse('http://${serverApi}:8081/driverrolechange');

    if (TargetSysUserType == "1" || TargetSysUserType == "2") {
      url = Uri.parse('http://${serverApi}:8081/clientrolechange');
    }

    try {
      Map<String, Object> jsonMap = {"sysUserType": sysUserType};

      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        final _sessionDataProvider = SessionDataProvider();
        await _sessionDataProvider.setRoleType(sysUserType.toString());
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }

  Future<String> clientrolechange() async {
    Uri url = Uri.parse('http://${serverApi}:8081/clientrolechange');

    try {
      Map<String, Object> jsonMap = {"sysUserType": sysUserType};

      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        final _sessionDataProvider = SessionDataProvider();
        await _sessionDataProvider.setRoleType(sysUserType.toString());
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

class UpdateClientFiz {
  final String clientId;
  final String fName;
  final String lName;
  final String pName;
  final String iin;
  final String eMail;
  final String token;
  final String img;

  UpdateClientFiz({
    required this.clientId,
    required this.fName,
    required this.lName,
    required this.pName,
    required this.iin,
    required this.eMail,
    required this.token,
    required this.img,
  });

  Future<String> UpdateData() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/complindi');

      final parameters = <String, dynamic>{
        'clientId': int.parse(clientId),
        'photo': img,
        'firstName': fName,
        'lastName': lName,
        'thirdName': pName,
        'email': eMail,
        'iin': iin
      };
      Map<String, Object> jsonMap = {
        "clientIndivisual": parameters,
        "sysUserType": 1
      };
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        // final result = json.decode(response.body);
        // final sysUserType = result["sysUserType"];
        print(response.body);
        // final _sessionDataProvider = SessionDataProvider();
        // await _sessionDataProvider.setRoleType(sysUserType.toString());
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//0 - кабылдамау 1 - кабылдау
//orderId - номер заказа offerId - маган келеды соны кайтып жыберемын isAcc - статус принятия
class AcseptOrder {
  final int tandau;
  final int orderId;
  final int offerId;
  final String token;

  AcseptOrder({
    required this.tandau,
    required this.orderId,
    required this.offerId,
    required this.token,
  });

  Future<String> UpdateData() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/acc');

      Map<String, Object> jsonMap = {
        'orderId': orderId,
        'offerId': offerId,
        'isAcc': tandau
      };
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        // final result = json.decode(response.body);
        // final sysUserType = result["sysUserType"];
        print(response.body);
        // final _sessionDataProvider = SessionDataProvider();
        // await _sessionDataProvider.setRoleType(sysUserType.toString());
        return response.body;
      } else {
        return 'Error';
      }
    } catch (e) {
      print('ERROR === >> UpdateData() ' + e.toString());
      return 'Error';
    }
  }
}

//0 - кабылдамау 1 - кабылдау
//orderId - номер заказа offerId - маган келеды соны кайтып жыберемын isAcc - статус принятия
//driver not кабылдау кабылдамау
class AcseptOrderDriver {
  final int tandau;
  final int orderId;
  final int offerId;
  final String token;

  AcseptOrderDriver({
    required this.tandau,
    required this.orderId,
    required this.offerId,
    required this.token,
  });

  Future<String> UpdateData() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/accdriver');

      Map<String, Object> jsonMap = {
        'orderId': orderId,
        'offerId': offerId,
        'isAcc': tandau
      };
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        // final result = json.decode(response.body);
        // final sysUserType = result["sysUserType"];
        print(response.body);
        // final _sessionDataProvider = SessionDataProvider();
        // await _sessionDataProvider.setRoleType(sysUserType.toString());
        return response.body;
      } else {
        return 'Error';
      }
    } catch (e) {
      print('ERROR === >> UpdateData() driver ' + e.toString());
      return 'Error';
    }
  }
}

//Заявить тарспорт водители/компании
class CreateNewOrder {
  final dynamic jdata;
  final String token;

  CreateNewOrder({
    required this.jdata,
    required this.token,
  });

  Future<String> Create() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/orderdriver');

      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jdata),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        // final result = json.decode(response.body);
        // final sysUserType = result["sysUserType"];
        print(response.body);
        // final _sessionDataProvider = SessionDataProvider();
        // await _sessionDataProvider.setRoleType(sysUserType.toString());
        return response.body;
      } else {
        print('error ');
        return 'Error ${response.body}';
      }
    } catch (e) {
      print('error $e');
      return 'Error $e';
    }
  }

  Future<String> CreateOrderClient() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/orderclient');

      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jdata),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        // final result = json.decode(response.body);
        // final sysUserType = result["sysUserType"];
        print(response.body);
        // final _sessionDataProvider = SessionDataProvider();
        // await _sessionDataProvider.setRoleType(sysUserType.toString());
        return response.body;
      } else {
        print('error ');
        return 'Error ${response.body}';
      }
    } catch (e) {
      print('error $e');
      return 'Error $e';
    }
  }
}

class GetDocs {
  final String token;

  GetDocs({required this.token});

  Future<String> getDocs() async {
    Uri url = Uri.parse('http://${serverApi}:8081/driverdocs');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

class GetDriverList {
  final String token;

  GetDriverList({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/companydriverlist');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

class GetCarList {
  final String token;

  GetCarList({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/companycarlist');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос валюты
class CurrencyList {
  final String token;

  CurrencyList({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/currencylist');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

class GetOrderList {
  final String token;
  final dynamic data;

  GetOrderList({
    required this.token,
    required this.data,
  });

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/orderlistfordriveroffer');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

  Future<String> getGuest() async {
    Uri url = Uri.parse('http://${serverApi}:8081/guestadverclient');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос carId если есть активный заказ
class GetCarId {
  final String token;

  GetCarId({required this.token});

  Future<String> getListClient() async {
    Uri url = Uri.parse('http://${serverApi}:8081/drivercarid');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос моих заказов клиент
class GetMyOrderList {
  final String token;

  GetMyOrderList({required this.token});

  Future<String> getListClient() async {
    Uri url = Uri.parse('http://${serverApi}:8081/myorderlistclient');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

  //драйвер ушын орындалып жаткан заказдар
  Future<String> getListDriver() async {
    // Uri url = Uri.parse('http://${serverApi}:8081/myorderlistdriver');
    Uri url = Uri.parse('http://${serverApi}:8081/driveractiveorders');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

  //драйвер ушын орындалып жаткан заказдар
  Future<String> getMyZayavkiDriver() async {
    // Uri url = Uri.parse('http://${serverApi}:8081/myorderlistdriver');
    Uri url = Uri.parse('http://${serverApi}:8081/suggestedclientorders');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Отправить предложение от клиента к драйверу
class MakeOfferToDriver {
  final String token;
  final int clientOrderId;
  final int driverOrderId;
  final int driverType;
  final double offerPrice;

  MakeOfferToDriver({
    required this.token,
    required this.clientOrderId,
    required this.driverOrderId,
    required this.driverType,
    required this.offerPrice,
  });

  Future<String> sendData() async {
    Uri url = Uri.parse('http://${serverApi}:8081/makeoffertodriver');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      Map<String, Object> jsonMap = {
        "clientOrderId": clientOrderId,
        "driverOrderId": driverOrderId,
        "driverType": driverType,
        "offerPrice": offerPrice,
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.body.contains('already made offer')) {
        return response.body;
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      print('ERROR ====>> MakeOfferToDriver ' + e.toString());
      return 'error';
    }
  }
}

//проверка имени на уникальность
class VerifyName {
  final String Name;

  VerifyName({required this.Name});

  Future<String> getName() async {
    print('getName called');
    Uri url = Uri.parse('http://${serverApi}:8081/check');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
      };
      Map<String, Object> jsonMap = {
        "nickName": Name,
      };
      print('before response');
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );
      print('after response');
      print("response.statusCode ${response.statusCode}");
      print(response.body);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      print(e);
      return 'error';
    }
  }
}

class LoginAuth {
  final String Name;
  final String pass;

  LoginAuth({
    required this.Name,
    required this.pass,
  });

  Future<String> getName() async {
    Uri url = Uri.parse('http://${serverApi}:8081/syslogin');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*'
      };
      Map<String, Object> jsonMap = {"nickName": Name, "password": pass};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      final dynamic json1 = await jsonDecode(response.body);

      var sessionId = json1["AccessToken"].toString();
      var IsComp = json1["IsComp"].toString();
      var roleType = json1["UserType"].toString();
      var phoneNum = json1["PhoneNumber"].toString();
      // var CarId = json1["CarId"].toString();

      final _sessionDataProvider = SessionDataProvider();

      await _sessionDataProvider.setSessionId(sessionId);
      await _sessionDataProvider.setPhoneNumber(phoneNum);
      await _sessionDataProvider.setIsComp(IsComp);
      await _sessionDataProvider.setRoleType(roleType);
      // await _sessionDataProvider.setCarId(CarId);

      // Navigator.of(context).pushNamed('/main_screen');
      // Navigator.of(context).pushNamed(RouteScreen.mainScreen);

      return 'true';
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      return 'error';
    }
  }
}

//отправить код на телефон для восстановления пароля
class Recover {
  final String phoneNumber;

  Recover({required this.phoneNumber});

  Future<String> send() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/recover');

      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
      };

      Map<String, Object> jsonMap = {"phoneNumber": "8" + phoneNumber};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      return 'error';
    }
  }
}

//отправить код и новый пароль
//изменить пароль
class ResetPassword {
  final String phoneNumber;
  final int recoverCode;
  final String password;

  ResetPassword({
    required this.phoneNumber,
    required this.recoverCode,
    required this.password,
  });

  Future<String> send() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/resetpassword');

      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
      };

      Map<String, Object> jsonMap = {
        "phoneNumber": "8" + phoneNumber,
        "recoverCode": recoverCode,
        "password": password,
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      return 'error';
    }
  }
}

//отправить код повторно
class RegetCode {
  final String phoneNumber;

  RegetCode({
    required this.phoneNumber,
  });

  Future<String> send() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/regetcode');

      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
      };

      Map<String, Object> jsonMap = {
        "phoneNumber": "8" + phoneNumber,
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      return 'error';
    }
  }
}

class SendOrderRequest {
  final dynamic jdata;
  final String token;

  SendOrderRequest({
    required this.jdata,
    required this.token,
  });

  Future<String> send() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/maporder');

      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jdata),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        // print(response.body);
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      // print('error $e');
      return 'Error $e';
    }
  }
}

//Запрос брендов машин
class GetCarBrands {
  final String token;

  GetCarBrands({required this.token});

  Future<String> get() async {
    Uri url = Uri.parse('http://${serverApi}:8081/brands');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Запрос моделей машин
class GetCarModels {
  final String token;
  final int brandId;

  GetCarModels({
    required this.token,
    required this.brandId,
  });

  Future<String> get() async {
    Uri url = Uri.parse('http://${serverApi}:8081/models');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      Map<String, Object> jsonMap = {"brandId": brandId};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Запрос Типа кузова машин
class GetCarType {
  final String token;

  GetCarType({required this.token});

  Future<String> get() async {
    Uri url = Uri.parse('http://${serverApi}:8081/types');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Запрос Попутных рейсов для клиентов
class GetPoputki {
  final String token;
  final dynamic data;

  GetPoputki({
    required this.token,
    required this.data,
  });

  Future<String> get() async {
    Uri url = Uri.parse('http://${serverApi}:8081/orderlistforclientoffer');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }

  Future<String> getGuest() async {
    Uri url = Uri.parse('http://${serverApi}:8081/adverlistguest');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Уведомления для клиента заявки драйверов
class GetNotListClient {
  final String token;

  GetNotListClient({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/notlistclient');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Уведомления для водителя заявки от клиентов
class NotListDriver {
  final String token;

  NotListDriver({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/notlistdriver');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Клиент->менын заказдарым->курылган заказдар->драйверерге жыберылген усыныстарым
class MyAdverListClient {
  final String token;

  MyAdverListClient({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/mysugesstionstodriver');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//драйвер->менын заказдарым->курылган заказдар
class MyAdverListDriver {
  final String token;

  MyAdverListDriver({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/driveradverlist');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//драйвер->менын заказдарым->Орындалып жаткан
class DriverActiveOrders {
  final String token;

  DriverActiveOrders({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/driveractiveorders');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос Данных статистики приложения
class AppStatData {
  final String token;

  AppStatData({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/appreport');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос названия таблиц для статистики
class StatKzRepCats {
  final String token;

  StatKzRepCats({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/repdiff');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос названия стран таблиц для LPI
class CountryCodes {
  final String token;

  CountryCodes({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/countrycodes');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос названия таблиц для статистики
class GetStatData {
  final String token;
  final dynamic jsonMap;

  GetStatData({required this.token, this.jsonMap});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/forecastnext');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос названия таблиц для LPI
class GetLPIData {
  final String token;
  final dynamic jsonMap;

  GetLPIData({required this.token, this.jsonMap});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/filteredranks');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

// Запрос Стран для дозволов
class CountryLoad {
  final String token;

  CountryLoad({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/countries');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      // Map<String, Object> jsonMap = {"carId": 81, "lat": "", "lan": ""};

      var response = await http.post(
        url,
        headers: headers,
        // body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

// Запрос Области для дозволов
class CityLoad {
  final String token;

  CityLoad({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/cities');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      // Map<String, Object> jsonMap = {"carId": 81, "lat": "", "lan": ""};

      var response = await http.post(
        url,
        headers: headers,
        // body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

// Запрос данных Дозвола КЗ
class KZDozvolDataLoad {
  final String token;
  final Map<String, Object> data;

  KZDozvolDataLoad({
    required this.token,
    required this.data,
  });

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/nonforeign');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      // Map<String, Object> jsonMap = {"carId": 81, "lat": "", "lan": ""};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200 &&
          response.body.contains('null') &&
          response.body.length < 5) {
        return 'нет данных';
      } else if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

// Запрос данных Дозвола other
class otherDozvolDataLoad {
  final String token;
  final Map<String, Object> data;

  otherDozvolDataLoad({
    required this.token,
    required this.data,
  });

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/foreign');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      // Map<String, Object> jsonMap = {"carId": 81, "lat": "", "lan": ""};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200 &&
          response.body.contains('null') &&
          response.body.length < 5) {
        return 'нет данных';
      } else if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

// Запрос Тайтла и годов Транзит портов
class TrTitleLoad {
  final String token;

  TrTitleLoad({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/titleyears');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      // Map<String, Object> jsonMap = {"carId": 81, "lat": "", "lan": ""};

      var response = await http.post(
        url,
        headers: headers,
        // body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

// Запрос данных Транзита
class TrDataLoad {
  final String token;
  final Map<String, Object> data;

  TrDataLoad({
    required this.token,
    required this.data,
  });

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/transits');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      // Map<String, Object> jsonMap = {"carId": 81, "lat": "", "lan": ""};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200 && response.body.contains('null')) {
        return 'нет данных';
      } else if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

// Запрос данных Порта
class PortDataLoad {
  final String token;
  final Map<String, Object> data;

  PortDataLoad({
    required this.token,
    required this.data,
  });

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/stports');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      // Map<String, Object> jsonMap = {"carId": 81, "lat": "", "lan": ""};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200 && response.body.contains('null')) {
        return 'нет данных';
      } else if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

// Запрос для местоположения груза
class locationLoad {
  final String token;
  final int carId;

  locationLoad({
    required this.token,
    required this.carId,
  });

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/location');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      Map<String, Object> jsonMap = {"carId": carId, "lat": "", "lan": ""};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос Новостей
class NewsLoad {
  final String token;

  NewsLoad({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/newslist');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос деталей Новостей
class NewsLoadMore {
  final int newsId;
  final String token;

  NewsLoadMore({
    required this.token,
    required this.newsId,
  });

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/newsreadmore');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      Map<String, Object> jsonMap = {"newsId": newsId};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос СВХ ТЛЦ
class LoadSvhTlc {
  final String token;

  LoadSvhTlc({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/warehousecats');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос Пункты пропуска
class Loadcontrolpoints {
  final String token;

  Loadcontrolpoints({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/controlpoints');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос Коридоры
class LoadCoridors {
  final String token;

  LoadCoridors({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/halls');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос названия категории
class ForumCategoryLoad {
  final String token;

  ForumCategoryLoad({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/forumcats');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос Темы Категории
class GetForumCatTems {
  final String token;
  final int catId;

  GetForumCatTems({
    required this.token,
    required this.catId,
  });

  Future<String> get() async {
    Uri url = Uri.parse('http://${serverApi}:8081/forumtitles');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      Map<String, Object> jsonMap = {"catId": catId};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Форум добавить пост
class ForumUploadPost {
  dynamic filepath;
  String token;
  String catId;
  String titleText;
  String descText;

  ForumUploadPost({
    required this.filepath,
    required this.token,
    required this.catId,
    required this.titleText,
    required this.descText,
  });

  Future<String?> get() async {
    try {
      final String url = 'http://${serverApi}:8081/postforumtitle';

      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };
      Map<String, String> data = {
        "catId": catId,
        "title": titleText,
        "description": descText,
      };

      var request = http.MultipartRequest('POST', Uri.parse(url));

      if (filepath != null) {
        request.files
            .add(await http.MultipartFile.fromPath('titleImage', filepath));
      }

      request.headers.addAll(headers);
      request.fields.addAll(data);

      var response = await request.send();

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.reasonPhrase;
      } else {
        return 'Error ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Запрос Комментариев поста
class LoadForumCatPostComments {
  final String token;
  final int postId;

  LoadForumCatPostComments({
    required this.token,
    required this.postId,
  });

  Future<String> get() async {
    Uri url = Uri.parse('http://${serverApi}:8081/viewtitle');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      Map<String, Object> jsonMap = {"titleId": postId};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Запрос Поставить лайк на новость
class LikeNews {
  final String token;
  final int newsId;

  LikeNews({
    required this.token,
    required this.newsId,
  });

  Future<String> get() async {
    Uri url = Uri.parse('http://${serverApi}:8081/likenews');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      Map<String, Object> jsonMap = {"newsId": newsId};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Запрос комментов на новость
class Viewnewscomment {
  final String token;
  final int newsId;

  Viewnewscomment({
    required this.token,
    required this.newsId,
  });

  Future<String> get() async {
    Uri url = Uri.parse('http://${serverApi}:8081/viewnewscomment');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      Map<String, Object> jsonMap = {"newsId": newsId};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Запрос Поставить лайк на пост
class ForumTitleLikePost {
  final String token;
  final int postId;

  ForumTitleLikePost({
    required this.token,
    required this.postId,
  });

  Future<String> get() async {
    Uri url = Uri.parse('http://${serverApi}:8081/liketitle');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      Map<String, Object> jsonMap = {"titleId": postId};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Запрос Мои созданные посты
class ForumLoadMyCreatedPosts {
  final String token;

  ForumLoadMyCreatedPosts({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/mytitles');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос удаления Темы
class GetForumDeleteTems {
  final String token;
  final int PostId;

  GetForumDeleteTems({
    required this.token,
    required this.PostId,
  });

  Future<String> get() async {
    Uri url = Uri.parse('http://${serverApi}:8081/deltitle');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      Map<String, Object> jsonMap = {"titleId": PostId};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Запрос Добавления Комментариев под постом
class ForumAddComments {
  final String token;
  final int titleId;
  final String description;

  ForumAddComments({
    required this.token,
    required this.titleId,
    required this.description,
  });

  Future<String> get() async {
    Uri url = Uri.parse('http://${serverApi}:8081/postcomment');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      Map<String, Object> jsonMap = {
        "titleId": titleId,
        "description": description,
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Запрос Добавления Комментариев Новости
class NewsAddComments {
  final String token;
  final int newsId;
  final String description;

  NewsAddComments({
    required this.token,
    required this.newsId,
    required this.description,
  });

  Future<String> get() async {
    Uri url = Uri.parse('http://${serverApi}:8081/writenewscomment');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      Map<String, Object> jsonMap = {
        "newsId": newsId,
        "description": description,
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Запрос поставить лайк под комментарием Новости
class NewsLikeComment {
  final String token;
  final int commentId;

  NewsLikeComment({
    required this.token,
    required this.commentId,
  });

  Future<String> get() async {
    Uri url = Uri.parse('http://${serverApi}:8081/likenewscomment');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      Map<String, Object> jsonMap = {"commentId": commentId};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Запрос поставить лайк под комментарием
class ForumLikeComment {
  final String token;
  final int commentId;

  ForumLikeComment({
    required this.token,
    required this.commentId,
  });

  Future<String> get() async {
    Uri url = Uri.parse('http://${serverApi}:8081/likecomment');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      Map<String, Object> jsonMap = {"commentId": commentId};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Запрос удаления Коммента
class GetForumDeleteComment {
  final String token;
  final int commentId;

  GetForumDeleteComment({
    required this.token,
    required this.commentId,
  });

  Future<String> get() async {
    Uri url = Uri.parse('http://${serverApi}:8081/delcomment');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      Map<String, Object> jsonMap = {"commentId": commentId};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Драйвер завершение заказа оценка клиента
class Drivercompleteorder {
  final String token;
  final int orderId;
  final int orgId;
  final int driverId;
  final int clientId;
  final int rankPoint;
  final String description;

  Drivercompleteorder({
    required this.token,
    required this.orderId,
    required this.orgId,
    required this.driverId,
    required this.clientId,
    required this.rankPoint,
    required this.description,
  });

  Future<String> end() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/drivercompleteorder');

      Map<String, Object> jsonMap = {
        "orderId": orderId,
        "orgId": orgId,
        "driverId": driverId,
        "clientId": clientId,
        "rankPoint": rankPoint,
        "description": description
      };

      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return 'Успешная';
      } else if (response.body.contains('Duplicate')) {
        return 'Вы уже завершили заказ';
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Клиент оценка драйвера
class Clientfeedback {
  final String token;
  final int orderId;
  final int orgId;
  final int driverId;
  final int clientId;
  final int rankPoint;
  final String description;

  Clientfeedback({
    required this.token,
    required this.orderId,
    required this.orgId,
    required this.driverId,
    required this.clientId,
    required this.rankPoint,
    required this.description,
  });

  Future<String> end() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/clientfeedback');

      Map<String, Object> jsonMap = {
        "orderId": orderId,
        "orgId": orgId,
        "driverId": driverId,
        "clientId": clientId,
        "rankPoint": rankPoint,
        "description": description
      };

      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return 'Успешная';
      } else if (response.body.contains('Duplicate')) {
        return 'Вы уже завершили заказ';
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Клиент не хочет оценивать драйвера
class clientfeedbackclose {
  final String token;
  final int orderId;

  clientfeedbackclose({
    required this.token,
    required this.orderId,
  });

  Future<String> end() async {
    try {
      final url = Uri.parse('http://${serverApi}:8081/clientfeedbackclose');

      Map<String, Object> jsonMap = {"orderId": orderId};

      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return 'Успешная';
      } else if (response.body.contains('Duplicate')) {
        return 'Вы уже завершили заказ';
      } else {
        return 'Error ${response.body}';
      }
    } catch (e) {
      return 'Error $e';
    }
  }
}

//Драйвер Запрос истории заказов
class Driverhistorylist {
  final String token;

  Driverhistorylist({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/driverhistorylist');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Клиент Запрос истории заказов
class Clienthistorylist {
  final String token;

  Clienthistorylist({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/clienthistorylist');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Клиент Запрос Законченных заказов ждет оценку
class Clientdeliveredlist {
  final String token;

  Clientdeliveredlist({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/clientdeliveredlist');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос данных оценки для личного кабинета
class NotCount {
  final String token;
  NotCount({required this.token});

  Future<String> ClientData() async {
    Uri url = Uri.parse('http://${serverApi}:8081/notcountclient');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

  Future<String> DriverData() async {
    Uri url = Uri.parse('http://${serverApi}:8081/notcountdriver');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}

//Запрос комментов лайков количество
class ProfileInfo {
  final String token;
  ProfileInfo({required this.token});

  Future<String> getList() async {
    Uri url = Uri.parse('http://${serverApi}:8081/profileinfo');

    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 401) {
        return response.statusCode.toString();
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
}
