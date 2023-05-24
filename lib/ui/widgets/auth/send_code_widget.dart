import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:themoviedb/providers/provider.dart';
import 'package:provider/provider.dart' as pv;
import 'package:themoviedb/providers/locale_provider.dart';
import '../../../full/ui/register/step3_client_fiz_model.dart';
import 'login/text_field_container.dart';
import 'send_code_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendCode extends StatefulWidget {
  // const ChangeLanguage({required Key key}) : super(key: key);

  @override
  _SendCodeState createState() => _SendCodeState();
}

bool _isRegisterProgress = false;

String MessageLogin = '';
String MessagePass1 = '';
String MessagePass2 = '';

bool _isHidden0 = true;
bool _isHidden = true;

final username = TextEditingController();
final pass1 = TextEditingController();
final pass2 = TextEditingController();
final maskPhone = MaskTextInputFormatter(mask: "+7 (###)-###-##-##");

class _SendCodeState extends State<SendCode> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    print('object 37');
    super.initState();
    MessageLogin = '';
    MessagePass1 = '';
    MessagePass2 = '';

    username.text = '';
    pass1.text = '';
    pass2.text = '';
  }

  Widget build(BuildContext context) {
    void _togglePasswordView() {
      setState(() {
        _isHidden = !_isHidden;
      });
    }

    void _togglePasswordView0() {
      setState(() {
        _isHidden0 = !_isHidden0;
      });
    }

    var kPrimaryColor = Theme.of(context).primaryColor;
    final provider = pv.Provider.of<LocaleProvider>(context);

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("images/Image.png"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
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
                  // borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: 100,
                    child: Image.asset(
                        provider.selectedThemeMode == ThemeMode.dark
                            ? 'images/logo2.png'
                            : 'images/logo.png'),
                  ),
                ),
                SizedBox(height: 60),
                Text(
                  AppLocalizations.of(context)!.register,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.phoneNum}",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        // color: AppColors.primaryColors[0],
                      ),
                    ),
                  ],
                ),
                TextFieldContainer(
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    controller: username,
                    obscureText: false,
                    cursorColor: kPrimaryColor,
                    style: TextStyle(fontSize: 15),
                    inputFormatters: [maskPhone],
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      // labelText: "${AppLocalizations.of(context)!.phoneNum}",
                      hintStyle: TextStyle(color: Theme.of(context).hintColor),
                      labelStyle: TextStyle(color: Theme.of(context).hintColor),
                      errorText: MessageLogin.isEmpty ? null : MessageLogin,
                      icon: Icon(Icons.phone_outlined, color: kPrimaryColor),
                      border: InputBorder.none,
                      suffixIcon: MessageLogin ==
                              AppLocalizations.of(context)!.checkedName
                          ? Icon(Icons.done, color: kPrimaryColor)
                          : null,
                    ),
                  ),
                ),
                // TextFieldContainer(
                //   child: TextFormField(
                //     textInputAction: TextInputAction.next,
                //     controller: pass1,
                //     keyboardType: TextInputType.text,
                //     obscureText: false,
                //     cursorColor: kPrimaryColor,
                //     style: TextStyle(fontSize: 15),
                //     decoration: InputDecoration(
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: BorderSide(color: Colors.transparent),
                //       ),
                //       label: Text(
                //         '${AppLocalizations.of(context)!.pridumaiteparol}',
                //       ),
                //       hintStyle: TextStyle(color: Theme.of(context).hintColor),
                //       labelStyle: TextStyle(color: Theme.of(context).hintColor),
                //       errorText: MessagePass1.isEmpty ? null : MessagePass1,
                //       icon: Icon(Icons.lock_outline, color: kPrimaryColor),
                //       suffixIcon:
                //           Icon(Icons.visibility_outlined, color: kPrimaryColor),
                //       border: InputBorder.none,
                //     ),
                //   ),
                // ),
                Row(
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.pridumaiteparol}",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        // color: AppColors.primaryColors[0],
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 8),
                TextFieldContainer(
                  child: TextFormField(
                    onEditingComplete: () {
                      TextInput.finishAutofillContext();
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    },
                    autofillHints: [AutofillHints.password],
                    controller: pass1,
                    obscureText: _isHidden0,
                    cursorColor: kPrimaryColor,
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      // labelText: "Пароль",
                      // hintText: "Введите пароль",
                      hintStyle: TextStyle(color: Theme.of(context).hintColor),
                      labelStyle: TextStyle(color: Theme.of(context).hintColor),

                      errorText: MessagePass1.isEmpty ? null : MessagePass1,
                      icon: Icon(Icons.lock_outline, color: kPrimaryColor),
                      border: InputBorder.none,
                      suffix: InkWell(
                        onTap: _togglePasswordView0,
                        child: Icon(
                          _isHidden
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                // TextFieldContainer(
                //   child: TextFormField(
                //     keyboardType: TextInputType.text,
                //     style: TextStyle(fontSize: 15),
                //     textInputAction: TextInputAction.done,
                //     controller: pass2,
                //     obscureText: false,
                //     cursorColor: kPrimaryColor,
                //     decoration: InputDecoration(
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: BorderSide(color: Colors.transparent),
                //       ),
                //       label: Text(
                //         '${AppLocalizations.of(context)!.paroleshoraz}',
                //       ),
                //       hintStyle: TextStyle(color: Theme.of(context).hintColor),
                //       labelStyle: TextStyle(color: Theme.of(context).hintColor),
                //       errorText: MessagePass2.isEmpty ? null : MessagePass2,
                //       icon: Icon(Icons.lock_outline, color: kPrimaryColor),
                //       suffixIcon:
                //           Icon(Icons.visibility_outlined, color: kPrimaryColor),
                //       border: InputBorder.none,
                //     ),
                //   ),
                // ),
                Row(
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.paroleshoraz}",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        // color: AppColors.primaryColors[0],
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 8),
                TextFieldContainer(
                  child: TextFormField(
                    onEditingComplete: () {
                      TextInput.finishAutofillContext();
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    },
                    autofillHints: [AutofillHints.password],
                    controller: pass2,
                    obscureText: _isHidden,
                    cursorColor: kPrimaryColor,
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      // labelText: "Пароль",
                      // hintText: "Введите пароль",
                      hintStyle: TextStyle(color: Theme.of(context).hintColor),
                      labelStyle: TextStyle(color: Theme.of(context).hintColor),

                      errorText: MessagePass2.isEmpty ? null : MessagePass2,
                      icon: Icon(Icons.lock_outline, color: kPrimaryColor),
                      border: InputBorder.none,
                      suffix: InkWell(
                        onTap: _togglePasswordView,
                        child: Icon(
                          _isHidden
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                _ErrorMessageWidget(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => pressff(context),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                    ),
                    child: funk(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pressff(BuildContext context) {
    setState(
      () {
        if (username.text.isEmpty) {
          MessageLogin = '${AppLocalizations.of(context)!.vveditenomertel}';
        } else if (pass1.text.isEmpty) {
          MessagePass1 = AppLocalizations.of(context)!.enterPass;
        } else if (pass2.text.isEmpty) {
          MessagePass2 = AppLocalizations.of(context)!.enterPass2;
        } else if (pass1.text != pass2.text) {
          MessagePass1 = AppLocalizations.of(context)!.notCheckedPass;
          MessagePass2 = AppLocalizations.of(context)!.notCheckedPass;
        }
      },
    );
    _isRegisterProgress = true;
    if ((username.text.isNotEmpty &&
            pass1.text.isNotEmpty &&
            pass2.text.isNotEmpty) &&
        (pass1.text == pass2.text)) {
      try {
        print('try');
        VerifyName(Name: username.text.replaceAll(' ', '')).getName().then(
          (value) {
            print('Response: $value');

            if (value != 'error') {
              if (0 == int.parse(value) || 1 == int.parse(value)) {
                _isRegisterProgress = false;

                final model =
                    NotifierProvider.watchOnModel<SendCodeModel>(context);

                var temp = maskPhone.getUnmaskedText();
                if (temp.isNotEmpty) {
                  model!.phoneNumber.text = temp;
                  model.login.text = temp;
                }
                model!.pass.text = pass1.text;

                if (model.canStartAuth == true) {
                  model.sendCode(context);
                  print('can start auth 230');
                } else {
                  print('cant start auth 232');
                }

                // Navigator.of(context).pushNamed(
                //   MainNavigationRouteNames.sendCode,
                //   arguments: {
                //     'username': username.text,
                //     'pass': pass1.text,
                //   },
                // );

                setState(() {
                  // username.text = "";
                  // pass1.text = "";
                  // pass2.text = "";
                  MessageLogin = "";
                  MessagePass1 = "";
                  MessagePass2 = "";
                });
              } else {
                _isRegisterProgress = false;
                print('Данный пользователь уже зарегистрирован');
                setState(() {
                  MessageLogin =
                      AppLocalizations.of(context)!.alreadyregistered;
                });
              }
            } else {
              _isRegisterProgress = false;
              print('Не удалось проверить имя');
              setState(() {
                MessageLogin = AppLocalizations.of(context)!.notCheckName;
              });
            }
          },
        );
        print('cant start auth 269');
      } catch (e) {
        _isRegisterProgress = false;
      }
    } else {
      _isRegisterProgress = false;
    }
  }

  funk(BuildContext context) {
    if (_isRegisterProgress == true) {
      return SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        ),
        height: 19,
        width: 41,
      );
    } else {
      return Text(
        AppLocalizations.of(context)!.register2,
        style: TextStyle(fontSize: 16),
      );
    }
  }
}

// ignore: unused_element
class _AuthButtonPhoneWidget extends StatelessWidget {
  const _AuthButtonPhoneWidget({Key? key}) : super(key: key);

  void pressff(BuildContext context) {
    final model = NotifierProvider.watchOnModel<SendCodeModel>(context);
    if (model?.canStartAuth == true) {
      model?.sendCode(context);
      print('can start auth');
    } else {
      print('cant start auth 309');
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
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            height: 19,
            width: 41,
          )
        : Text('${AppLocalizations.of(context)!.login}');
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          pressff(context);
        },
        child: child,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
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
        NotifierProvider.watchOnModel<SendCodeModel>(context)?.errorMessage;
    if (errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child:
          Text(errorMessage, style: TextStyle(color: Colors.red, fontSize: 17)),
    );
  }
}
