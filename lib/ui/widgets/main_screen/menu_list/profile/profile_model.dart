import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';

class ProfileModel extends ChangeNotifier {
  String token = "";
  String phoneNumber = "";
  String sysUserType = "";
  String sysUserTypeName = "";

  String carId = "";


  
  String clientId = "";
  String firstName = "";
  String pName = "";
  String lastName = "";
  String email = "";
  String iin = "";

  String companyAddress = "";
  String companyIIN = "";
  String companyName = "";

  String FullName = '';


  String ButtonName = "Зарегистрироваться";
  String userTypeName = "Гость";


  Future<void> setupLocale(BuildContext context) async {
    await loadDetails();
  }

  Future<void> loadDetails() async {
    try {
      sysUserType = (await SessionDataProvider().getRoleType())!;
      token = (await SessionDataProvider().getSessionId())!;
      phoneNumber = (await SessionDataProvider().getPhoneNumber())!;
      // carId = (await SessionDataProvider().getCarId())!;

      // sysUserType = '0';
      // token = '0';
      // phoneNumber = '0';

      notifyListeners();
    } on ApiClientException catch (e) {
      print('profile loadDetails error $e');
    }
  }
}
