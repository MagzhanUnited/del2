import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/order/order_datail_comp.dart';
import 'package:themoviedb/full/ui/order/order_datail_indi.dart';
import 'package:themoviedb/full/ui/register/register_step1_page.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/src/place_picker.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/Settings_page.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/my_cars.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../app/my_app.dart';

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class CurrentView extends StatefulWidget {
  CurrentView({
    Key? key,
  }) : super(key: key);

  @override
  _CurrentViewState createState() => _CurrentViewState();
}

List data = [];
List cars = [];
List drivers = [];
bool load = true;
bool loadError = false;
final pm = ProfileModel();

bool _isdanger = false;
bool _isdogruz = false;
var carTypeTxt = '';

List<String> CarTypes = [];
List<int> TypeId = [];

List<String> currency_name = [];
List<String> currency_id = [];
CarTypeDetail? CarTypeDet;

var f = DriverFiltering(
  beginCityName: TextEditingController(),
  endCityName: TextEditingController(),
  beginPrice: TextEditingController(),
  endPrice: TextEditingController(),
  beginDate: TextEditingController(),
  endDate: TextEditingController(),
  isdanger: -1,
  isdogruz: -1,
  carTypeId: 0,
  cur_id: '0',
  orderBy: TextEditingController(text: 'client'),
  orderType: TextEditingController(text: 'desc'),
);

String orderBy = '';
String carT = '';
String money = '';

class _CurrentViewState extends State<CurrentView> {
  void resetElements() {
    orderBy = '';
    carT = '';
    money = '';
  }

  @override
  void initState() {
    orderBy = '';
    carT = '';
    money = '';

    load = true;
    loadError = false;

    _isdanger = false;
    _isdogruz = false;

    currency_name = [];
    currency_id = [];

    super.initState();
    pm.setupLocale(context).then(
      (value) async {
        await CurrencyList(
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
              var temp = json.decode(value);
              for (var item in temp) {
                currency_id.add(item['currencyId'].toString());
                currency_name.add(item['currencyCode'].toString());
              }
              setState(() {});
              print('CurrencyList ${temp.length}');
            } else {
              print('Не удалось получить CurrencyList');
            }
          },
        );

        await GetCarType(
          token: pm.token,
        ).get().then(
          (value) {
            // hideOpenDialog(context);
            // print('Response: $value');

            if (value.toString() == '401') {
              final provider = SessionDataProvider();
              provider.setSessionId(null);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MainNavigationRouteNames.changeLang,
                  (Route<dynamic> route) => false);
            }

            if (value.contains('Error')) {
            } else {
              final parsedJson = jsonDecode(value);
              CarTypeDet = CarTypeDetail.fromJson(parsedJson);

              for (var item in CarTypeDet!.carTypes) {
                CarTypes.add(item.nameRu);
                TypeId.add(item.carTypeId);
              }
            }
          },
        );

