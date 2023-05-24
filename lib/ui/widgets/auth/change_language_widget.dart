import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';
import 'package:themoviedb/ui/widgets/auth/login/login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../language_picker_widget.dart';

class ChangeLanguage extends StatefulWidget {
  // const ChangeLanguage({required Key key}) : super(key: key);

  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
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
            padding: EdgeInsets.symmetric(vertical: 100, horizontal: 32),
            child: Column(
              children: [
                ClipRRect(
                  // borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: 130,
                    child: Image.asset(
                        provider.selectedThemeMode == ThemeMode.dark
                            ? 'images/logo2.png'
                            : 'images/logo.png'),
                  ),
                ),

                SizedBox(height: 60),
                Text(
                  AppLocalizations.of(context)!.checklanguage,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 32),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.language,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),

                LanguagePickerWidget(),

                SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.vimozhete,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24),

                // SizedBox(
                //   height: 38,
                // ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Login();
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text(
                        AppLocalizations.of(context)!.continuekey,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),

                // SizedBox(
                //   height: 100,
                // ),
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

Future<dynamic> SheetBarDriver(BuildContext context) {
  // final provider = Provider.of<LocaleProvider>(context);
  // final locale = provider.locale ?? Locale('en');

  // final flag = L10n.getFlag(locale.languageCode);

  return showAdaptiveActionSheet(
    context: context,
    actions: <BottomSheetAction>[
      BottomSheetAction(
        title: const Text(
          'Қазақ тілі',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: (context) {
          Navigator.of(context).pop();
          // Navigator.of(context).pushNamed(MainNavigationRouteNames.sendCode);

          final provider = Provider.of<LocaleProvider>(context, listen: false);
          provider.setLocale(Locale('kk'));

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Login();
              },
            ),
          );
        },
        // leading: const Icon(Icons.circle_outlined, size: 25),
      ),
      BottomSheetAction(
        title: const Text(
          'Русский',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: (context) {
          Navigator.of(context).pop();
          // Navigator.of(context).pushNamed(MainNavigationRouteNames.sendCode);

          final provider = Provider.of<LocaleProvider>(context, listen: false);
          provider.setLocale(Locale('ru'));

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Login();
              },
            ),
          );
        },
        // leading: const Icon(Icons.circle_outlined, size: 25),
      ),
      BottomSheetAction(
        title: const Text(
          'English',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: (context) {
          Navigator.of(context).pop();
          // Navigator.of(context).pushNamed(MainNavigationRouteNames.sendCode);

          final provider = Provider.of<LocaleProvider>(context, listen: false);
          provider.setLocale(Locale('en'));

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Login();
              },
            ),
          );
        },
        // leading: const Icon(Icons.circle_outlined, size: 25),
      ),
    ],
    cancelAction: CancelAction(
        title: const Text(
      'Закрыть',
      style: TextStyle(color: Colors.blueAccent),
    )),
  );
}
