import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/order/lug_location_page%20copy.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:themoviedb/ui/widgets/main_screen/bottom_screens/forum/forum_page.dart';
import 'flagCode.dart';
import 'profile/profile_model.dart';
import 'stat1.dart';

class AnalyticsView1 extends StatefulWidget {
  @override
  _AnalyticsView1State createState() => _AnalyticsView1State();
}

class _AnalyticsView1State extends State<AnalyticsView1> {
  SliverAppBar showSliverAppBar(String screenTitle) {
    return SliverAppBar(
      snap: false,
      floating: true, // скрыть тайтл
      pinned: true, // скрыть боттоны
      title: Text(screenTitle),
      bottom: TabBar(
        isScrollable: true,
        labelColor: Theme.of(context).primaryColorLight,
        unselectedLabelColor: Colors.white,
        tabs: [
          Tab(text: 'Все виды \nтранспорта'),
          Tab(text: 'LPI'),
          Tab(text: 'Статистика \nприложения'),
          Tab(text: 'Статистика \nпортов'),
          Tab(text: 'Дозволы'),
          Tab(text: 'Транзит'),
        ],
      ),
    );
  }

  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Feb1', 281),
    _SalesData('Feb2', 218),
    _SalesData('Feb3', 248),
    _SalesData('Feb4', 278),
    _SalesData('Feb5', 28),
    _SalesData('Feb32', 218),
  ];
  List<_SalesData> data1 = [
    _SalesData('1.2023', 3500000),
    _SalesData('1.2025', 2800000),
  ];

  final List<PersonController> personControllers = [];
  DateTime? selectedDate;
  DateTime? selectedDatePredict;
  DateTime? selectedDateStat;
  List<String> yearData = [];
  List<String> yearDataStat = [];
  List<String> yearDataPredict = [];
  List<String> countryData = [];
  List<String> countryDataCodes = [];

  var selectYear = '';

  var countryList = [
    "",
  ];

  var vT = '';
  var pT = '';
  var pTIndex = -1;
  bool chart1 = false;
  bool LpiTable = false;

  final pm = ProfileModel();
  dynamic StatKzRepCatslist = [];
  bool StatKzRepCatslistload = true;
  bool StatKzRepCatslistError = true;

  List CountryCodeslist = [];
  bool CountryCodeslistload = true;
  bool CountryCodeslistError = true;

  List<String> PerevozozkaType = [''];
  List TempPerevozozkaType = [];

  List StatGraphData = [];
  List LPIData = [];

  @override
  void initState() {
    super.initState();
    personControllers.add(PersonController(TextEditingController(),
        TextEditingController(), TextEditingController()));
    chart1 = false;
    LpiTable = false;

    pm.setupLocale(context).then(
      (value) {
        StatKzRepCats(
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
              setState(() {
                StatKzRepCatslist = docs;
                StatKzRepCatslistload = false;
              });
            } else {
              StatKzRepCatslistError = false;
              print('Не удалось получить список StatKzRepCats');
            }
          },
        );

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
              setState(() {
                CountryCodeslist = docs;
                CountryCodeslistload = false;
              });
            } else {
              CountryCodeslistError = false;
              print('Не удалось получить список CountryCodes');
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: 6,
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          StatKz(),
          LPI(),
          AppStat(),
          AppStat1(),
          AppStat1(),
          AppStat1(),
        ],
      ),
    ));
  }

  Stack LoadingData() {
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

  Stack ErorLoadingData() {
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

  CustomScrollView AppStat() {
    return CustomScrollView(
      slivers: [
        showSliverAppBar('Аналитика'),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  AppStatWidget(),
                  Divider(
                    color: Colors.black,
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LugLocationView2(),
                        ),
                      );
                    },
                    child: Text('map'),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }

  CustomScrollView AppStat1() {
    return CustomScrollView(
      slivers: [
        showSliverAppBar('Аналитика'),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[],
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Column AppStatWidget() {
    var Directions = [
      "Алматы - Костанай",
      "Алматы - Нур-Султан",
      "Атырау - Алматы",
      "Актау - Атырау",
    ];

    return Column(
      children: [
        Text(
          'Статистика приложения',
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15.0),
        DropdownSearch<String>(
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          showSelectedItem: true,
          items: Directions,
          label: "Направление",
          selectedItem: "выбрать",
          // onChanged: (newValue) {
          //   pT = newValue!;
          // },
        ),
        SizedBox(height: 5),
        Wrap(
          spacing: 2.0, // gap between adjacent chips
          runSpacing: 2.0, // gap between lines
          direction: Axis.horizontal, // main axis (rows or columns)
          children: <Widget>[
            ...yearDataStat.map(
              (val) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: () {
                    setState(() {
                      yearDataStat.remove(val);
                    });
                  },
                  child: Text(val),
                );
              },
            ),
            ElevatedButton.icon(
              onPressed: () {
                showMonthPicker(
                  context: context,
                  firstDate: DateTime(DateTime.now().year - 15, 1),
                  lastDate: DateTime(DateTime.now().year + 5, 1),
                  initialDate: selectedDateStat ?? DateTime.now(),
                  locale: Locale("ru"),
                ).then((date) {
                  if (date != null) {
                    setState(() {
                      selectedDateStat = date;
                      yearDataStat.add('${date.month}.${date.year}');
                    });
                  }
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              icon: Icon(Icons.add),
              label: Text("Период"),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            if (vT != "" && pT != "" && yearDataStat.length > 0) {
              print(vT);
              print(pT);
              print(yearDataStat);
              setState(() {
                chart1 = true;
              });
            }
          },
          child: Text('Показать статистику'),
        ),
      ],
    );
  }

  CustomScrollView LPI() {
    return CustomScrollView(
      slivers: [
        showSliverAppBar('Аналитика'),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  LPIWidget(),
                  Divider(
                    color: Colors.black,
                    height: 20,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ],
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

    return Column(
      children: [
        Text(
          'Индекс эффективности логистики (LPI)',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.0),

        //Тип транспорта
        DropdownSearch<String>(
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          showSelectedItem: true,
          items: yearDate,
          label: "Год",
          selectedItem: "выбрать",
          onChanged: (newValue) {
            setState(() {
              selectYear = newValue!;
            });
          },
        ),
        SizedBox(height: 10.0),
        //Тип транспорта

        SizedBox(height: 5),

        Wrap(
          spacing: 2.0, // gap between adjacent chips
          runSpacing: 2.0, // gap between lines
          direction: Axis.horizontal, // main axis (rows or columns)
          children: <Widget>[
            DropdownSearch<String>(
              mode: Mode.BOTTOM_SHEET,
              showSearchBox: true,
              showSelectedItem: true,
              items: countryList,
              label: "Страна",
              selectedItem: "выбрать",
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
          child: Text('Показать статистику'),
        ),
        !LpiTable
            ? SizedBox()
            : Center(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Divider(color: Colors.red),
                    Text(
                      'Индекс эффективности логистики (LPI) за ${selectYear} год',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(color: Colors.red),
                    Container(
                      color: Colors.white,
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
                            DataColumn(
                                label: Text('International \nshipments')),
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
                                    DataCell(
                                        Text(val['countryName'].toString())),
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
              ),
      ],
    );
  }

  CustomScrollView StatKz() {
    // var ExportType = [
    //   "Export",
    //   "Import",
    // ];
    // var Directions = [
    //   "Алматы - Нур-Султан",
    //   "Актау - Атырау",
    // ];
    // var TranzitType = [
    //   "TranzitType1",
    //   "TranzitType2",
    // ];

    return CustomScrollView(
      slivers: [
        showSliverAppBar('Аналитика'),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: EdgeInsets.all(8.0),
              child: StatKzRepCatslistload && StatKzRepCatslistError
                  ? LoadingData()
                  : StatKzRepCatslistload && !StatKzRepCatslistError
                      ? ErorLoadingData()
                      : Column(
                          children: <Widget>[
                            StatWidget(),
                            // Divider(
                            //   color: Colors.black,
                            //   height: 20,
                            // ),
                            // ExportImportWidget(ExportType),
                            // Divider(
                            //   color: Colors.black,
                            //   height: 20,
                            // ),
                            // TranzitWidget(Directions, TranzitType),
                          ],
                        ),
            ),
          ]),
        ),
      ],
    );
  }

  Column StatWidget() {
    List<String> vehicleType = [];

    for (var item in StatKzRepCatslist['currentYear']['cats']) {
      vehicleType.add(item['catName']);
    }

    return Column(
      children: [
        Text(
          'Статистика транспорта Казахстана \n(перевезено грузов и багажа)',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15.0),
        Column(
          children: [
            ...StatKzRepCatslist['currentYear']['cats'].asMap().entries.map(
              (entry) {
                var year = StatKzRepCatslist['currentYear']['yearVal'];
                var prevYear = StatKzRepCatslist['prevYear']['yearVal'];

                double yearValue = StatKzRepCatslist['currentYear']['cats']
                    [entry.key]['monthCount'];
                double prevYearValue = StatKzRepCatslist['prevYear']['cats']
                    [entry.key]['monthCount'];

                double procent =
                    (yearValue - prevYearValue) / prevYearValue * 100;
                bool grapsStatus = true;

                if (procent < 0) grapsStatus = false;

                return SizedBox(
                  height: 60.0,
                  child: Card(
                    color: Color.fromARGB(255, 50, 85, 102),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DataDetail(
                                    Data: entry.value,
                                  )),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.car_repair,
                              size: 18.0,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              entry.value['catName'],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),

                          Expanded(
                            flex: 1,
                            child: Text(
                              prevYear.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${(grapsStatus ? "+" : "-")}${procent.abs().toStringAsFixed(procent.abs() >= 10 ? 2 : 3)}%',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color:
                                        grapsStatus ? Colors.green : Colors.red,
                                  ),
                                ),
                                grapsStatus
                                    ? Icon(
                                        Icons.trending_up,
                                        color: Colors.green,
                                      )
                                    : Icon(
                                        Icons.trending_down,
                                        color: Colors.red,
                                      ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              year.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                // return ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.green,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(50),
                //     ),
                //   ),
                //   onPressed: () {},
                //   child: Text(
                //     val['catName'],
                //     style: TextStyle(fontSize: 10),
                //   ),
                // );
              },
            ),
          ],
        ),
      ],
    );
  }

  Column ExportImportWidget(List<String> ExportType) {
    return Column(
      children: [
        Text(
          'Экспорт и импорт',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15.0),
        DropdownSearch<String>(
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          showSelectedItem: true,
          items: ExportType,
          label: "Тип",
          selectedItem: "выбрать",
          // onChanged: (newValue) {
          //   vT = newValue!;
          // },
        ),
        ElevatedButton(
          onPressed: () {
            // if (vT != "" && pT != "" && yearData.length > 0) {
            //   print(vT);
            //   print(pT);
            //   print(yearData);
            //   setState(() {
            //     chart1 = true;
            //   });
            // }
          },
          child: Text('Показать данные'),
        ),
      ],
    );
  }

  Column TranzitWidget(List<String> Directions, List<String> TranzitType) {
    return Column(
      children: [
        Text(
          'Транзит',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15.0),
        DropdownSearch<String>(
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          showSelectedItem: true,
          items: Directions,
          label: "Направление",
          selectedItem: "выбрать",
          // onChanged: (newValue) {
          //   vT = newValue!;
          // },
        ),
        SizedBox(height: 10.0),
        //Тип транспорта
        DropdownSearch<String>(
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          showSelectedItem: true,
          items: TranzitType,
          label: "Вид",
          selectedItem: "выбрать",
          // onChanged: (newValue) {
          //   pT = newValue!;
          // },
        ),
        ElevatedButton(
          onPressed: () {
            // if (vT != "" && pT != "" && yearData.length > 0) {
            //   print(vT);
            //   print(pT);
            //   print(yearData);
            //   setState(() {
            //     chart1 = true;
            //   });
            // }
          },
          child: Text('Показать данные'),
        ),
      ],
    );
  }

  Widget buildCard(PersonController controllers) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.only(top: 2.0, left: 6.0, right: 6.0, bottom: 2.0),
        child: Column(
          children: <Widget>[
            Text('Person 1'),
            SizedBox(height: 3.0),
            // _buildNameField(controllers.name),
            // SizedBox(height: 10.0),
            // _buildAgeField(controllers.age),
            // SizedBox(height: 10.0),
            // _buildJobField(controllers.job),
            // SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}

class PersonController {
  final TextEditingController name;
  final TextEditingController age;
  final TextEditingController job;

  PersonController(this.name, this.age, this.job);
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
