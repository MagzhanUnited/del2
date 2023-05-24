import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('kk'),
    const Locale('ru'),
    const Locale('en'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'kk':
        return '🇰🇿 Қазақша';

      case 'ru':
        return '🇷🇺 Русский';

      case 'en':

      default:
        return '🇺🇸 English';
    }
  }
}
