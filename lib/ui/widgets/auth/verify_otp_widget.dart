import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:themoviedb/providers/provider.dart';
import 'package:themoviedb/ui/widgets/auth/verify_otp_model.dart';
import '../../../domain/data_providers/session_data_provider.dart';
import '../../../full/ui/register/step3_client_fiz_model.dart';
import '../../navigation/main_navigation.dart';
import '../app/my_app.dart';
import 'send_code_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart' as pv;
import 'package:themoviedb/providers/locale_provider.dart';

class VerifyOtp extends StatefulWidget {
  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  Timer? _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  Widget build(BuildContext context) {
    final model = NotifierProvider.readFromModel<VerifyOtpModel>(context);

    final routes =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    var phoneNum = routes["phoneNum"];
    // var otpCode = routes["otpCode"];

    model?.phoneNumber.text = phoneNum;

    final provider = pv.Provider.of<LocaleProvider>(context);

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // backgroundColor: Color(0xfff7f6fb),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.arrow_back, size: 24),
                ),
              ),
              ClipRRect(
                // borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 100,
                  child: Image.asset(
                      provider.selectedThemeMode == ThemeMode.dark
                          ? 'images/logo2.png'
                          : 'images/logo.png'),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 1,
              ),
              Text(
                'Проверочный код',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Код был отправлен по SMS на номер 8" +
                    phoneNum.toString() +
                    '\n',
                style: TextStyle(fontSize: 12
                    // color: Colors.black38,
                    ),
                textAlign: TextAlign.center,
              ),
              // SizedBox(height: 28),
              const _ErrorMessageWidget(),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    TextField(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          // fontWeight: FontWeight.bold,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        controller: model?.code,
                        decoration: new InputDecoration(
                          hintText:
                              "${AppLocalizations.of(context)!.vveditekod}",
                          hintStyle: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 12,
                          ),
                          labelStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                          // icon: new Icon(Icons.confirmation_num_outlined),
                        )),
                    SizedBox(height: 35),
                    _AuthButtonCodeWidget(),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Не получили код?",
                style: TextStyle(fontSize: 14
                    // color: Colors.black38,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_start == 0) {
                      setState(() {
                        _start = 30;
                        startTimer();

                        RegetCode(
                          phoneNumber: phoneNum,
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
                            // _errorMessage = "номер телефона не найден";
                          } else if (value != 'error') {
                          } else {
                            print(
                                '${AppLocalizations.of(context)!.kodneotpravlen}');
                            // _errorMessage = "Не удалось отправить код";
                          }
                        });
                      });
                    }
                  },
                  child: Text(
                    _start == 0
                        ? "${AppLocalizations.of(context)!.otpravitkod}"
                        : '${AppLocalizations.of(context)!.otpravitkodpovtorno(_start.toString(), '30')}',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(BorderSide(
                        width: 2, color: AppColors.primaryColors[0])),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        AppColors.primaryColors[0]),
                    backgroundColor: _start == 0
                        ? MaterialStateProperty.all<Color>(Colors.white)
                        : MaterialStateProperty.all<Color>(Colors.transparent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthButtonCodeWidget extends StatelessWidget {
  const _AuthButtonCodeWidget({Key? key}) : super(key: key);

  void pressff(BuildContext context) {
    final model = NotifierProvider.watchOnModel<VerifyOtpModel>(context);

    if (model?.canStartAuth == true) {
      model?.authCode(context);
      print('can start auth');
    } else {
      print('cant start auth 236');
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watchOnModel<SendCodeModel>(context);

    final child = model?.isAuthProgress == true
        ? const SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 11),
              child: CircularProgressIndicator(
                // color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            height: 19,
            width: 41,
          )
        : const Text('Проверить');

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => pressff(context),
        child: child,
        style: ButtonStyle(
          // foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          // backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage =
        NotifierProvider.watchOnModel<VerifyOtpModel>(context)?.errorMessage;
    if (errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child:
          Text(errorMessage, style: TextStyle(color: Colors.red, fontSize: 17)),
    );
  }
}
