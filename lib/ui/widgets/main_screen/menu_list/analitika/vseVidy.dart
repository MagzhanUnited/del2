import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/app/my_app.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/stat1.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class VseVidy extends StatefulWidget {
  const VseVidy({Key? key}) : super(key: key);

  @override
  State<VseVidy> createState() => _VseVidyState();
}

final pm = ProfileModel();
dynamic StatKzRepCatslist = [];
bool StatKzRepCatslistload = true;
bool StatKzRepCatslistError = true;

class _VseVidyState extends State<VseVidy> {
  @override
  void initState() {
    StatKzRepCatslist = [];
    StatKzRepCatslistload = true;
    StatKzRepCatslistError = false;

    super.initState();

    pm.setupLocale(context).then(
      (value) {
        StatKzRepCats(token: pm.token.toString()).getList().then(
          (value) {
            if (value.toString() == '401') {
              final provider = SessionDataProvider();
              provider.setSessionId(null);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MainNavigationRouteNames.changeLang,
                  (Route<dynamic> route) => false);
            }

            if (value != 'error') {
              var docs = json.decode(value);
              StatKzRepCatslist = docs;
              StatKzRepCatslistload = false;
              StatKzRepCatslistError = false;
            } else {
              StatKzRepCatslistload = false;
              StatKzRepCatslistError = true;
              print('Не удалось получить список StatKzRepCats');
            }
            setState(() {});
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.vseVidy),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: StatKzRepCatslistload && !StatKzRepCatslistError
            ? LoadingData(context)
            : !StatKzRepCatslistload && StatKzRepCatslistError
                ? ErorLoadingData(context)
                : StatWidget(),
      ),
    );
  }

  Column StatWidget() {
    List<String> vehicleType = [];

    for (var item in StatKzRepCatslist['currentYear']['cats']) {
      vehicleType.add(item['catName']);
    }

    var year = StatKzRepCatslist['currentYear']['yearVal'];
    var prevYear = StatKzRepCatslist['prevYear']['yearVal'];

    int ind = 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.statKaz,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  // color: AppColors.primaryColors[0],
                ),
              ),
              SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.perevezenoGruza,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryColors[3]),
              ),
              SizedBox(height: 24.0),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.transport,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  // color: AppColors.primaryColors[0],
                ),
              ),
              Text(
                '$year - $prevYear',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  // color: AppColors.primaryColors[0],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              ...StatKzRepCatslist['currentYear']['cats'].asMap().entries.map(
                (entry) {
                  double yearValue = StatKzRepCatslist['currentYear']['cats']
                      [entry.key]['monthCount'];
                  double prevYearValue = StatKzRepCatslist['prevYear']['cats']
                      [entry.key]['monthCount'];

                  double procent =
                      (yearValue - prevYearValue) / prevYearValue * 100;
                  bool grapsStatus = true;

                  if (procent < 0) grapsStatus = false;

                  ind++;

                  final provider = Provider.of<LocaleProvider>(context);

                  return SizedBox(
                    height: 70.0,
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DataDetail(Data: entry.value)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Image.asset("images/Anal${ind}.png",
                                  color: provider.selectedThemeMode ==
                                          ThemeMode.dark
                                      ? Colors.white
                                      : Color.fromRGBO(27, 28, 34, 1),
                                  height: 24),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                entry.value['catName'],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.3,
                                  // color: AppColors.primaryColors[0],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  grapsStatus
                                      ? Image.asset("images/VectorUp.png",
                                          height: 13)
                                      : Image.asset("images/VectorDown.png",
                                          height: 13),
                                  SizedBox(width: 8),
                                  Text(
                                    '${(grapsStatus ? "+" : "-")}${procent.abs().toStringAsFixed(procent.abs() >= 10 ? 2 : 3)}%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: grapsStatus
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

Stack LoadingData(BuildContext context) {
  return Stack(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: 100),
              Text(
                AppLocalizations.of(context)!.zagruzkaDannyh,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  // color: Colors.black54,
                ),
              ),
              SizedBox(height: 10),
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ],
          ),
        ],
      )
    ],
  );
}

Stack ErorLoadingData(BuildContext context) {
  return Stack(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: 100),
              Icon(
                Icons.error,
                size: 60,
                color: Colors.red,
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.povtoritePopitku2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  // color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      )
    ],
  );
}
