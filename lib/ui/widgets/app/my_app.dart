import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'my_app_model.dart';
import 'package:themoviedb/l10n/l10n.dart';

class MyApp extends StatelessWidget {
  final MyAppModel model;
  static final mainNavigation = MainNavigation();
  const MyApp({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);

        // provider.selectedThemeMode = ThemeMode.dark;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'baza',
          themeMode: provider.selectedThemeMode,
          // themeMode: ThemeMode.dark,
          theme: ThemeData(
            primarySwatch: AppColors.getMaterialColorFromColor(
                Colors.white), //appbar back color
            primaryColor: AppColors.primaryColors[0], //border and back color
            brightness: Brightness.light, //жалпв барлыгына ашык тема,
            dividerColor: AppColors.primaryColors[0],
            scaffoldBackgroundColor: AppColors.primaryColors[1],
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.primaryColors[0],
              selectionColor: Colors.grey[500],
              selectionHandleColor: Colors.grey,
            ),

            inputDecorationTheme: InputDecorationTheme(
              fillColor: Colors.white,
              hintStyle: TextStyle(color: Theme.of(context).hintColor),
              labelStyle: TextStyle(color: Theme.of(context).hintColor),
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(228, 232, 250, 1))),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),

            // для всех кнопок
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.primaryColors[0]),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
            appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: AppColors.primaryColors[0],
              ),
              backgroundColor: Colors.white,
              elevation: 0.0,
            ),
          ),

          /* Dark theme settings */
          darkTheme: ThemeData(
            primarySwatch: AppColors.getMaterialColorFromColor(
                Color.fromRGBO(27, 28, 34, 1)), //appbar back color
            primaryColor: Colors.white, //border and back color
            brightness: Brightness.dark, //жалпв барлыгына тема,
            // dividerColor: Color.fromRGBO(39, 40, 46, 1),
            scaffoldBackgroundColor: Color.fromRGBO(39, 40, 46, 1),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.primaryColors[0],
              selectionColor: Colors.grey[500],
              selectionHandleColor: Colors.grey,
            ),

            cardTheme: provider.selectedThemeMode == ThemeMode.dark
                ? CardTheme(color: Color.fromRGBO(27, 28, 34, 1))
                : CardTheme(),

            // inputDecorationTheme: InputDecorationTheme(
            //   fillColor: Colors.white,
            //   hintStyle: TextStyle(color: Theme.of(context).hintColor),
            //   labelStyle: TextStyle(color: Theme.of(context).hintColor),
            //   border: OutlineInputBorder(
            //       borderSide:
            //           BorderSide(color: Color.fromRGBO(228, 232, 250, 1))),
            //   focusedBorder: OutlineInputBorder(
            //     borderSide: BorderSide(color: Colors.grey),
            //   ),
            // ),

            // // для всех кнопок
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.primaryColors[0]),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),

            appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              backgroundColor: Color.fromRGBO(27, 28, 34, 1),
              elevation: 0.0,
            ),
          ),

          locale: provider.locale,
          supportedLocales: L10n.all,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          routes: mainNavigation.routes,
          initialRoute: mainNavigation.initialRoute(model.isAuth),
        );
      },
    );
  }
}

class AppColors {
  static List<Color> primaryColors = [
    Color.fromRGBO(31, 39, 75, 1),
    Color.fromRGBO(247, 247, 247, 1),
    Color.fromRGBO(80, 155, 213, 1),
    Color.fromRGBO(143, 147, 165, 1),
    Color(0xffd23156),
    Color(0xff16b9fd),
    Color(0xff13d0c1),
    Color(0xffe5672f),
    Color(0xffb73d99),
  ];

  static Color getShade(Color color, {bool darker = false, double value = .1}) {
    assert(value >= 0 && value <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness(
        (darker ? (hsl.lightness - value) : (hsl.lightness + value))
            .clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static MaterialColor getMaterialColorFromColor(Color color) {
    Map<int, Color> _colorShades = {
      50: getShade(color, value: 0.5),
      100: getShade(color, value: 0.4),
      200: getShade(color, value: 0.3),
      300: getShade(color, value: 0.2),
      400: getShade(color, value: 0.1),
      500: color,
      600: getShade(color, value: 0.1, darker: true),
      700: getShade(color, value: 0.15, darker: true),
      800: getShade(color, value: 0.2, darker: true),
      900: getShade(color, value: 0.25, darker: true),
    };
    return MaterialColor(color.value, _colorShades);
  }
}

class AppTheme {
  ThemeMode mode;
  String title;
  IconData icon;

  AppTheme({
    required this.mode,
    required this.title,
    required this.icon,
  });
}

List<AppTheme> appThemes = [
  AppTheme(
    mode: ThemeMode.light,
    title: 'Light',
    icon: Icons.brightness_5_rounded,
  ),
  AppTheme(
    mode: ThemeMode.dark,
    title: 'Dark',
    icon: Icons.brightness_2_rounded,
  ),
  AppTheme(
    mode: ThemeMode.system,
    title: 'Auto',
    icon: Icons.brightness_4_rounded,
  ),
];
