import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/ui/widgets/language_picker_widget.dart';

import '../../../../providers/locale_provider.dart';
import '../../app/my_app.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settingskey),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.checklanguage,
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              LanguagePickerWidget(),
              SizedBox(height: 30),
              Text(
                'Выберите тему',
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ThemeSwitcher(),
              // Text(
              //   'Выберите цвет',
              //   style: TextStyle(
              //     fontSize: 16,
              //     // fontWeight: FontWeight.bold,
              //   ),
              // ),
              // SizedBox(height: 10),
              // PrimaryColorSwitcher()
            ],
          ),
        ));
  }
}

void showLoadingIndicator(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        // backgroundColor: Colors.black54,
        children: <Widget>[
          Center(
            child: Column(
              children: [
                CircularProgressIndicator(
                  // color: Colors.white,
                  strokeWidth: 1,
                ),
                SizedBox(height: 5),
                Text(
                  "Загрузка ....",
                  style: TextStyle(
                      // color: Colors.white,
                      ),
                )
              ],
            ),
          )
        ],
      );
    },
  );
}

void showErrorIndicator(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        backgroundColor: Colors.black54,
        children: <Widget>[
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 50,
                ),
                SizedBox(height: 5),
                Text(
                  "Не удалось загрузить данные\nповторите позже",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
      );
    },
  );
  Timer(Duration(seconds: 3), () {
    hideOpenDialog(context);
  });
}

void hideOpenDialog(BuildContext context) {
  Navigator.of(context).pop();
}

class ThemeSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _containerWidth = 450.0;
    final provider = Provider.of<LocaleProvider>(context);
    return SizedBox(
      height: (_containerWidth - (17 * 2) - (10 * 2)) / 3,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        crossAxisCount: appThemes.length,
        children: List.generate(
          appThemes.length,
          (i) {
            bool _isSelectedTheme =
                appThemes[i].mode == provider.selectedThemeMode;
            return GestureDetector(
              onTap: _isSelectedTheme
                  ? null
                  : () => provider.setSelectedThemeMode(appThemes[i].mode),
              child: AnimatedContainer(
                height: 100,
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _isSelectedTheme
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 2, color: Theme.of(context).primaryColor),
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).cardColor.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(appThemes[i].icon),
                        Text(
                          appThemes[i].title,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PrimaryColorSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _containerWidth = 450.0;
    final provider = Provider.of<LocaleProvider>(context);
    return SizedBox(
      height: (_containerWidth - (17 * 2) - (10 * 2)) / 3,
      child: GridView.count(
        crossAxisCount: AppColors.primaryColors.length,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 5,
        children: List.generate(
          AppColors.primaryColors.length,
          (i) {
            bool _isSelectedColor =
                AppColors.primaryColors[i] == provider.selectedPrimaryColor;
            return GestureDetector(
              onTap: _isSelectedColor
                  ? null
                  : () => provider
                      .setSelectedPrimaryColor(AppColors.primaryColors[i]),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryColors[i],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isSelectedColor ? 1 : 0,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Theme.of(context).cardColor.withOpacity(0.5),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
