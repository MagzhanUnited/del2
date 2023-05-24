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

class Dozvols extends StatefulWidget {
  const Dozvols({Key? key}) : super(key: key);

  @override
  State<Dozvols> createState() => _DozvolsState();
}

class _DozvolsState extends State<Dozvols> {
  final pm = ProfileModel();

  List<String> titles = ["Отечественныe", " Зарубежныe"];
  List<String> Country = [];
  List<String> City = [];
  List<String> years = ["2021"];

  List<int> titlesID = [1, 2];
  List<int> CountryID = [];
  List<int> CityID = [];
  List<int> yearsID = [15];

  int titlesValue = -1;
  int CountryValue = -1;
  int CityValue = -1;
  int yearsValue = -1;

  bool TRData = false;

  bool TRLoad = false;
  bool TRLoadError = false;

  bool chart1 = false;
  List<_SalesData> data = [];

  @override
  void initState() {
    chart1 = false;

    data = [];

    titles = ["Отечественный", " Зарубежный"];
    Country = [];
    City = [];
    years = ["2021"];

    titlesID = [1, 2];
    CountryID = [];
    CityID = [];
    yearsID = [15];

    titlesValue = -1;
    CountryValue = -1;
    CityValue = -1;
    yearsValue = -1;

    TRLoad = true;
    TRLoadError = false;

    pm.setupLocale(context).then(
      (value) async {
        await CountryLoad(
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

              for (var item in docs) {
                Country.add(item['countryNameRu']);
                CountryID.add(item['countryId']);
              }

              print('CountryLoad Sucsess ${docs.length}');
            } else {
              TRLoad = false;
              TRLoadError = true;

              print('CountryLoad Error');
            }
          },
        );

        await CityLoad(
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

              for (var item in docs) {
                City.add(item['cityNameRu']);
                CityID.add(item['cityId']);
              }

              print('CityLoad Sucsess ${docs.length}');
            } else {
              TRLoad = false;
              TRLoadError = true;

              print('CityLoad Error');
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
        title: Text(AppLocalizations.of(context)!.dozvol),
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
          dropDownButton: Image.asset("images/Vector30.png", height: 8),
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          showSelectedItem: true,
          items: titles,
          selectedItem: titlesValue == -1
              ? AppLocalizations.of(context)!.select
              : titles[titlesID.indexOf(titlesValue)],
          onChanged: (newValue) {
            var id = titles.indexOf(newValue!);
            titlesValue = titlesID[id];
            setState(() {});
          },
        ),
        SizedBox(height: 20.0),
        Text(AppLocalizations.of(context)!.strana, style: textStyle),
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
          dropDownButton: Image.asset("images/Vector30.png", height: 8),
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          showSelectedItem: true,
          items: Country,
          selectedItem: CountryValue == -1
              ? AppLocalizations.of(context)!.select
              : Country[CountryID.indexOf(CountryValue)],
          onChanged: (newValue) {
            var id = Country.indexOf(newValue!);
            CountryValue = CountryID[id];
            setState(() {});
          },
        ),
        titlesValue == 2
            ? SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  Text(AppLocalizations.of(context)!.oblast, style: textStyle),
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
                          borderSide: BorderSide(
                              color: Color.fromRGBO(228, 232, 250, 1))),
                    ),
                    dropDownButton:
                        Image.asset("images/Vector30.png", height: 8),
                    mode: Mode.BOTTOM_SHEET,
                    showSearchBox: true,
                    showSelectedItem: true,
                    items: City,
                    selectedItem: CityValue == -1
                        ? AppLocalizations.of(context)!.select
                        : City[CityID.indexOf(CityValue)],
                    onChanged: (newValue) {
                      var id = City.indexOf(newValue!);
                      CityValue = CityID[id];
                      setState(() {});
                    },
                  ),
                ],
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
          dropDownButton: Image.asset("images/Vector30.png", height: 8),
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          showSelectedItem: true,
          items: years,
          selectedItem: yearsValue == -1
              ? AppLocalizations.of(context)!.select
              : years[yearsID.indexOf(yearsValue)],
          onChanged: (newValue) {
            var id = years.indexOf(newValue!);
            yearsValue = yearsID[id];
            setState(() {});
          },
        ),
        SizedBox(height: 24.0),

        ElevatedButton(
          onPressed: () async {
            if (titlesValue == 1) {
              if (titlesValue > -1 &&
                  CountryValue > -1 &&
                  CityValue > -1 &&
                  yearsValue > -1) {
                Map<String, Object> t = {
                  "countryId": CountryValue,
                  "yearId": yearsValue,
                  "cityId": CityValue
                };

                await KZDozvolDataLoad(
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
                      // data.clear();
                      setState(() {});
                    } else if (value != 'error') {
                      var docs = json.decode(value);

                      print(docs);

                      List<_SalesData> temp = [];

                      for (var item in docs) {
                        temp.add(
                            _SalesData('получено', item['takenCount'] + .0));
                        temp.add(_SalesData('выдано', item['givenCount'] + .0));
                        temp.add(
                            _SalesData('возврат', item['givenBackCount'] + .0));
                        temp.add(_SalesData('остаток', item['leftCount'] + .0));
                      }
                      data = temp;
                      chart1 = true;
                      setState(() {});

                      print('KZDozvolDataLoad Sucsess ${docs.length}');
                    } else {
                      print('KZDozvolDataLoad Error');
                    }
                  },
                );
              }
            } else {
              if (titlesValue > -1 && CountryValue > -1 && yearsValue > -1) {
                Map<String, Object> t = {
                  "countryId": CountryValue,
                  "yearId": yearsValue,
                };

                await otherDozvolDataLoad(
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
                      // data.clear();
                      setState(() {});
                    } else if (value != 'error') {
                      var docs = json.decode(value);

                      print(docs);

                      List<_SalesData> temp = [];

                      for (var item in docs) {
                        temp.add(
                            _SalesData('Итоги', item['generalCount'] + .0));
                        temp.add(_SalesData(
                            'В/из 3-х стран', item['threeCount'] + .0));
                        temp.add(
                            _SalesData('Двухсторонние', item['twoSide'] + .0));
                        temp.add(_SalesData('Транзит', item['transit'] + .0));
                      }

                      data = temp;
                      chart1 = true;
                      setState(() {});

                      print('KZDozvolDataLoad Sucsess ${docs.length}');
                    } else {
                      print('KZDozvolDataLoad Error');
                    }
                  },
                );
              }
            }
          },
          child: Text(AppLocalizations.of(context)!.pokazatDannue),
        ),
        // Text(
        //               'ПТК ${years[yearsID.indexOf(yearsValue)]} год',
        //               style: TextStyle(fontWeight: FontWeight.bold),
        //             ),
        SizedBox(height: 16.0),
        !chart1
            ? SizedBox()
            : titlesValue == 1
                ? Column(
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
                              '${titles[titlesID.indexOf(titlesValue)]} ${years[yearsID.indexOf(yearsValue)]} год \n ${City[CityID.indexOf(CityValue)]}',
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
                            name: Country[CountryID.indexOf(CountryValue)],
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
                  )
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
                              '${titles[titlesID.indexOf(titlesValue)]} ${years[yearsID.indexOf(yearsValue)]} год ',
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
                            name: Country[CountryID.indexOf(CountryValue)],
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
