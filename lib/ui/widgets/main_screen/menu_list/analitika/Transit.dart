import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'vseVidy.dart';

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class Transits extends StatefulWidget {
  const Transits({Key? key}) : super(key: key);

  @override
  State<Transits> createState() => _TransitsState();
}

class _TransitsState extends State<Transits> {
  final pm = ProfileModel();

  List<String> titles = [];
  List<int> titlesId = [];
  List<String> years = [];
  List<int> yearsId = [];

  dynamic dataTransit = [];

  int titId = -1;
  int yerId = -1;

  bool TRData = false;

  bool TRLoad = false;
  bool TRLoadError = false;

  bool chart1 = false;

  List<_SalesData> data = [];

  String metrica = '';

  @override
  void initState() {
    chart1 = false;
    metrica = '';
    data = [];

    titles = [];
    titlesId = [];
    years = [];
    yearsId = [];

    titId = -1;
    yerId = -1;

    TRLoad = true;
    TRLoadError = false;

    pm.setupLocale(context).then(
      (value) async {
        await TrTitleLoad(
          token: pm.token.toString(),
        ).getList().then(
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

              TRLoad = false;
              TRLoadError = false;

              for (var item in docs['titles']) {
                if (item["statisticType"] != 1) continue;

                titles.add(item['titleNameRu']);
                titlesId.add(item['titleId']);
              }

              for (var item in docs['years']) {
                years.add(item['yearVal']);
                yearsId.add(item['yearId']);
              }

              print('TrTitleLoad Sucsess ${docs.length}');
            } else {
              TRLoad = false;
              TRLoadError = true;

              print('TrTitleLoad Error');
            }
          },
        );

        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tranzit),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: TRLoad && !TRLoadError
              ? LoadingData(context)
              : !TRLoad && TRLoadError
                  ? ErorLoadingData(context)
                  : TR(),
        ),
      ),
    );
  }

  Column TR() {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      letterSpacing: 0.3,
      // color: AppColors.primaryColors[0],
    );
    final provider = Provider.of<LocaleProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.vyberiteType, style: textStyle),
        SizedBox(height: 8.0),
        DropdownSearch<String>(
          dropdownSearchDecoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 8),
            isDense: true,
            fillColor: provider.selectedThemeMode == ThemeMode.dark
                ? Color.fromRGBO(53, 54, 61, 1)
                : Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromRGBO(228, 232, 250, 1))),
          ),
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          showSelectedItem: true,
          items: titles,
          selectedItem: titId == -1
              ? AppLocalizations.of(context)!.select
              : titles[titlesId.indexOf(titId)],
          onChanged: (newValue) {
            var id = titles.indexOf(newValue!);
            titId = titlesId[id];
            setState(() {});
          },
        ),
        SizedBox(height: 20.0),
        Text(AppLocalizations.of(context)!.god, style: textStyle),
        SizedBox(height: 8.0),
        DropdownSearch<String>(
          dropdownSearchDecoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 8),
            isDense: true,
            fillColor: provider.selectedThemeMode == ThemeMode.dark
                ? Color.fromRGBO(53, 54, 61, 1)
                : Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromRGBO(228, 232, 250, 1))),
          ),
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          showSelectedItem: true,
          items: years,
          selectedItem: yerId == -1
              ? AppLocalizations.of(context)!.select
              : years[yearsId.indexOf(yerId)],
          onChanged: (newValue) {
            var id = years.indexOf(newValue!);
            yerId = yearsId[id];
            setState(() {});
          },
        ),
        SizedBox(height: 24.0),
        ElevatedButton(
          onPressed: () async {
            if (yerId > -1 && titId > -1) {
              Map<String, Object> t = {
                "titleId": titId,
                "yearId": yerId,
              };

              TrDataLoad(
                token: pm.token.toString(),
                data: t,
              ).getList().then(
                (value) {
                  if (value.toString() == '401') {
                    final provider = SessionDataProvider();
                    provider.setSessionId(null);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        MainNavigationRouteNames.changeLang,
                        (Route<dynamic> route) => false);
                  }

                  if (value.contains('нет данных')) {
                    chart1 = false;
                    data.clear();
                    setState(() {});
                  } else if (value != 'error') {
                    var docs = json.decode(value);
                    dataTransit = docs;

                    print(docs);

                    List<_SalesData> temp = [];

                    for (var item in dataTransit) {
                      var d = _SalesData(
                          item['transitNameRu'], item['transitValue'] + .0);
                      temp.add(d);
                      metrica = item['measureNameRu'];
                    }
                    data = temp;
                    chart1 = true;
                    setState(() {});

                    print('TrDataLoad Sucsess ${docs.length}');
                  } else {
                    print('TrDataLoad Error');
                  }
                },
              );
            }
          },
          child: Text(AppLocalizations.of(context)!.pokazatDannue),
        ),
        SizedBox(height: 16.0),
        !chart1
            ? SizedBox()
            : Column(
                children: [
                  SfCartesianChart(
                    borderWidth: 0.5,
                    plotAreaBorderWidth: 0.5,
                    borderColor: Colors.black,
                    primaryXAxis: CategoryAxis(
                      labelStyle: TextStyle(fontSize: 9),
                      labelIntersectAction: data.length > 3
                          ? AxisLabelIntersectAction.rotate90
                          : AxisLabelIntersectAction.rotate45,
                    ),
                    primaryYAxis: NumericAxis(
                      numberFormat: NumberFormat.compact(),
                      labelStyle: TextStyle(fontSize: 8),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    title: ChartTitle(
                      text:
                          "${titles[titlesId.indexOf(titId)]} за ${years[yearsId.indexOf(yerId)]} год",
                      textStyle: TextStyle(fontSize: 12),
                    ),

                    // Enable legend
                    legend: Legend(isVisible: true),
                    // Enable tooltip

                    series: <ChartSeries<_SalesData, String>>[
                      ColumnSeries<_SalesData, String>(
                        color: Colors.green,
                        dataSource: data,
                        xValueMapper: (_SalesData sales, _) => sales.year,
                        yValueMapper: (_SalesData sales, _) => sales.sales,
                        name: metrica,
                        dataLabelSettings: DataLabelSettings(
                          angle: -90,
                          isVisible: true,
                          // color: Colors.black54,
                          textStyle: TextStyle(fontSize: 8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ],
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