        if (pm.sysUserType == "0") {
          GetOrderList(
            token: pm.token.toString(),
            data: f.toJson(),
          ).getGuest().then(
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
                  data = docs;
                  load = false;
                });
              } else {
                print('Не удалось получить список грузов');
              }
            },
          );
        } else {
          GetOrderList(
            token: pm.token.toString(),
            data: f.toJson(),
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
                  data = docs;
                  load = false;
                  loadError = false;
                });
              } else {
                setState(() {
                  load = false;
                  loadError = true;
                });
                print('Не удалось получить список грузов');
              }
            },
          );

          GetCarList(
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
                setState(() {
                  cars = json.decode(value);
                });

                print('GetCars ${cars.length}');
              } else {
                print('Не удалось получить список машин');
              }
            },
          );
          GetDriverList(
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
                setState(() {
                  drivers = json.decode(value);
                });
                print('GetDrivers ${drivers.length}');
              } else {
                print('Не удалось получить список водителей');
              }
            },
          );
        }
      },
    );
  }

  void GetFilter() {
    if (pm.sysUserType == "0") {
      GetOrderList(
        token: pm.token.toString(),
        data: f.toJson(),
      ).getGuest().then(
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
              data = docs;
              load = false;
            });
          } else {
            print('Не удалось получить список грузов');
          }
        },
      );
    } else {
      GetOrderList(
        token: pm.token.toString(),
        data: f.toJson(),
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
              data = docs;
              load = false;
              loadError = false;
            });
          } else {
            setState(() {
              load = false;
              loadError = true;
            });
            print('Не удалось получить список грузов');
          }
        },
      );
    }
  }

  // @override
  // void dispose() {
  //   pm.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.poiskGruza),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // filter(context);
              LugSettings(context);
            },
            icon: Image.asset(
              "images/poisk.gruza.filter.icon.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : Color.fromRGBO(27, 28, 34, 1),
            ),
          ),
          // TextButton(
          //   onPressed: () {
          //     filter(context);
          //   },
          //   child: Image.asset(
          //     "images/poisk.gruza.filter.icon.png",
          //     width: 24,
          //     height: 24,
          //   ),
          // ),
        ],
      ),
      body: load && !loadError
          ? LoadingData()
          : !load && loadError
              ? Text('Error')
              : lugData(),
    );
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
                  // color: Colors.black,
                  strokeWidth: 2,
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Column lugData() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            itemCount: data.length,
            // itemExtent: 199,
            itemBuilder: (BuildContext context, int index) {
              var formatted = DateFormat('dd.MM.yyyy, hh:mm')
                  .format(DateTime.parse(data[index]['tripDate']))
                  .toString();

              final provider = Provider.of<LocaleProvider>(context);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  elevation: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Багасы
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${NumberFormat("#,##0", "pt_BR").format(data[index]['bookerOfferPrice'])} ${data[index]['currencyIcon']}',
                              style: TextStyle(
                                  // color: AppColors.primaryColors[0],
                                  fontSize: 18,
                                  letterSpacing: 0.3,
                                  fontWeight: FontWeight.w800),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                //дата заказа
                                Padding(
                                  padding: EdgeInsets.only(),
                                  child: ButtonTheme(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "images/calendar16.png",
                                          height: 16,
                                          color: provider.selectedThemeMode ==
                                                  ThemeMode.dark
                                              ? Colors.white
                                              : Color.fromRGBO(27, 28, 34, 1),
                                        ),
                                        SizedBox(width: 6.0),
                                        Text(
                                          // filteredData[index].name,
                                          formatted.toString(),
                                          style: TextStyle(
                                              // color: AppColors.primaryColors[0],
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromRGBO(80, 155, 213, 1)
                                .withOpacity(0.1),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Image.asset("images/ZakazAB.png",
                                        height: 70),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .zabrat,
                                            style: TextStyle(
                                                color:
                                                    AppColors.primaryColors[3],
                                                fontSize: 12,
                                                letterSpacing: 0.3,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '${data[index]['beginPointName']}',
                                            style: TextStyle(
                                                // color:
                                                //     AppColors.primaryColors[0],
                                                fontSize: 15,
                                                letterSpacing: 0.3,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .dostavit,
                                            style: TextStyle(
                                                color:
                                                    AppColors.primaryColors[3],
                                                fontSize: 12,
                                                letterSpacing: 0.3,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '${data[index]['endPointName']}',
                                            style: TextStyle(
                                                // color:
                                                //     AppColors.primaryColors[0],
                                                fontSize: 15,
                                                letterSpacing: 0.3,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.comment,
                              style: TextStyle(
                                  color: AppColors.primaryColors[3],
                                  fontSize: 12,
                                  letterSpacing: 0.3,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              data[index]['orderName'],
                              maxLines: 4,
                              style: TextStyle(
                                  // color: AppColors.primaryColors[0],
                                  fontSize: 15,
                                  letterSpacing: 0.3,
                                  height: 1.2,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: () {
                                // _onBasicAlertPressed(context);

                                if (pm.sysUserType == "0") {
                                  _onBasicAlertPressed(context);
                                } else if (pm.sysUserType == "4" &&
                                    drivers.length == 0) {
                                  const snackBar = SnackBar(
                                    content: Text('У вас нет водителей'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else if (pm.sysUserType == "4" &&
                                    cars.length == 0) {
                                  const snackBar = SnackBar(
                                    content: Text('У вас нет машин'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else if (pm.sysUserType == "4") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderDatailView(
                                              jdata: data[index],
                                              myCars: cars,
                                              myDrivers: drivers,
                                            )),
                                  );
                                } else {
                                  //Запрос даннах водителя
                                  showLoadingIndicator(context);
                                  GetSysType(
                                    token: pm.token.toString(),
                                    sysUserType: pm.sysUserType.toString(),
                                  ).getSysType().then(
                                    (value) {
                                      hideOpenDialog(context);
                                      // print('Response: $value');

                                      if (value.toString() == '401') {
                                        final provider = SessionDataProvider();
                                        provider.setSessionId(null);
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                MainNavigationRouteNames
                                                    .changeLang,
                                                (Route<dynamic> route) =>
                                                    false);
                                      }

                                      dynamic result;
                                      try {
                                        result = json.decode(value);
                                      } catch (e) {
                                        print('Get Cabinet error ===> $e');
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OrderDatailIndiView(
                                            jdata: data[index],
                                            UserData: result,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                              child:
                                  Text(AppLocalizations.of(context)!.podrobnoe),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  var sortData = [
    "Сначала свежие объявления",
    "Сначала старые объявления",
    "По убыванию ранга",
    "По возрастанию ранга",
    "По убыванию цены",
    "По возрастанию цены",
  ];
  final textStyle = const TextStyle(
    fontSize: 16,
    color: Color(0xff212529),
  );

  void filter(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          title: Text('Cортировка и фильтрация'),
          content: Container(
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  DropdownSearch<String>(
                    mode: Mode.BOTTOM_SHEET,
                    showSearchBox: true,
                    showSelectedItem: true,
                    items: sortData,
                    label: "Сортировка",
                    selectedItem: sortData.first,
                    onChanged: (newValue) {
                      print(newValue);

                      switch (sortData
                          .indexWhere((element) => element == newValue)) {
                        case 0:
                          setState(() {
                            f.orderBy.text = 'client';
                            f.orderType.text = 'desc';
                          });
                          break;
                        case 1:
                          setState(() {
                            f.orderBy.text = 'client';
                            f.orderType.text = 'asc';
                          });
                          break;
                        case 2:
                          setState(() {
                            f.orderBy.text = 'rank';
                            f.orderType.text = 'desc';
                          });
                          break;
                        case 3:
                          setState(() {
                            f.orderBy.text = 'rank';
                            f.orderType.text = 'asc';
                          });
                          break;
                        case 4:
                          setState(() {
                            f.orderBy.text = 'byPrice';
                            f.orderType.text = 'desc';
                          });
                          break;
                        case 5:
                          setState(() {
                            f.orderBy.text = 'byPrice';
                            f.orderType.text = 'asc';
                          });
                          break;
                        default:
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  TextField(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PlacePicker(
                              apiKey: 'AIzaSyAkUdrVbgXV_52Qrid_vdeqzTbBfmFxrNM',
                              initialPosition: LatLng(-33.8567844, 151.213108),
                              useCurrentLocation: true,
                              selectInitialPosition: true,
                              autocompleteLanguage: "ru",

                              //usePlaceDetailSearch: true,
                              onPlacePicked: (result) {
                                var city = result.addressComponents!
                                    .where((e) => e.types.first == 'locality')
                                    .first
                                    .longName;

                                f.beginCityName.text = city;

                                Navigator.of(context).pop();
                                setState(() {});
                              },
                            );
                          },
                        ),
                      );
                    },
                    controller: f.beginCityName,
                    style: TextStyle(fontSize: 15),
                    enabled: true,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      isDense: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 3, horizontal: 0),
                      labelText: 'Откуда',
                      prefixIcon: SizedBox(
                        child: Center(
                          widthFactor: 0.0,
                          child: Ink(
                            width: 35,
                            decoration: const ShapeDecoration(
                              shape: CircleBorder(
                                  side: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                            child: Center(
                              child: Text("A",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PlacePicker(
                              apiKey: 'AIzaSyAkUdrVbgXV_52Qrid_vdeqzTbBfmFxrNM',
                              initialPosition: LatLng(-33.8567844, 151.213108),
                              useCurrentLocation: true,
                              selectInitialPosition: true,
                              autocompleteLanguage: "ru",

                              //usePlaceDetailSearch: true,
                              onPlacePicked: (result) {
                                var city = result.addressComponents!
                                    .where((e) => e.types.first == 'locality')
                                    .first
                                    .longName;

                                f.endCityName.text = city;

                                Navigator.of(context).pop();
                                setState(() {});
                              },
                            );
                          },
                        ),
                      );
                    },
                    controller: f.endCityName,
                    style: TextStyle(fontSize: 15),
                    enabled: true,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      isDense: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 3, horizontal: 0),
                      labelText: 'Куда',
                      prefixIcon: SizedBox(
                        child: Center(
                          widthFactor: 0.0,
                          child: Ink(
                            width: 35,
                            decoration: const ShapeDecoration(
                              shape: CircleBorder(
                                  side: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                            child: Center(
                              child: Text("Б",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text('Дата', style: textStyle),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: new TextFormField(
                            onTap: () {
                              DatePicker.showDatePicker(
                                context,
                                currentTime: DateTime.now(),
                                locale: LocaleType.ru,
                                showTitleActions: true,
                                minTime: DateTime(
                                  DateTime.now().year - 1,
                                  // DateTime.now().month, DateTime.now().day
                                ),
                                maxTime: DateTime(DateTime.now().year + 1),
                                onConfirm: (date) {
                                  setState(() {
                                    f.beginDate.text =
                                        new DateFormat('yyyy.MM.dd')
                                            .format(date);
                                  });
                                },
                              );
                            },
                            keyboardType: TextInputType.number,
                            controller: f.beginDate,
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: false,
                                contentPadding: EdgeInsets.all(15),
                                labelText: "От"),
                          ),
                        ),
                      ),
                      new Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: new TextFormField(
                            onTap: () {
                              DatePicker.showDatePicker(
                                context,
                                currentTime: DateTime.now(),
                                locale: LocaleType.ru,
                                showTitleActions: true,
                                minTime: DateTime(
                                  DateTime.now().year - 1,
                                  // DateTime.now().month, DateTime.now().day
                                ),
                                maxTime: DateTime(DateTime.now().year + 1),
                                onConfirm: (date) {
                                  setState(() {
                                    f.endDate.text =
                                        new DateFormat('yyyy.MM.dd')
                                            .format(date);
                                  });
                                },
                              );
                            },
                            keyboardType: TextInputType.number,
                            controller: f.endDate,
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(15),
                                labelText: "До"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text('Цена', style: textStyle),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: new TextFormField(
                            keyboardType: TextInputType.number,
                            controller: f.beginPrice,
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: false,
                                contentPadding: EdgeInsets.all(15),
                                labelText: "От"),
                          ),
                        ),
                      ),
                      new Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: new TextFormField(
                            keyboardType: TextInputType.number,
                            controller: f.endPrice,
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(15),
                                labelText: "До"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  DropdownSearch<String>(
                    mode: Mode.BOTTOM_SHEET,
                    showSearchBox: true,
                    showSelectedItem: true,
                    items: currency_name,
                    label: "Валюта",
                    selectedItem: "выбрать",
                    onChanged: (newValue) {
                      f.cur_id = currency_id[currency_name.indexOf(newValue!)];
                      setState(() {});
                    },
                  ),
                  ListTileSwitch(
                    value: _isdanger,
                    leading: const Icon(Icons.dangerous_outlined),
                    onChanged: (value) {
                      setState(() {
                        _isdanger = value;
                        f.isdanger = _isdanger ? 1 : 0;
                      });
                      Navigator.of(context).pop();
                      filter(context);
                    },
                    switchActiveColor: Colors.teal,
                    switchScale: 1,
                    switchType: SwitchType.cupertino,
                    title: const Text(
                      'Опасный груз',
                    ),
                  ),
                  ListTileSwitch(
                    value: _isdogruz,
                    leading: const Icon(Icons.add_road),
                    onChanged: (value) {
                      setState(() {
                        _isdogruz = value;
                        f.isdogruz = _isdogruz ? 1 : 0;
                      });
                      Navigator.of(context).pop();
                      filter(context);
                    },
                    switchActiveColor: Colors.teal,
                    switchScale: 1,
                    // subtitle: const Text(
                    //   'Комментарии',
                    // ),
                    switchType: SwitchType.cupertino,
                    title: const Text(
                      'Догруз',
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownSearch<String>(
                    mode: Mode.BOTTOM_SHEET,
                    showSearchBox: true,
                    showSelectedItem: true,
                    items: CarTypes,
                    label: "Тип кузова",
                    selectedItem: "выбрать",
                    onChanged: (newValue) {
                      print(newValue);

                      var idd =
                          CarTypes.indexWhere((element) => element == newValue);
                      f.carTypeId = TypeId[idd];
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
          elevation: 24,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cбросить',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                f.resetFilter();
                setState(() {});
                GetFilter();
              },
            ),
            TextButton(
              child: Text(
                'Показать',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();

                GetFilter();
              },
            ),
            TextButton(
              child: Text(
                'Отменить',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void LugSettings(BuildContext context) {
    showModalBottomSheet(
      barrierColor: AppColors.primaryColors[0].withOpacity(0.9),
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      builder: (_) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter state) {
          final provider = Provider.of<LocaleProvider>(context);

          var fSt = TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            // color: AppColors.primaryColors[0],
          );
          var fDec = InputDecoration(
            isDense: true,
            fillColor: provider.selectedThemeMode == ThemeMode.dark
                ? Color.fromRGBO(53, 54, 61, 1)
                : Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(228, 232, 250, 1)),
            ),
          );

          return FractionallySizedBox(
            heightFactor: 0.9,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.nastroikiPoiska,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            // color: AppColors.primaryColors[0],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.close))
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.sort,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            // color: AppColors.primaryColors[0],
                          ),
                        ),
                        SizedBox(height: 8),
                        DropdownSearch<String>(
                          dropdownSearchDecoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            isDense: true,
                            fillColor:
                                provider.selectedThemeMode == ThemeMode.dark
                                    ? Color.fromRGBO(53, 54, 61, 1)
                                    : Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(228, 232, 250, 1))),
                          ),
                          dropDownButton: Image.asset(
                            "images/Vector30.png",
                            height: 8,
                          ),
                          mode: Mode.BOTTOM_SHEET,
                          showSearchBox: true,
                          showSelectedItem: true,
                          items: sortData,
                          selectedItem: orderBy,
                          onChanged: (newValue) {
                            print(newValue);
                            orderBy = newValue!;

                            switch (sortData
                                .indexWhere((element) => element == newValue)) {
                              case 0:
                                f.orderBy.text = 'client';
                                f.orderType.text = 'desc';
                                break;
                              case 1:
                                f.orderBy.text = 'client';
                                f.orderType.text = 'asc';
                                break;
                              case 2:
                                f.orderBy.text = 'rank';
                                f.orderType.text = 'desc';
                                break;
                              case 3:
                                f.orderBy.text = 'rank';
                                f.orderType.text = 'asc';
                                break;
                              case 4:
                                f.orderBy.text = 'byPrice';
                                f.orderType.text = 'desc';
                                break;
                              case 5:
                                f.orderBy.text = 'byPrice';
                                f.orderType.text = 'asc';
                                break;
                              default:
                            }
                            state(() {});
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(80, 155, 213, 1).withOpacity(0.1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.from,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              // color: AppColors.primaryColors[0],
                            ),
                          ),
                          SizedBox(height: 8),
                          InkWell(
                            child: TextField(
                              enabled: false,
                              controller: f.beginCityName,
                              style: fSt,
                              decoration: fDec,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return PlacePicker(
                                      apiKey:
                                          'AIzaSyAkUdrVbgXV_52Qrid_vdeqzTbBfmFxrNM',
                                      initialPosition:
                                          LatLng(-33.8567844, 151.213108),
                                      useCurrentLocation: true,
                                      selectInitialPosition: true,
                                      autocompleteLanguage: "ru",

                                      //usePlaceDetailSearch: true,
                                      onPlacePicked: (result) {
                                        var locality = result.addressComponents!
                                            .where((e) =>
                                                e.types.first == 'locality')
                                            .first
                                            .longName;

                                        f.beginCityName.text = locality;

                                        Navigator.of(context).pop();
                                        state(() {});
                                        setState(() {});
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.to,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              // color: AppColors.primaryColors[0],
                            ),
                          ),
                          SizedBox(height: 8),
                          InkWell(
                            child: TextField(
                              enabled: false,
                              controller: f.endCityName,
                              style: fSt,
                              decoration: fDec,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return PlacePicker(
                                      apiKey:
                                          'AIzaSyAkUdrVbgXV_52Qrid_vdeqzTbBfmFxrNM',
                                      initialPosition:
                                          LatLng(-33.8567844, 151.213108),
                                      useCurrentLocation: true,
                                      selectInitialPosition: true,
                                      autocompleteLanguage: "ru",

                                      //usePlaceDetailSearch: true,
                                      onPlacePicked: (result) {
                                        var locality = result.addressComponents!
                                            .where((e) =>
                                                e.types.first == 'locality')
                                            .first
                                            .longName;

                                        f.endCityName.text = locality;

                                        Navigator.of(context).pop();
                                        state(() {});
                                        setState(() {});
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      AppLocalizations.of(context)!.tipKuzova,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        // color: AppColors.primaryColors[0],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: DropdownSearch<String>(
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
                      dropDownButton: Image.asset(
                        "images/Vector30.png",
                        height: 8,
                      ),
                      mode: Mode.BOTTOM_SHEET,
                      showSearchBox: true,
                      showSelectedItem: true,
                      items: CarTypes,
                      selectedItem: carT,
                      onChanged: (newValue) {
                        print(newValue);
                        carT = newValue!;

                        var idd = CarTypes.indexWhere(
                            (element) => element == newValue);
                        f.carTypeId = TypeId[idd];
                        setState(() {});
                        state(() {});
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      AppLocalizations.of(context)!.date,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        // color: AppColors.primaryColors[0],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: new TextFormField(
                              onTap: () {
                                DatePicker.showDatePicker(
                                  context,
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.ru,
                                  showTitleActions: true,
                                  minTime: DateTime(
                                    DateTime.now().year - 1,
                                    // DateTime.now().month, DateTime.now().day
                                  ),
                                  maxTime: DateTime(DateTime.now().year + 1),
                                  onConfirm: (date) {
                                    setState(() {
                                      f.beginDate.text =
                                          new DateFormat('yyyy.MM.dd')
                                              .format(date);
                                    });
                                  },
                                );
                              },
                              keyboardType: TextInputType.number,
                              controller: f.beginDate,
                              style: TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: false,
                                  fillColor: provider.selectedThemeMode ==
                                          ThemeMode.dark
                                      ? Color.fromRGBO(53, 54, 61, 1)
                                      : Colors.white,
                                  contentPadding: EdgeInsets.all(15),
                                  labelText:
                                      AppLocalizations.of(context)!.otTsena),
                            ),
                          ),
                        ),
                        new Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: new TextFormField(
                              onTap: () {
                                DatePicker.showDatePicker(
                                  context,
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.ru,
                                  showTitleActions: true,
                                  minTime: DateTime(
                                    DateTime.now().year - 1,
                                    // DateTime.now().month, DateTime.now().day
                                  ),
                                  maxTime: DateTime(DateTime.now().year + 1),
                                  onConfirm: (date) {
                                    setState(() {
                                      f.endDate.text =
                                          new DateFormat('yyyy.MM.dd')
                                              .format(date);
                                    });
                                  },
                                );
                              },
                              keyboardType: TextInputType.number,
                              controller: f.endDate,
                              style: TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  fillColor: provider.selectedThemeMode ==
                                          ThemeMode.dark
                                      ? Color.fromRGBO(53, 54, 61, 1)
                                      : Colors.white,
                                  contentPadding: EdgeInsets.all(15),
                                  labelText:
                                      AppLocalizations.of(context)!.doTsena),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      AppLocalizations.of(context)!.prise,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        // color: AppColors.primaryColors[0],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: new TextFormField(
                              keyboardType: TextInputType.number,
                              controller: f.beginPrice,
                              style: TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: false,
                                  fillColor: provider.selectedThemeMode ==
                                          ThemeMode.dark
                                      ? Color.fromRGBO(53, 54, 61, 1)
                                      : Colors.white,
                                  contentPadding: EdgeInsets.all(15),
                                  labelText:
                                      AppLocalizations.of(context)!.otTsena),
                            ),
                          ),
                        ),
                        new Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: new TextFormField(
                              keyboardType: TextInputType.number,
                              controller: f.endPrice,
                              style: TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  fillColor: provider.selectedThemeMode ==
                                          ThemeMode.dark
                                      ? Color.fromRGBO(53, 54, 61, 1)
                                      : Colors.white,
                                  contentPadding: EdgeInsets.all(15),
                                  labelText:
                                      AppLocalizations.of(context)!.doTsena),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      AppLocalizations.of(context)!.currency,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        // color: AppColors.primaryColors[0],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: DropdownSearch<String>(
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
                      items: currency_name,
                      selectedItem: money,
                      onChanged: (newValue) {
                        money = newValue!;

                        f.cur_id = currency_id[currency_name.indexOf(newValue)];
                        setState(() {});
                        state(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTileSwitch(
                          value: f.isdanger == -1 ? false : _isdanger,
                          leading: const Icon(Icons.dangerous_outlined),
                          onChanged: (value) {
                            _isdanger = value;
                            f.isdanger = _isdanger ? 1 : 0;
                            setState(() {});
                            state(() {});
                          },
                          switchActiveColor: Colors.teal,
                          switchScale: 1,
                          switchType: SwitchType.cupertino,
                          title: Text(
                            AppLocalizations.of(context)!.opasnuiGruz,
                          ),
                        ),
                        ListTileSwitch(
                          value: f.isdogruz == -1 ? false : _isdogruz,
                          leading: const Icon(Icons.add_road),
                          onChanged: (value) {
                            _isdogruz = value;
                            f.isdogruz = _isdogruz ? 1 : 0;
                            setState(() {});
                            state(() {});
                          },
                          switchActiveColor: Colors.teal,
                          switchScale: 1,
                          // subtitle: const Text(
                          //   'Комментарии',
                          // ),
                          switchType: SwitchType.cupertino,
                          title: Text(
                            AppLocalizations.of(context)!.dogruz,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();

                            GetFilter();

                            state(() {});
                            setState(() {});
                          },
                          label: Text(AppLocalizations.of(context)!.primenit),
                          icon: Image.asset("images/11check.png",
                              width: 16, height: 16, color: Colors.white),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            f.resetFilter();
                            GetFilter();

                            resetElements();

                            state(() {});
                            setState(() {});
                          },
                          label: Text(AppLocalizations.of(context)!.sbrosit),
                          icon: Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

class DriverFiltering {
  TextEditingController beginCityName = TextEditingController();
  TextEditingController endCityName = TextEditingController();
  TextEditingController beginPrice = TextEditingController();
  TextEditingController endPrice = TextEditingController();
  TextEditingController beginDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  int isdanger = -1;
  int isdogruz = -1;

  int carTypeId = 0;
  String cur_id = '-1';

  TextEditingController orderBy = TextEditingController(text: 'driver');
  TextEditingController orderType = TextEditingController(text: 'desc');

  DriverFiltering({
    required this.beginCityName,
    required this.endCityName,
    required this.beginPrice,
    required this.endPrice,
    required this.beginDate,
    required this.endDate,
    required this.isdanger,
    required this.isdogruz,
    required this.carTypeId,
    required this.cur_id,
    required this.orderBy,
    required this.orderType,
  });

  void resetFilter() async {
    beginCityName.text = '';
    endCityName.text = '';
    beginPrice.text = '';
    endPrice.text = '';
    beginDate.text = '';
    endDate.text = '';
    isdanger = -1;
    isdogruz = -1;
    carTypeId = 0;
    cur_id = '0';
    orderBy.text = 'client';
    orderType.text = 'desc';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['beginCityName'] = this.beginCityName.text;
    data['endCityName'] = this.endCityName.text;

    data['beginPrice'] =
        this.beginPrice.text.isEmpty ? 0 : int.parse(this.beginPrice.text);
    data['endPrice'] =
        this.endPrice.text.isEmpty ? 0 : int.parse(this.endPrice.text);

    data['beginDate'] = this.beginDate.text;
    data['endDate'] = this.endDate.text;

    data['isAdd'] = this.isdanger;
    data['isDanger'] = this.isdogruz;

    data['currencyId'] = this.cur_id;

    data['carTypeId'] = this.carTypeId;
    data['brandId'] = 0;
    data['modelId'] = 0;

    data['orderBy'] = this.orderBy.text; //"rank";
    data['orderType'] = this.orderType.text; // "asc"

    return data;
  }
}

_onBasicAlertPressed(context) {
  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
      animationDuration: Duration(milliseconds: 250),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
      ));
  Alert(
      context: context,
      style: alertStyle,
      // title: "RFLUTTER ALERT",
      desc: AppLocalizations.of(context)!.dlyaProdRabotyZareg,
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterStep1View()),
            );
          },
          child: Text(
            AppLocalizations.of(context)!.register,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
}
