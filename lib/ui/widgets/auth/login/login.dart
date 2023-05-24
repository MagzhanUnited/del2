import 'package:flutter/material.dart';
import 'package:themoviedb/ui/widgets/app/my_app.dart';
import 'package:themoviedb/ui/widgets/auth/login/login_vhod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

import '../../../navigation/main_navigation.dart';

class Login extends StatefulWidget {
  // const ChangeLanguage({required Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
                  // borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: 184,
                    child: Image.asset(
                        provider.selectedThemeMode == ThemeMode.dark
                            ? 'images/logo2.png'
                            : 'images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Text(
                  AppLocalizations.of(context)!.welcome,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 80,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginIn();
                          },
                        ),
                      );
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all<BorderSide>(BorderSide(
                          width: 2, color: AppColors.primaryColors[0])),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          AppColors.primaryColors[0]),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text(
                        AppLocalizations.of(context)!.login.toUpperCase(),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        MainNavigationRouteNames.sendCode,
                        arguments: {
                          'username': "",
                          'pass': "",
                        },
                      );
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text(
                        AppLocalizations.of(context)!.register.toUpperCase(),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 90),
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
}
