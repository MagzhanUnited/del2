import 'package:flutter/material.dart';
import 'package:themoviedb/providers/provider.dart';
import 'package:themoviedb/full/ui/register/register_step3_client_fiz_model.dart';
import 'package:themoviedb/full/ui/register/register_step3_client_fiz_page.dart';
import 'package:themoviedb/full/ui/register/register_step3_client_ur_model.dart';
import 'package:themoviedb/full/ui/register/register_step3_client_ur_page.dart';
import 'package:themoviedb/full/ui/register/update_client_fiz_page.dart';
import 'package:themoviedb/ui/widgets/auth/auth_model.dart';
import 'package:themoviedb/ui/widgets/auth/auth_widget.dart';
import 'package:themoviedb/ui/widgets/auth/change_language_model.dart';
import 'package:themoviedb/ui/widgets/auth/change_language_widget.dart';
import 'package:themoviedb/ui/widgets/auth/send_code_model.dart';
import 'package:themoviedb/ui/widgets/auth/send_code_widget.dart';
import 'package:themoviedb/ui/widgets/auth/verify_otp_model.dart';
import 'package:themoviedb/ui/widgets/auth/verify_otp_widget.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_screen_model.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';

abstract class MainNavigationRouteNames {
  static const changeLang = 'change_lang';
  static const sendCode = 'send_code';
  static const verifyOtp = 'verify_otp';
  static const auth = 'auth';

  static const regClientFiz = 'reg_client_fiz';
  static const regClientCompany = 'reg_client_company';

  static const updateClientFiz = 'update_client_fiz';

  static const mainScreen = '/';
  static const movieDetails = '/movie_details';
  static const movieTrailer = '/movie_details/trailer';
}

// утащим роуты для удобного использования в отдельный файл
class MainNavigation {
  String initialRoute(bool isAuth) => isAuth
      ? MainNavigationRouteNames.mainScreen
      : MainNavigationRouteNames.changeLang;

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.changeLang: (context) => NotifierProvider(
          child: ChangeLanguage(),
          create: () => ChangeLangModel(),
        ),
    MainNavigationRouteNames.sendCode: (context) => NotifierProvider(
          child: SendCode(),
          create: () => SendCodeModel(),
        ),
    MainNavigationRouteNames.verifyOtp: (context) => NotifierProvider(
          child: VerifyOtp(),
          create: () => VerifyOtpModel(),
        ),
    MainNavigationRouteNames.auth: (context) => NotifierProvider(
          child: const AuthWidget(),
          create: () => AuthModel(),
        ),
    MainNavigationRouteNames.regClientFiz: (context) => NotifierProvider(
          child: RegisterStep3ClientFizView(
            edit: false,
            jdata: [],
            swapeRole: false,
          ),
          create: () => ClientIndiModel(),
        ),
    MainNavigationRouteNames.updateClientFiz: (context) => NotifierProvider(
          child: UpdateClientFizView(),
          create: () => ProfileModel(),
        ),
    MainNavigationRouteNames.regClientCompany: (context) => NotifierProvider(
          child: RegisterStep3ClientUrView(
            edit: false,
            jdata: [],
            swapeRole: false,
          ),
          create: () => ClientCompanyModel(),
        ),
    MainNavigationRouteNames.mainScreen: (context) => NotifierProvider(
          child: MainScreenWidget(),
          create: () => MainScreenModel(),
        ),
  };
}

class ScreenArguments {
  final String phoneNum;
  final String otpCode;

  ScreenArguments(this.phoneNum, this.otpCode);
}
