import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../ui/widgets/main_screen/menu_list/profile/profile_page.dart';
import 'step3_client_fiz_model.dart';

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class RegisterStep3DriverUrDriverView extends StatefulWidget {
  const RegisterStep3DriverUrDriverView({Key? key}) : super(key: key);

  @override
  _RegisterStep3DriverUrDriverViewState createState() =>
      _RegisterStep3DriverUrDriverViewState();
}

String isEmpWidget = '';

String WidgetStatusMsg = '';

final iin = TextEditingController();
final driverCode = TextEditingController();

class _RegisterStep3DriverUrDriverViewState
    extends State<RegisterStep3DriverUrDriverView> {
  @override
  Widget build(BuildContext context) {
    final pm = ProfileModel();
    pm.setupLocale(context);

    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${AppLocalizations.of(context)!.register}/${AppLocalizations.of(context)!.voditel}',
          style: TextStyle(
            // color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Row(),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      controller: iin,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(
                            12), // Ограничение на 12 символов
                      ],
                      textInputAction: TextInputAction.next,
                      maxLength: 12, // Limit the input to 12 digits
                      decoration: InputDecoration(
                        fillColor: provider.selectedThemeMode == ThemeMode.dark
                            ? Color.fromRGBO(53, 54, 61, 1)
                            : Colors.white,
                        labelText: AppLocalizations.of(context)!.iin,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value.length != 12) {
                          return 'Введите 12 цифр';
                        }
                        return null; // Возвращаем null, если ввод корректен
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: driverCode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        fillColor: provider.selectedThemeMode == ThemeMode.dark
                            ? Color.fromRGBO(53, 54, 61, 1)
                            : Colors.white,
                        labelText:
                            'Code ${AppLocalizations.of(context)!.voditel}',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: 10),
              WidgetStatusMsg.isNotEmpty
                  ? Text(
                      WidgetStatusMsg,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    )
                  : Text(''),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.sohranit),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 100, vertical: 20)),
                    onPressed: () {
                      setState(() {
                        WidgetStatusMsg = 'Проблемы с сетью';
                        WidgetStatusMsg = 'Повторите запрос';
                        WidgetStatusMsg = 'Не верный ИИН или Код водителя';
                      });
                      RegisterDriverCompany(
                        iin: iin.text,
                        driverCode: driverCode.text,
                        token: pm.token.toString(),
                      ).register().then(
                        (value) {
                          print('Response: $value');

                          if (value.toString() == '401') {
                            final provider = SessionDataProvider();
                            provider.setSessionId(null);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                MainNavigationRouteNames.changeLang,
                                (Route<dynamic> route) => false);
                          }

                          if (value.contains('Успешная регистрация!')) {
                            _onBasicAlertPressed(context);
                          } else if (value.contains('уже зарегистрирован')) {
                            _onBasicAlertPressed2(context);
                          } else {
                            _onBasicAlertPressed3(context);
                          }
                        },
                      );
                      // setState(
                      //   () {
                      //     if (widget.edit) {
                      //       UpdateClientFiz(
                      //         img: base64img.text,
                      //         token: pm.token,
                      //         clientId: widget.jdata['clientId'],
                      //         fName: fName.text,
                      //         lName: lName.text,
                      //         pName: '',
                      //         iin: iin.text,
                      //         driverCode: driverCode.text,
                      //       ).UpdateData().then(
                      //         (value) {
                      //           print('Response: $value');

                      //           if (value == 'success') {
                      //             _onBasicAlertPressed(context);
                      //           }
                      //         },
                      //       );
                      //     } else {
                      //       RegisterDbClienIndi(
                      //               fName: fName.text,
                      //               lName: lName.text,
                      //               pName: pName.text,
                      //               iin: iin.text,
                      //               driverCode: driverCode.text,
                      //               token: pm.token.toString(),
                      //               base64Img: base64img.text)
                      //           .register()
                      //           .then(
                      //         (value) {
                      //           print('Response: $value');

                      //           if (value.contains('Успешная регистрация!')) {
                      //             _onBasicAlertPressed(context);
                      //           } else if (value
                      //               .contains('уже зарегистрирован')) {
                      //             _onBasicAlertPressed2(context);
                      //           } else {
                      //             _onBasicAlertPressed3(context);
                      //           }
                      //         },
                      //       );
                      //     }

                      GetSysType(
                        token: pm.token.toString(),
                        sysUserType: pm.sysUserType.toString(),
                      ).getSysType().then(
                        (value) {
                          print('Response: $value');

                          if (value.toString() == '401') {
                            final provider = SessionDataProvider();
                            provider.setSessionId(null);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                MainNavigationRouteNames.changeLang,
                                (Route<dynamic> route) => false);
                          }
                        },
                      );

                      //     print('end register 1 response');
                      //   },
                      // );
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  _onBasicAlertPressed(context) {
    var alertStyle = AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: true,
        isOverlayTapDismiss: true,
        descStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
        animationDuration: Duration(milliseconds: 250),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(
          color: Colors.red,
        ));
    Alert(
        context: context,
        style: alertStyle,
        // title: "RFLUTTER ALERT",
        desc: AppLocalizations.of(context)!.uspeshnoSohran,
        buttons: [
          DialogButton(
            onPressed: () async {
              final _sessionDataProvider = SessionDataProvider();
              await _sessionDataProvider.setRoleType("5");

              Navigator.of(context).pushNamedAndRemoveUntil(
                  MainNavigationRouteNames.mainScreen,
                  (Route<dynamic> route) => false);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileView(),
                ),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.prodolzhit,
              style: TextStyle(fontSize: 13),
            ),
          )
        ]).show();
  }

  _onBasicAlertPressed2(context) {
    var alertStyle = AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: true,
        isOverlayTapDismiss: true,
        descStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
        animationDuration: Duration(milliseconds: 250),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(
          color: Colors.red,
        ));
    Alert(
        context: context,
        style: alertStyle,
        // title: "RFLUTTER ALERT",
        desc: AppLocalizations.of(context)!.dannuiPolzovatelUsheVSisteme,
        buttons: [
          DialogButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.prodolzhit,
              style: TextStyle(fontSize: 20),
            ),
          )
        ]).show();
  }

  _onBasicAlertPressed3(context) {
    var alertStyle = AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: true,
        isOverlayTapDismiss: true,
        descStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
        animationDuration: Duration(milliseconds: 250),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(
          color: Colors.red,
        ));
    Alert(
        context: context,
        style: alertStyle,
        // title: "RFLUTTER ALERT",
        desc: AppLocalizations.of(context)!.povtoritePopitku2,
        buttons: [
          DialogButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.prodolzhit,
              style: TextStyle(fontSize: 20),
            ),
          )
        ]).show();
  }
}
