import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../domain/data_providers/session_data_provider.dart';
import '../../../../full/ui/register/step3_client_fiz_model.dart';
import '../../../navigation/main_navigation.dart';
import 'forget_password_send_sms_new_pass.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class ResetPass extends StatefulWidget {
  @override
  _ResetPassState createState() => _ResetPassState();
}

var phoneNumber = TextEditingController();
String phoneNumberMessage = '';

bool load = false;

class _ResetPassState extends State<ResetPass> {
  @override
  void initState() {
    super.initState();
    phoneNumber.text = '';
    phoneNumberMessage = '';
    load = false;
  }

  // @override
  // void dispose() {
  //   phoneNumber.dispose();
  //   super.dispose();
  // }

  Widget build(BuildContext context) {
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
                  '${AppLocalizations.of(context)!.zabyliparol}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 12),
                Text(
                  "${AppLocalizations.of(context)!.dlyavosstandostupa}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 25),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: phoneNumber,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone_outlined, size: 20),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          errorText: phoneNumberMessage.isEmpty
                              ? null
                              : phoneNumberMessage,
                          prefix: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '+7 ',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!load) {
                        if (phoneNumber.text == '') {
                          setState(() {
                            phoneNumberMessage =
                                "${AppLocalizations.of(context)!.vveditenomertel}";
                            return;
                          });
                        } else if (phoneNumber.text.length != 10) {
                          setState(() {
                            phoneNumberMessage =
                                "${AppLocalizations.of(context)!.nomertelnevernui}";
                          });
                        } else {
                          try {
                            print('ok');
                            setState(() {
                              load = true;
                              phoneNumberMessage = "";
                            });

                            Recover(phoneNumber: phoneNumber.text)
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
                                print('Данный номер не найден в системе');
                                setState(() {
                                  load = false;
                                  phoneNumberMessage =
                                      "${AppLocalizations.of(context)!.nomernenaiden}";
                                });
                              } else if (value != 'error') {
                                setState(() {
                                  load = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SendNewPass(
                                      PhoneNum: phoneNumber.text,
                                    ),
                                  ),
                                );
                              } else {
                                print('Не удалось отправить код');
                                setState(() {
                                  load = false;
                                  phoneNumberMessage =
                                      "${AppLocalizations.of(context)!.kodneotpravlen}";
                                });
                              }
                            });
                          } catch (e) {
                            setState(() {
                              phoneNumberMessage =
                                  "${AppLocalizations.of(context)!.kodneotpravlen}";
                            });
                          }
                        }
                      }
                    },
                    style: ButtonStyle(
                      // foregroundColor:
                      //     MaterialStateProperty.all<Color>(Colors.white),
                      // backgroundColor:
                      //     MaterialStateProperty.all<Color>(Colors.purple),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: load
                          ? CircularProgressIndicator()
                          : Text(
                              '${AppLocalizations.of(context)!.otpravitkod}',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
