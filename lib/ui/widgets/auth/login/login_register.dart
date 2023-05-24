import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'text_field_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginReg extends StatefulWidget {
  // const ChangeLanguage({required Key key}) : super(key: key);

  @override
  _LoginRegState createState() => _LoginRegState();
}

bool _isRegisterProgress = false;

String MessageLogin = '';
String MessagePass1 = '';
String MessagePass2 = '';

final username = TextEditingController();
final pass1 = TextEditingController();
final pass2 = TextEditingController();

class _LoginRegState extends State<LoginReg> {
  @override
  void initState() {
    super.initState();
    MessageLogin = '';
    MessagePass1 = '';
    MessagePass2 = '';

    username.text = '';
    pass1.text = '';
    pass2.text = '';
  }

  // @override
  // void dispose() {
  //   username.dispose();
  //   pass1.dispose();
  //   pass2.dispose();
  //   super.dispose();
  // }

  Widget build(BuildContext context) {
    var kPrimaryColor = Theme.of(context).primaryColor;

    final maskPhone = MaskTextInputFormatter(mask: "8 (###)-###-##-##");

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            // color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // backgroundColor: Colors.purple,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/Image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 22, horizontal: 32),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: 200,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.register,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFieldContainer(
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    controller: username,
                    obscureText: false,
                    cursorColor: kPrimaryColor,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    inputFormatters: [maskPhone],
                    decoration: InputDecoration(
                      labelText: "Номер телефона",
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                      errorText: MessageLogin.isEmpty ? null : MessageLogin,
                      icon: Icon(
                        Icons.phone,
                        color: kPrimaryColor,
                      ),
                      border: InputBorder.none,
                      prefix: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '+7 ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      suffixIcon: MessageLogin ==
                              AppLocalizations.of(context)!.checkedName
                          ? Icon(
                              Icons.done,
                              color: kPrimaryColor,
                            )
                          : null,
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
                      hintText: AppLocalizations.of(context)!.enterPass,
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                      errorText: MessagePass1.isEmpty ? null : MessagePass1,
                      icon: Icon(
                        Icons.lock,
                        color: kPrimaryColor,
                      ),
                      suffixIcon: Icon(
                        Icons.visibility,
                        color: kPrimaryColor,
                      ),
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
                      hintText: AppLocalizations.of(context)!.enterPass2,
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                      errorText: MessagePass2.isEmpty ? null : MessagePass2,
                      icon: Icon(
                        Icons.lock,
                        color: kPrimaryColor,
                      ),
                      suffixIcon: Icon(
                        Icons.visibility,
                        color: kPrimaryColor,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => pressff(context),
                    child: funk(context),
                    style: ButtonStyle(
                      // foregroundColor:
                      //     MaterialStateProperty.all<Color>(Colors.white),
                      // backgroundColor:
                      //     MaterialStateProperty.all<Color>(Colors.purple),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),
                // Text(
                //   AppLocalizations.of(context)!.kazlog,
                //   style: TextStyle(
                //     fontSize: 14,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.white,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                // SizedBox(
                //   height: 100,
                // ),
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
          MessageLogin = AppLocalizations.of(context)!.enterLogin;
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
        VerifyName(Name: username.text.replaceAll(' ', '')).getName().then(
          (value) {
            print('Response: $value');

            if (value != 'error') {
              if (0 == int.parse(value) || 1 == int.parse(value)) {
                _isRegisterProgress = false;

                Navigator.of(context).pushNamed(
                  MainNavigationRouteNames.sendCode,
                  arguments: {
                    'username': username.text,
                    'pass': pass1.text,
                  },
                );

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
        print('cant start auth 291');
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
