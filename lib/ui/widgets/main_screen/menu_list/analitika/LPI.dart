import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/flagCode.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'vseVidy.dart';

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class LpiPage extends StatefulWidget {
  const LpiPage({Key? key}) : super(key: key);

  @override
  State<LpiPage> createState() => _LpiPageState();
}

class _LpiPageState extends State<LpiPage> {
  bool LpiTable = false;
  List LPIData = [];

  List CountryCodeslist = [];
  bool CountryCodeslistload = true;
  bool CountryCodeslistError = false;

  List<String> countryData = [];
  List<String> countryDataCodes = [];

  var selectYear = '';
  var countryList = [''];
  final pm = ProfileModel();

  @override
  void initState() {
    LpiTable = false;

    CountryCodeslist = [];
    CountryCodeslistload = true;
    CountryCodeslistError = false;

    selectYear = '';
    countryList = [];

    countryData = [];
    countryDataCodes = [];

    pm.setupLocale(context).then(
      (value) {
        CountryCodes(
          token: pm.token.toString(),
        ).getList().then(
          (value) {
            // print('Response: $value');

            if (value.toString() == '401') {
              final provider = SessionDataProvider();
              provider.setSessionId(null);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MainNavigationRouteNames.changeLang,
                  (Route<dynamic> route) => false);
            }

            if (value != 'error') {
              var docs = json.decode(value);
              CountryCodeslist = docs;
              CountryCodeslistload = false;
              CountryCodeslistError = false;
            } else {
              CountryCodeslistload = false;
              CountryCodeslistError = true;
              print('Не удалось получить список CountryCodes');
            }
            setState(() {});
          },
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.lpi),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: CountryCodeslistload && !CountryCodeslistError
              ? LoadingData(context)
              : !CountryCodeslistload && CountryCodeslistError
                  ? ErorLoadingData(context)
                  : LPIWidget(),
        ),
      ),
    );
  }

  Column LPIWidget() {
    var yearDate = [
      "2007",
      "2010",
      "2012",
      "2014",
      "2016",
      "2018",
    ];

    if (CountryCodeslist.length > 0) {
      countryList.clear();
      CountryCodeslist.forEach(
        (element) {
          countryList.add(element['countryName']);
        },
      );
    }

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
        Text(
          AppLocalizations.of(context)!.indexEffekLogost,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 24.0),

        Text(AppLocalizations.of(context)!.god, style: textStyle),
        SizedBox(height: 8),

        //Тип транспорта
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
                      BorderSide(color: Color.fromRGBO(228, 232, 250, 1)))),
          dropDownButton: Image.asset("images/Vector30.png", height: 8),
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          showSelectedItem: true,
          items: yearDate,
          selectedItem: AppLocalizations.of(context)!.select,
          onChanged: (newValue) {
            setState(() {
              selectYear = newValue!;
            });
          },
        ),
        SizedBox(height: 20.0),
        Text(AppLocalizations.of(context)!.strana, style: textStyle),
        SizedBox(height: 8),

        Wrap(
          spacing: 2.0, // gap between adjacent chips
          runSpacing: 2.0, // gap between lines
          direction: Axis.horizontal, // main axis (rows or columns)
          children: <Widget>[
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
              items: countryList,
              selectedItem: AppLocalizations.of(context)!.select,
              onChanged: (newValue) {
                setState(() {
                  if (!countryData.contains(newValue))
                    countryData.add(newValue!);
                });
              },
            ),
            ...countryData.map(
              (val) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: () {
                    setState(() {
                      countryData.remove(val);
                    });
                  },
                  child: Text(val),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 10),

        ElevatedButton(
          onPressed: () {
            if (countryData.length > 0 && selectYear != '') {
              print(countryData);

              CountryCodeslist.forEach(
                (element) {
                  if (countryData.contains(element['countryName'].toString())) {
                    countryDataCodes.add(element['countryCode'].toString());
                  }
                },
              );
              countryDataCodes = countryDataCodes.toSet().toList();

              if (countryDataCodes.length > 0) {
                List<Map<String, Object>> countryDataCodesList = [];

                for (var item in countryDataCodes) {
                  Map<String, Object> country = {
                    "CountryCode": item,
                  };
                  countryDataCodesList.add(country);
                }

                Map<String, Object> sendData = {
                  "year": int.parse(selectYear),
                  "codes": countryDataCodesList,
                };

                countryDataCodes.clear();

                GetLPIData(
                  token: pm.token.toString(),
                  jsonMap: sendData,
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

                      setState(() {
                        LPIData = docs;
                        LpiTable = true;
                      });
                    } else {
                      print('Не удалось получить GetLPIData');
                    }
                  },
                );
              }
            }
          },
          child: Text(AppLocalizations.of(context)!.pokazatStat),
        ),
        !LpiTable
            ? SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32),
                  Text(
                    'LPI за ${selectYear} год',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Container(
                    color: provider.selectedThemeMode == ThemeMode.dark
                        ? Color.fromRGBO(53, 54, 61, 1)
                        : Colors.white,
                    // height: 130,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: <DataColumn>[
                          DataColumn(label: Text('Country')),
                          DataColumn(label: Text('flag')),
                          DataColumn(label: Text('overall \nLPI score')),
                          DataColumn(label: Text('overall \nLPI rank')),
                          DataColumn(label: Text('Customs')),
                          DataColumn(label: Text('Infrastructure')),
                          DataColumn(label: Text('International \nshipments')),
                          DataColumn(
                              label:
                                  Text('Logistics quality \nand competence')),
                          DataColumn(label: Text('Tracking and \ntracing')),
                        ],
                        rows: <DataRow>[
                          ...LPIData.map(
                            (val) {
                              var temp = flag
                                  .where(
                                    (element) =>
                                        element['name'] ==
                                        val['countryName'].toString(),
                                  )
                                  .toList();

                              var ty = '';

                              if (temp.length > 0) {
                                ty = temp[0]['emoji'].toString();
                              }

                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(val['countryName'].toString())),
                                  DataCell(Text(
                                    ty,
                                    style: TextStyle(fontSize: 30),
                                  )),
                                  DataCell(Text(val['RankVal1'].toString())),
                                  DataCell(Text(val['RankVal2'].toString())),
                                  DataCell(Text(val['RankVal3'].toString())),
                                  DataCell(Text(val['RankVal4'].toString())),
                                  DataCell(Text(val['RankVal5'].toString())),
                                  DataCell(Text(val['RankVal6'].toString())),
                                  DataCell(Text(val['RankVal7'].toString())),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
