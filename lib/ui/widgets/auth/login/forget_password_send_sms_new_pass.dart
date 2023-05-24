import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../domain/data_providers/session_data_provider.dart';
import '../../../../full/ui/register/step3_client_fiz_model.dart';
import '../../../navigation/main_navigation.dart';
import '../../app/my_app.dart';
import 'text_field_container.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class SendNewPass extends StatefulWidget {
  final String PhoneNum;
  SendNewPass({required this.PhoneNum});

  @override
  _SendNewPassState createState() => _SendNewPassState();
}

String MessageCode = '';
String MessagePass1 = '';
String MessagePass2 = '';

final code = TextEditingController();
final pass1 = TextEditingController();
final pass2 = TextEditingController();

bool load = false;

class _SendNewPassState extends State<SendNewPass> {
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

    load = false;

    MessageCode = '';
    MessagePass1 = '';
    MessagePass2 = '';
    code.text = '';
    pass1.text = '';
    pass2.text = '';
  }

  Widget build(BuildContext context) {
    var kPrimaryColor = Theme.of(context).primaryColor;
    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(
      //       Icons.arrow_back,
      //       // color: Colors.white,
      //     ),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      //   // backgroundColor: Colors.purple,
      // ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("images/Image.png"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 32),
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
                    child: SizedBox(
                        width: 100,
                        child: Image.asset(
                            provider.selectedThemeMode == ThemeMode.dark
                                ? 'images/logo2.png'
                                : 'images/logo.png')),
                  ),
                  SizedBox(height: 60),
                  Text(
                    '${AppLocalizations.of(context)!.vosstanovleniedostupa}',
                    style: TextStyle(fontSize: 20),
                  ),
                  TextFieldContainer(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: code,
                      obscureText: false,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        hintText: '${AppLocalizations.of(context)!.vveditekod}',
                        hintStyle: TextStyle(fontSize: 12),
                        errorText: MessageCode.isEmpty ? null : MessageCode,
                        icon: Icon(
                          Icons.format_list_numbered_outlined,
                          color: kPrimaryColor,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextFieldContainer(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: pass1,
                      obscureText: false,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        hintText:
                            "${AppLocalizations.of(context)!.pridumaiteparol}",
                        hintStyle: TextStyle(fontSize: 12),
                        errorText: MessagePass1.isEmpty ? null : MessagePass1,
                        icon: Icon(Icons.lock_outline, color: kPrimaryColor),
                        suffixIcon: Icon(Icons.visibility_outlined,
                            color: kPrimaryColor),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextFieldContainer(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      controller: pass2,
                      obscureText: false,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        hintText:
                            "${AppLocalizations.of(context)!.paroleshoraz}",
                        hintStyle: TextStyle(fontSize: 12),
                        errorText: MessagePass2.isEmpty ? null : MessagePass2,
                        icon: Icon(Icons.lock_outline, color: kPrimaryColor),
                        suffixIcon: Icon(Icons.visibility_outlined,
                            color: kPrimaryColor),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!load)
                          setState(() {
                            if (code.text == '') {
                              MessageCode =
                                  '${AppLocalizations.of(context)!.vveditekod}';
                              MessagePass1 = '';
                              MessagePass2 = '';
                            } else if (code.text.length <= 2) {
                              MessageCode =
                                  '${AppLocalizations.of(context)!.minimum3simvola}';
                              MessagePass1 = '';
                              MessagePass2 = '';
                            } else if (pass1.text == '') {
                              MessageCode = '';
                              MessagePass1 =
                                  '${AppLocalizations.of(context)!.vvediteparol}';
                              MessagePass2 = '';
                            } else if (pass1.text.length <= 5) {
                              MessageCode = '';
                              MessagePass1 =
                                  '${AppLocalizations.of(context)!.minimum6simvola}';
                              MessagePass2 = '';
                            } else if (pass2.text == '') {
                              MessageCode = '';
                              MessagePass1 = '';
                              MessagePass2 =
                                  '${AppLocalizations.of(context)!.podtverditeparol}';
                            } else if (pass1.text.length <= 5) {
                              MessageCode = '';
                              MessagePass1 = '';
                              MessagePass2 =
                                  '${AppLocalizations.of(context)!.minimum6simvola}';
                            } else if (pass1.text != pass2.text) {
                              MessageCode = '';
                              MessagePass1 =
                                  '${AppLocalizations.of(context)!.parolnesovpodaiut}';
                              MessagePass2 =
                                  '${AppLocalizations.of(context)!.parolnesovpodaiut}';
                            } else {
                              MessageCode = '';
                              MessagePass1 = '';
                              MessagePass2 = '';

                              setState(() {
                                load = true;
                              });

                              ResetPassword(
                                phoneNumber: widget.PhoneNum,
                                password: pass1.text,
                                recoverCode: int.parse(code.text),
                              ).send().then((value) {
                                print('Response: $value');

                                if (value.toString() == '401') {
                                  final provider = SessionDataProvider();
                                  provider.setSessionId(null);
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      MainNavigationRouteNames.changeLang,
                                      (Route<dynamic> route) => false);
                                }
                                if (value.contains('code-wrong')) {
                                  setState(() {
                                    load = false;
                                    MessageCode =
                                        "${AppLocalizations.of(context)!.nepravilnuiparol}";
                                  });
                                } else if (value != 'error') {
                                  setState(() {
                                    load = false;
                                  });
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                } else {
                                  print('Не удалось отправить код');
                                  setState(() {
                                    load = false;
                                    MessageCode =
                                        "${AppLocalizations.of(context)!.kodneotpravlen}";
                                  });
                                }
                              });
                            }
                          });
                      },
                      style: ButtonStyle(
                        // foregroundColor:
                        //     MaterialStateProperty.all<Color>(Colors.white),
                        // backgroundColor:
                        //     MaterialStateProperty.all<Color>(Colors.purple),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: load
                            ? CircularProgressIndicator()
                            : Text(AppLocalizations.of(context)!.login,
                                style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_start == 0) {
                          setState(() {
                            _start = 30;
                            startTimer();

                            Recover(phoneNumber: widget.PhoneNum)
                                .send()
                                .then((value) {
                              print('Response: $value');

                              if (value.toString() == '401') {
                                final provider = SessionDataProvider();
                                provider.setSessionId(null);
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    MainNavigationRouteNames.changeLang,
                                    (Route<dynamic> route) => false);
                              }
                              if (value.contains('no-number')) {
                                setState(() {
                                  load = false;
                                  MessageCode =
                                      "${AppLocalizations.of(context)!.nomernenaiden}";
                                });
                              } else if (value != 'error') {
                                // setState(() {
                                //   load = false;
                                // });
                              } else {
                                print('Не удалось отправить код');
                                setState(() {
                                  // load = false;
                                  MessageCode =
                                      "${AppLocalizations.of(context)!.kodneotpravlen}";
                                });
                              }
                            });
                          });
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          _start == 0
                              ? "${AppLocalizations.of(context)!.otpravitkod}"
                              : '${AppLocalizations.of(context)!.otpravitkodpovtorno(_start.toString(), '30')}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(BorderSide(
                            width: 2, color: AppColors.primaryColors[0])),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            AppColors.primaryColors[0]),
                        backgroundColor: _start == 0
                            ? MaterialStateProperty.all<Color>(Colors.white)
                            : MaterialStateProperty.all<Color>(
                                Colors.transparent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
        ),
      ),
    );
  }
}
