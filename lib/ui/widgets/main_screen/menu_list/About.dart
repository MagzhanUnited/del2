import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class AbouteView extends StatefulWidget {
  AbouteView({Key? key}) : super(key: key);

  @override
  _AbouteViewState createState() => _AbouteViewState();
}

var tema = TextEditingController();
var desc = TextEditingController();

var thanky = '';

class _AbouteViewState extends State<AbouteView> {
  @override
  void initState() {
    thanky = '';
    tema.text = '';
    desc.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    final textStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      letterSpacing: 0.3,
      // color: AppColors.primaryColors[0],
    );

    var inputDecoration = InputDecoration(
      contentPadding: EdgeInsets.only(left: 8),
      // isDense: true,
      fillColor: provider.selectedThemeMode == ThemeMode.dark
          ? Color.fromRGBO(53, 54, 61, 1)
          : Colors.white,
      filled: true,
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(228, 232, 250, 1))),
    );

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.pomosh)),
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
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.tema, style: textStyle),
                SizedBox(height: 8),
                Container(
                  child: TextField(
                    controller: tema,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    minLines: 1,
                    maxLines: 3,
                    decoration: inputDecoration,
                  ),
                ),
                SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.coobshenie,
                    style: textStyle),
                SizedBox(height: 8),
                Container(
                  child: TextField(
                    controller: desc,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    minLines: 7,
                    maxLines: 7,
                    decoration: inputDecoration,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  thanky,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        tema.text = '';
                        desc.text = '';
                        thanky =
                            AppLocalizations.of(context)!.vasheSoosbPrinato;
                      });

                      Timer(Duration(seconds: 3), () {
                        setState(() {
                          thanky = '';
                        });
                      });
                    },
                    icon: Image.asset("images/11check.png",
                        width: 16, height: 16, color: Colors.white),
                    label: Text(AppLocalizations.of(context)!.otpravit)),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
