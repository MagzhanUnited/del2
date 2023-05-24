import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/l10n/l10n.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class LanguageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final flag = L10n.getFlag(locale.languageCode);

    return Center(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 72,
        child: Text(
          flag,
          style: TextStyle(fontSize: 80),
        ),
      ),
    );
  }
}

class LanguagePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale1 = Localizations.localeOf(context);

    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale ?? Locale(locale1.languageCode);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: provider.selectedThemeMode == ThemeMode.dark
            ? Color.fromRGBO(53, 54, 61, 1)
            : Colors.white, //background color of dropdown button
        border: Border.all(
          color: Colors.black38,
          width: 1,
        ), //border of dropdown button
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: DropdownButton(
          icon: Icon(
            Icons.keyboard_arrow_down_sharp,
            color: provider.selectedThemeMode != ThemeMode.dark
                ? Color.fromRGBO(53, 54, 61, 1)
                : Colors.white,
          ),
          iconEnabledColor: Colors.black, //Icon color
          style: TextStyle(
            // color: Colors.black, //Font color
            fontSize: 15, //font size on dropdown button
          ),
          dropdownColor: provider.selectedThemeMode == ThemeMode.dark
              ? Color.fromRGBO(53, 54, 61, 1)
              : Colors.white, //dropdown background color
          underline: Container(), //remove underline
          isExpanded: true,
          value: locale,
          items: L10n.all.map(
            (locale) {
              final flag = L10n.getFlag(locale.languageCode);

              return DropdownMenuItem(
                child: Text(
                  flag,
                  style: TextStyle(
                    fontSize: 18,
                    color: provider.selectedThemeMode != ThemeMode.dark
                        ? Color.fromRGBO(53, 54, 61, 1)
                        : Colors.white,
                  ),
                ),
                value: locale,
                onTap: () {
                  final provider =
                      Provider.of<LocaleProvider>(context, listen: false);
                  provider.setLocale(locale);
                },
              );
            },
          ).toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }
}
