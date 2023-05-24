import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderStatus {
  static MaterialColor StatusColor = Colors.blue;

  static String getStatusName(int code, BuildContext context) {
    switch (code) {
      case 0:
        {
          StatusColor = Colors.blue;
          // return 'Создан';
          return AppLocalizations.of(context)!.sozdan;
        }

      case 1:
        {
          StatusColor = Colors.grey;
          // return 'Запрос отправлен';
          return AppLocalizations.of(context)!.zaprosOtpravlen;
        }
      case 3:
      case 4:
        {
          StatusColor = Colors.green;
          // return 'Выполняется';
          return AppLocalizations.of(context)!.vipolnayetca;
        }
      case 5:
        {
          StatusColor = Colors.green;
          return 'Доставлен';
        }
      case 6:
        {
          StatusColor = Colors.green;
          return 'Принял груз';
        }
      case 7:
        {
          StatusColor = Colors.red;
          return 'Не принял груз';
        }
      default:
        StatusColor = Colors.red;
        return 'не определено $code';
    }
  }
}
