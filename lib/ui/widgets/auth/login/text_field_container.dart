import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final provider = Provider.of<LocaleProvider>(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: size.width * 1,
      decoration: BoxDecoration(
        // color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: provider.selectedThemeMode == ThemeMode.dark
              ? Colors.white
              : Color.fromRGBO(27, 28, 34, 1),
          width: 0.5,
        ), //bo
      ),
      child: child,
    );
  }
}
