import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import '../../app/my_app.dart';
import 'forget_password.dart';
import 'login_register.dart';
import 'text_field_container.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class LoginIn extends StatefulWidget {
  @override
  _LoginInState createState() => _LoginInState();
}

class _LoginInState extends State<LoginIn> {
  var username = TextEditingController();
  var pass1 = TextEditingController();

  var phoneNum = '';
  var maskPhone = MaskTextInputFormatter(mask: "+7 (###)-###-##-##");

  bool _isHidden = true;

  bool _isRegisterProgress = false;

  @override
  void initState() {
    super.initState();

    _isRegisterProgress = false;

    phoneNum = '';

    maskPhone = MaskTextInputFormatter(mask: "+7 (###)-###-##-##");

    username.text = '';
    pass1.text = '';

    MessageLogin = '';
    MessagePass1 = "";

    _isHidden = true;
  }

  // @override
  // void dispose() {
  //   username.dispose();
  //   pass1.dispose();
  //   super.dispose();
  // }

  Widget build(BuildContext context) {
    void _togglePasswordView() {
      setState(() {
        _isHidden = !_isHidden;
      });
    }

    var kPrimaryColor = Theme.of(context).primaryColor;

    var elevatedButton = ElevatedButton(
      onPressed: _isRegisterProgress
          ? () {
              print('Loading ****');
            }
          : () {
              _isRegisterProgress = true;

              var temp = maskPhone.getUnmaskedText();
              if (temp.isNotEmpty)
                setState(() {
                  phoneNum = maskPhone.getUnmaskedText();
                });

              print(username.text);
              print(temp);

              if (username.text == '') {
                setState(() {
                  MessageLogin =
                      "${AppLocalizations.of(context)!.vveditenomertel}";
                  MessagePass1 = "";
                  _isRegisterProgress = false;
                });
              } else if (pass1.text == '') {
                setState(() {
                  MessageLogin = "";
                  MessagePass1 =
                      "${AppLocalizations.of(context)!.vvediteparol}";
                  _isRegisterProgress = false;
                });
              } else {
                try {
                  LoginAuth(Name: phoneNum, pass: pass1.text).getName().then(
                    (value) {
                      print('Response: $value');

                      if (value != 'error') {
                        username.text = "";
                        pass1.text = "";
                        setState(() {
                          MessageLogin = "";
                          MessagePass1 = "";
                        });

                        Navigator.of(context).pushNamedAndRemoveUntil(
                            MainNavigationRouteNames.mainScreen,
                            (Route<dynamic> route) => false);
                      } else {
                        print('Не удалось проверить имя');
                        setState(() {
                          MessageLogin =
                              "${AppLocalizations.of(context)!.nepravlogin}";
                        });
                      }
                      _isRegisterProgress = false;
                    },
                  );
                  print('cant start auth 123');
                } catch (e) {
                  _isRegisterProgress = false;
                  print('Повторите попытку');
                }
              }
              setState(() {});
            },
      style: ButtonStyle(
        // foregroundColor:
        //     MaterialStateProperty.all<Color>(Colors.white),
        // backgroundColor:
        //     MaterialStateProperty.all<Color>(Colors.purple),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.0),
        child: SizedBox(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: _isRegisterProgress
                ? CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                : Text(AppLocalizations.of(context)!.login,
                    style: TextStyle(fontSize: 14)),
          ),
        ),
      ),
    );

    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(
      //       Icons.arrow_back,
      //       color: Colors.white,
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
        //       image: AssetImage("images/Image.png"), fit: BoxFit.cover),
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
                  child: SizedBox(
                      width: 100,
                      child: Image.asset(
                          provider.selectedThemeMode == ThemeMode.dark
                              ? 'images/logo2.png'
                              : 'images/logo.png')),
                ),
                SizedBox(height: 60),
                Text(
                  AppLocalizations.of(context)!.login,
                  style: TextStyle(fontSize: 20),
                ),
                // SizedBox(height: 10),
                AutofillGroup(
                  child: Column(
                    children: [
                      SizedBox(height: 32),
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
                      SizedBox(height: 8),
                      TextFieldContainer(
                        child: TextFormField(
                          autofillHints: [AutofillHints.username],
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
                            // labelText: "Номер телефона",
                            // hintText: "Логин",
                            hintStyle:
                                TextStyle(color: Theme.of(context).hintColor),
                            labelStyle:
                                TextStyle(color: Theme.of(context).hintColor),

                            errorText:
                                MessageLogin.isEmpty ? null : MessageLogin,
                            icon: Icon(Icons.phone_outlined,
                                color: kPrimaryColor),
                            border: InputBorder.none,
                            suffixIcon: MessageLogin == 'Имя проверено'
                                ? Icon(Icons.done, color: kPrimaryColor)
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.parol}",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              // color: AppColors.primaryColors[0],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      TextFieldContainer(
                        child: TextFormField(
                          onEditingComplete: () {
                            TextInput.finishAutofillContext();
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                          },
                          autofillHints: [AutofillHints.password],
                          controller: pass1,
                          obscureText: _isHidden,
                          cursorColor: kPrimaryColor,
                          style: TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            // labelText: "Пароль",
                            // hintText: "Введите пароль",
                            hintStyle:
                                TextStyle(color: Theme.of(context).hintColor),
                            labelStyle:
                                TextStyle(color: Theme.of(context).hintColor),

                            errorText:
                                MessagePass1.isEmpty ? null : MessagePass1,
                            icon:
                                Icon(Icons.lock_outline, color: kPrimaryColor),
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
                    ],
                  ),
                ),

                SizedBox(height: 20),
                //ВОЙТИ кнопка
                SizedBox(
                  width: double.infinity,
                  child: elevatedButton,
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ResetPass();
                    }));
                  },
                  child: Text(
                    '${AppLocalizations.of(context)!.zabyliparol}',
                    style: TextStyle(
                      color: provider.selectedThemeMode == ThemeMode.dark
                          ? Colors.white
                          : AppColors.primaryColors[0],
                      fontSize: 12,
                    ),
                  ),
                ),
                // SizedBox(height: 50),
                // Text(
                //   "При поддержке СТК “KAZLOGISTICS”",
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
}
