import 'package:flutter/material.dart';
import 'package:themoviedb/l10n/l10n.dart';

import '../ui/widgets/app/my_app.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = null as Locale;
    notifyListeners();
  }

  ThemeMode selectedThemeMode = ThemeMode.light;

  void setSelectedThemeMode(ThemeMode _themeMode) {
    selectedThemeMode = _themeMode;
    notifyListeners();
  }

  Color selectedPrimaryColor = AppColors.primaryColors[0];

  void setSelectedPrimaryColor(Color _color) {
    selectedPrimaryColor = _color;
    notifyListeners();
  }
}
