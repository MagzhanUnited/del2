import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:themoviedb/ui/widgets/app/my_app.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/Settings_page.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_page.dart';
import '../menu_list/About.dart';
import '../menu_list/Zakon_WebView.dart';
import '../menu_list/analitika/analitycNewPage.dart';
import 'sevice_page.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class MenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                  child: SizedBox(
                      width: 150,
                      child: Image.asset(
                          provider.selectedThemeMode == ThemeMode.dark
                              ? 'images/logo2.png'
                              : 'images/logo.png'))),
            ),
            SizedBox(height: 60),
            CabinetLine(context),
            // AnalitLine(context),
            // ServicesLine(context),
            ZakonLine(context),
            SettingsLine(context),
            HelpLine(context),
          ],
        ),
      ),
    );
  }

  SizedBox CabinetLine(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return SizedBox(
      height: 70.0,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileView()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Image.asset(
                  "images/contact.png",
                  height: 24,
                  color: provider.selectedThemeMode == ThemeMode.dark
                      ? Colors.white
                      : AppColors.primaryColors[0],
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  AppLocalizations.of(context)!.cabinet,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.chevron_right, size: 25.0),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox AnalitLine(BuildContext context) {
    return SizedBox(
      height: 70.0,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AnaliticList()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child:
                    Icon(Icons.analytics_rounded, size: 35, color: Colors.red),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  AppLocalizations.of(context)!.analityc,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.chevron_right, size: 25.0),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox ServicesLine(BuildContext context) {
    return SizedBox(
      height: 70.0,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ServiceView()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.home_repair_service_sharp,
                  color: Colors.green,
                  size: 35,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  AppLocalizations.of(context)!.services,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.chevron_right, size: 25.0),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox ZakonLine(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return SizedBox(
      height: 70.0,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ZakonWebView()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Icon(
                  Icons.document_scanner_outlined,
                  color: provider.selectedThemeMode == ThemeMode.dark
                      ? Colors.white
                      : AppColors.primaryColors[0],
                  size: 24,
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  AppLocalizations.of(context)!.zakon,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.chevron_right, size: 25.0),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox SettingsLine(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return SizedBox(
      height: 70.0,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsView()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Icon(
                  Icons.settings_outlined,
                  color: provider.selectedThemeMode == ThemeMode.dark
                      ? Colors.white
                      : AppColors.primaryColors[0],
                  size: 24,
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  AppLocalizations.of(context)!.settingskey,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.chevron_right, size: 25.0),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox HelpLine(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return SizedBox(
      height: 70.0,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AbouteView()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Icon(
                  Icons.info_outline_rounded,
                  color: provider.selectedThemeMode == ThemeMode.dark
                      ? Colors.white
                      : AppColors.primaryColors[0],
                  size: 24,
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  AppLocalizations.of(context)!.help,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.chevron_right, size: 25.0),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  // void stateButton() async {
  //   setState(() {
  //     _image = File(selected.path);

  //     pathImg.text = selected.path;

  //     final bytes = File(selected.path).readAsBytesSync();
  //     base64img.text = base64Encode(bytes);
  //   });

  // }
}
