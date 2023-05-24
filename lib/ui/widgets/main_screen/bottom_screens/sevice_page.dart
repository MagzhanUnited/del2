import 'package:flutter/material.dart';
import 'package:themoviedb/ui/widgets/main_screen/service_list/Booking_granisa_page.dart';
import 'package:themoviedb/ui/widgets/main_screen/service_list/Dozvol_page.dart';
import 'package:themoviedb/ui/widgets/main_screen/service_list/Payment_road_page.dart';
import 'package:themoviedb/ui/widgets/main_screen/service_list/dangertrue.dart';
import 'package:themoviedb/ui/widgets/main_screen/service_list/epl.dart';
import 'package:themoviedb/ui/widgets/main_screen/service_list/ettn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'menu_page.dart';

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class ServiceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: MenuView()),
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.services)),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: 24, right: 16, left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    newMethod(
                      context,
                      "images/0Service1.png",
                      AppLocalizations.of(context)!.platnueDorogi,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentRoadView()),
                        );
                      },
                    ),
                    SizedBox(width: 8),
                    newMethod(
                      context,
                      "images/0Service2.png",
                      AppLocalizations.of(context)!.dozvol,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DozvolView()),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    newMethod(
                      context,
                      "images/0Service3.png",
                      AppLocalizations.of(context)!.bronirovaniePP,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingGranisaView()),
                        );
                      },
                    ),
                    SizedBox(width: 8),
                    newMethod(
                      context,
                      "images/0Service4.png",
                      AppLocalizations.of(context)!.eTTN,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Ettn()),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    newMethod(
                      context,
                      "images/0Service5.png",
                      AppLocalizations.of(context)!.ePL,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Epl()),
                        );
                      },
                    ),
                    SizedBox(width: 8),
                    newMethod(
                      context,
                      "images/0Service6.png",
                      AppLocalizations.of(context)!.razrNaOpasGruz,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DanferTrue()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container newMethod(BuildContext context, String IconPath, String Name,
      Null Function() param3) {
    final provider = Provider.of<LocaleProvider>(context);

    return Container(
      child: Expanded(
        child: Material(
          borderRadius: BorderRadius.circular(5),
          color: provider.selectedThemeMode != ThemeMode.dark
              ? Colors.white
              : Color.fromRGBO(27, 28, 34, 1),
          child: InkWell(
            onTap: param3,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(color: Colors.transparent),
              child: Center(
                child: Wrap(
                  direction: Axis.vertical,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Image.asset(
                      IconPath,
                      width: 64,
                      height: 64,
                      color: provider.selectedThemeMode == ThemeMode.dark
                          ? Colors.white
                          : Color.fromRGBO(27, 28, 34, 1),
                    ),
                    SizedBox(height: 25),
                    Text(
                      Name,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        // color: AppColors.primaryColors[0],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
