import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../domain/data_providers/session_data_provider.dart';
import '../../../../full/ui/register/step3_client_fiz_model.dart';
import '../../../navigation/main_navigation.dart';
import 'profile/profile_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class DataDetail extends StatefulWidget {
  final dynamic Data;

  DataDetail({
    Key? key,
    required this.Data,
  }) : super(key: key);

  @override
  State<DataDetail> createState() => _DataDetailState();
}

final pm = ProfileModel();
String title = '';
List<String> PerevozozkaType = [''];
List TempPerevozozkaType = [];
int pTIndex = 0;
var vT = '';
var pT = '';
bool chart1 = false;

List<_SalesData> data = [];
List<_SalesData> data1 = [];
List<String> yearData = [];
List<String> yearDataStat = [];
List<String> yearDataPredict = [];

DateTime? selectedDate;
DateTime? selectedDatePredict;
DateTime? selectedDateStat;

class _DataDetailState extends State<DataDetail> {
  String pickeddate = '';

  @override
  void initState() {
    setState(() {
      data.clear();
      data1.clear();
      chart1 = false;
      yearData = [];
      yearDataStat = [];
      yearDataPredict = [];

      pm.setupLocale(context);

      title = widget.Data['catName'];
      vT = widget.Data['catName'];

      if (widget.Data.length > 0) {
        pTIndex = widget.Data['childs'][0]['catId'];

        PerevozozkaType.clear();
        for (var item in widget.Data['childs']) {
          PerevozozkaType.add(item['catName']);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      letterSpacing: 0.3,
      // color: AppColors.primaryColors[0],
    );
    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          maxLines: 3,
          // style: TextStyle(fontSize: 14),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.vyberiteType, style: textStyle),
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
                            borderSide: BorderSide(
                                color: Color.fromRGBO(228, 232, 250, 1))),
                      ),
                      dropDownButton:
                          Image.asset("images/Vector30.png", height: 8),
                      mode: Mode.BOTTOM_SHEET,
                      showSearchBox: true,
                      showSelectedItem: true,
                      items: PerevozozkaType,
                      selectedItem: AppLocalizations.of(context)!.select,
                      onChanged: (newValue) {
                        pT = newValue!;
                        if (widget.Data.length > 0) {
                          var tt = (widget.Data['childs'])
                              .where(
                                  (element) => element['catName'] == newValue)
                              .toList();
                          if (tt.length > 0) {
                            pTIndex = tt[0]['catId'];
                          }
                        }
                      },
                    ),
                    SizedBox(height: 5),
                    Wrap(
                      spacing: 2.0, // gap between adjacent chips
                      runSpacing: 2.0, // gap between lines
                      direction: Axis.horizontal, // main axis (rows or columns)
                      children: <Widget>[
                        ...yearData.map(
                          (val) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  yearData.remove(val);
                                });
                              },
                              child: Text(
                                val,
                                style: TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            DatePicker.showDatePicker(
                              context,
                              currentTime: DateTime.now(),
                              locale: LocaleType.ru,
                              showTitleActions: true,
                              minTime: DateTime(DateTime.now().year - 15, 1),
                              maxTime: DateTime(
                                  DateTime.now().year, DateTime.now().month),
                              onConfirm: (date) {
                                print('confirm $date');
                                setState(
                                  () {
                                    if (!yearData.contains(
                                        '${date.month}.${date.year}')) {
                                      selectedDate = date;
                                      yearData.add(
                                        '${date.month}.${date.year}',
                                      );
                                    }
                                  },
                                );
                              },
                            );

                            // showMonthPicker(
                            //   context: context,
                            //   firstDate: DateTime(DateTime.now().year - 15, 1),
                            //   lastDate: DateTime(
                            //       DateTime.now().year, DateTime.now().month),
                            //   initialDate: selectedDate ?? DateTime.now(),
                            //   locale: Locale("ru"),
                            // ).then((date) {
                            //   if (date != null) {
                            //     setState(() {
                            //       selectedDate = date;
                            //       yearData.add('${date.month}.${date.year}');
                            //     });
                            //   }
                            // });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                          ),
                          icon: Icon(Icons.add),
                          label: Text(AppLocalizations.of(context)!.period),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 2.0, // gap between adjacent chips
                      runSpacing: 2.0, // gap between lines
                      direction: Axis.horizontal, // main axis (rows or columns)
                      children: <Widget>[
                        ...yearDataPredict.map(
                          (val) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  yearDataPredict.remove(val);
                                });
                              },
                              child: Text(
                                val,
                                style: TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            DatePicker.showDatePicker(
                              context,
                              currentTime: DateTime.now(),
                              locale: LocaleType.ru,
                              showTitleActions: true,
                              minTime: DateTime(DateTime.now().year, 1),
                              maxTime: DateTime(DateTime.now().year + 3, 12),
                              onConfirm: (date) {
                                print('confirm $date');
                                setState(
                                  () {
                                    if (!yearDataPredict.contains(
                                        '${date.month}.${date.year}')) {
                                      selectedDatePredict = date;
                                      yearDataPredict.add(
                                        '${date.month}.${date.year}',
                                      );
                                    }
                                  },
                                );
                              },
                            );
                            // showMonthPicker(
                            //   context: context,
                            //   firstDate: DateTime(DateTime.now().year, 1),
                            //   lastDate: DateTime(DateTime.now().year + 3, 12),
                            //   initialDate:
                            //       selectedDatePredict ?? DateTime.now(),
                            //   locale: Locale("ru"),
                            // ).then((date) {
                            //   if (date != null) {
                            //     setState(() {
                            //       selectedDatePredict = date;
                            //       yearDataPredict
                            //           .add('${date.month}.${date.year}');
                            //     });
                            //   }
                            // });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
                          ),
                          icon: Icon(Icons.add),
                          label: Text(AppLocalizations.of(context)!.prognoz),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: () {
                        if (vT != "" && pT != "" && yearData.length > 0) {
                          print(vT);
                          print(pT);
                          print(yearData);

                          List<Map<String, Object>> years = [];
                          for (var item in yearData) {
                            var temp = item.split('.');

                            Map<String, Object> year = {
                              "year": int.parse(temp.last),
                              "month": int.parse(temp.first),
                            };
                            years.add(year);
                          }

                          List<Map<String, Object>> yearsPredict = [];
                          for (var item in yearDataPredict) {
                            var temp = item.split('.');

                            Map<String, Object> year = {
                              "year": int.parse(temp.last),
                              "month": int.parse(temp.first),
                            };
                            yearsPredict.add(year);
                          }

                          Map<String, Object> sendData = {
                            "catId": pTIndex,
                            "years": years,
                            "predictYears": yearsPredict,
                          };

                          GetStatData(
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

                                List<_SalesData> temp = [];
                                List<_SalesData> tempPredict = [];

                                var yearServerData = docs['years'];

                                for (var item in yearServerData) {
                                  int m = item['month'];
                                  int y = item['year'];
                                  String mc = item['monthCount'].toString();

                                  var d =
                                      _SalesData('${m}.${y}', double.parse(mc));
                                  temp.add(d);
                                }

                                var yearServerDataPredict =
                                    docs['predictYears'];

                                for (var item in yearServerDataPredict) {
                                  int m = item['month'];
                                  int y = item['year'];
                                  String mc = item['monthCount'].toString();

                                  var d =
                                      _SalesData('${m}.${y}', double.parse(mc));
                                  tempPredict.add(d);
                                }

                                setState(
                                  () {
                                    // StatGraphData = docs;
                                    chart1 = true;

                                    data.clear();
                                    data = temp;

                                    data1.clear();
                                    data1 = tempPredict;
                                  },
                                );
                              } else {
                                print('Не удалось получить список грузов');
                              }
                            },
                          );
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.pokazatStat),
                    ),

                    SizedBox(height: 16),

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
                                  text: vT + '\n' + pT,
                                  textStyle: TextStyle(fontSize: 12),
                                ),

                                // Enable legend
                                legend: Legend(isVisible: true),
                                // Enable tooltip

                                series: <ChartSeries<_SalesData, String>>[
                                  ColumnSeries<_SalesData, String>(
                                    color: Colors.green,
                                    dataSource: data,
                                    xValueMapper: (_SalesData sales, _) =>
                                        sales.year,
                                    yValueMapper: (_SalesData sales, _) =>
                                        sales.sales,
                                    name: AppLocalizations.of(context)!.period,
                                    dataLabelSettings: DataLabelSettings(
                                      angle: -90,
                                      isVisible: true,
                                      // color: Colors.black54,
                                      textStyle: TextStyle(fontSize: 8),
                                    ),
                                  ),
                                  ColumnSeries<_SalesData, String>(
                                    color: Colors.blue,
                                    dataSource: data1,
                                    xValueMapper: (_SalesData sales, _) =>
                                        sales.year,
                                    yValueMapper: (_SalesData sales, _) =>
                                        sales.sales,
                                    name: AppLocalizations.of(context)!.prognoz,
                                    dataLabelSettings: DataLabelSettings(
                                      angle: -90,
                                      isVisible: true,
                                      // color: Colors.black54,
                                      textStyle: TextStyle(fontSize: 8),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
