import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import '../../app/my_app.dart';
import 'Settings_page.dart';
import 'profile/profile_model.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class ZayavitTransport extends StatefulWidget {
  @override
  _ZayavitTransportState createState() => _ZayavitTransportState();
}

class _ZayavitTransportState extends State<ZayavitTransport> {
  List<MultiRoute> routes = [];
  bool addrError = false;

  PickResult? selectedPlaceA;
  PickResult? selectedPlaceB;
  bool? isDriverSelected;
  bool? isCarSelected;
  bool isChecked1 = true;
  bool isChecked2 = false;
  String temp1 = '';
  String temp2 = '';
  bool isAdd1 = true;
  bool isAdd2 = false;

  String isEmpWidget = '';

  var selectPlaceA = TextEditingController();
  var selectPlaceB = TextEditingController();

  final fName = TextEditingController();
  final lName = TextEditingController();
  final pName = TextEditingController();
  final iin = TextEditingController();
  final eMail = TextEditingController();

  final orderName = TextEditingController();
  final lugWeigth = TextEditingController();

  final lugH = TextEditingController();
  final lugW = TextEditingController();
  final lugL = TextEditingController();

  final lugSize = TextEditingController();

  bool isDanger = false;
  bool isAdd = false;

  final beginPoint = TextEditingController();
  final endPoint = TextEditingController();
  final beginPointName = TextEditingController();
  final endPointName = TextEditingController();

  final tripDate = TextEditingController();
  final bookerOfferPrice = TextEditingController();
  final paymentType = TextEditingController();

  DateTime selectedDate = DateTime.now();

  var customFormat = DateFormat('yyyy-MM-dd');

  Future<Null> showPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2022));

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        tripDate.text = customFormat.format(selectedDate);
      });
  }

  // String _selectedDate = 'выбрать';
  bool _isdanger = false;
  bool _isdogruz = false;

  // ignore: unused_element
  Future<void> _selectDate(BuildContext context) async {
    DatePicker.showDatePicker(
      context,
      currentTime: DateTime.now(),
      locale: LocaleType.ru,
      showTitleActions: true,
      minTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      maxTime: DateTime(DateTime.now().year + 1),
      onConfirm: (date) {
        print('confirm $date');

        setState(() {
          // _selectedDate = new DateFormat('yyyy.MM.dd').format(date);
          tripDate.text = new DateFormat('yyyy.MM.dd').format(date);
        });
      },
    );
    // final DateTime? d = await showDatePicker(
    //   context: context,
    //   initialDate: DateTime.now(),
    //   firstDate: DateTime(2015),
    //   lastDate: DateTime(2023),
    // );
    // if (d != null)
    //   setState(() {
    //     _selectedDate = new DateFormat('yyyy.MM.dd').format(d);
    //     tripDate.text = new DateFormat('yyyy.MM.dd').format(d);
    //   });
  }

  List cars = [];
  List drivers = [];
  int carId = 0;
  int driverId = 0;
  int carTypeId = 0;

  final pm = ProfileModel();
  var notMsq = '';

  @override
  void initState() {
    currency_name = [];
    currency_id = [];

    routes = [];
    notMsq = '';
    addrError = false;

    super.initState();

    pm.setupLocale(context).then(
      (value) {
        CurrencyList(
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
              var temp = json.decode(value);
              for (var item in temp) {
                // print(item['currencyId']);
                // print(item['currencyCode']);

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
      },
    );
  }

  dropDown1() {
    String testD = '';

    dynamic D = [];
    for (var item in drivers) {
      var value = '${item['firstName']} ${item['lastName']} ${item['iin']}';
      D.add(value);
      testD = value;
    }
    D.add('Жүргізушіні таңдаңыз');

    final sugars = D;
    final sugars111 = D as List;
    String? _currentSugars = 'Жүргізушіні таңдаңыз';
    return sugars111.length > 0
        ? DropdownButtonFormField<String>(
            isExpanded: true,
            value: _currentSugars,
            items: sugars.map<DropdownMenuItem<String>>((sugar) {
              return DropdownMenuItem(
                value: sugar.toString(),
                child: Text(
                  '$sugar',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.blueGrey,
                  ),
                ),
              );
            }).toList(),
            onChanged: (val) => setState(
              () {
                if (val == 'Жүргізушіні таңдаңыз') {
                  isDriverSelected = false;
                  return null;
                }
                isDriverSelected = true;
                setState(() {});
                _currentSugars = val;
                print(_currentSugars);
                int ind = sugars.indexOf(_currentSugars.toString());
                print(ind);
                print(drivers[ind]['clientId']);
                driverId = drivers[ind]['clientId'];
              },
            ),
          )
        : Text("Load...");
  }

  dropDown2() {
    String testD = '';
    dynamic D = [];
    D.add('Көлікті тандаңыз');

    for (var item in cars) {
      var value =
          '${item['carTypeNameRu']} ${item['brandNameRu']} ${item['modelNameRu']} ${item['modelYear']} ${item['carNumber']}';
      D.add(value);
      testD = value;
    }

    final sugars = D;
    final sugars111 = D as List;
    String _currentSugars = 'Көлікті тандаңыз';
    return sugars111.length > 0
        ? DropdownButtonFormField<String>(
            isExpanded: true,
            value: _currentSugars,
            items: sugars.map<DropdownMenuItem<String>>((sugar) {
              return DropdownMenuItem(
                value: sugar.toString(),
                child: Text(
                  '$sugar',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                    color: Colors.blueGrey,
                  ),
                ),
              );
            }).toList(),
            onChanged: (val) => setState(() {
              // print(cars[ind]['carId']);
              if (val == 'Көлікті тандаңыз') {
                isCarSelected = false;
                return null;
              }
              isCarSelected = true;
              setState(() {});
              print('test printing cars: ' + cars.length.toString());
              print('ONTAP');
              _currentSugars = val!;
              print(_currentSugars);
              int ind = sugars.indexOf(_currentSugars.toString());
              ind = ind - 1;
              print(ind);
              try {
                carId = cars[ind]['carId'];
              } catch (e) {
                print(e);
              }
              carTypeId = cars[ind]['carTypeId'];
              print('ONTAP END');
            }),
          )
        : Text('Load...');
  }

  // dropDown2() {
  //   String testD = '';
  //   dynamic D = [];
  //   for (var item in cars) {
  //     var value =
  //         '${item['carTypeNameRu']} ${item['brandNameRu']} ${item['modelNameRu']} ${item['modelYear']} ${item['carNumber']}';
  //     D.add(value);
  //     testD = value;
  //   }

  //   final sugars = D;
  //   final sugars111 = D as List;
  //   String? _currentSugars = testD;
  //   return sugars111.length > 0
  //       ? DropdownButtonFormField<String>(
  //           isExpanded: true,
  //           value: _currentSugars,
  //           items: sugars.map<DropdownMenuItem<String>>((sugar) {
  //             return DropdownMenuItem(
  //               value: sugar.toString(),
  //               child: Text(
  //                 '$sugar',
  //                 overflow: TextOverflow.ellipsis,
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.normal,
  //                   fontSize: 13,
  //                   color: Colors.blueGrey,
  //                 ),
  //               ),
  //             );
  //           }).toList(),
  //           onChanged: (val) => setState(() {
  //             _currentSugars = val;
  //             print(_currentSugars);
  //             int ind = sugars.indexOf(_currentSugars.toString());
  //             print(ind);
  //             print(cars[ind]['carId']);
  //             carId = cars[ind]['carId'];
  //             carTypeId = cars[ind]['carTypeId'];
  //           }),
  //         )
  //       : Text('Load...');
  // }

  final textStyleError = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red);

  // @override
  // void dispose() {
  //   pm.dispose();
  //   selectPlaceA.dispose();
  //   selectPlaceB.dispose();
  //   fName.dispose();
  //   lName.dispose();
  //   pName.dispose();
  //   iin.dispose();
  //   eMail.dispose();
  //   orderName.dispose();
  //   lugWeigth.dispose();
  //   lugH.dispose();
  //   lugW.dispose();
  //   lugL.dispose();
  //   lugSize.dispose();
  //   beginPoint.dispose();
  //   endPoint.dispose();
  //   beginPointName.dispose();
  //   endPointName.dispose();
  //   tripDate.dispose();
  //   bookerOfferPrice.dispose();
  //   paymentType.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.zayavitTransport),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: provider.selectedThemeMode != ThemeMode.dark
                      ? Colors.white
                      : Color.fromRGBO(27, 28, 34, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(14, 23, 47, 0.25),
                      offset: Offset(0.0, 3.0), //(x,y)
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.marshrut,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          // color: AppColors.primaryColors[0],
                        ),
                      ),
                      // SizedBox(height: 10),
                      selectAdress(context, provider),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: provider.selectedThemeMode != ThemeMode.dark
                      ? Colors.white
                      : Color.fromRGBO(27, 28, 34, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(14, 23, 47, 0.25),
                      offset: Offset(0.0, 3.0), //(x,y)
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.gruz,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          // color: AppColors.primaryColors[0],
                        ),
                      ),
                      ListTileSwitch(
                        value: _isdogruz,
                        onChanged: (value) {
                          _isdogruz = value;
                          setState(() {});
                        },
                        switchActiveColor: AppColors.primaryColors[2],
                        switchType: SwitchType.cupertino,
                        title: Text(
                          AppLocalizations.of(context)!.dogruz,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            // color: AppColors.primaryColors[0],
                          ),
                        ),
                      ),
                      ListTileSwitch(
                        value: _isdanger,
                        onChanged: (value) {
                          _isdanger = value;
                          setState(() {});
                        },
                        switchActiveColor: AppColors.primaryColors[2],
                        switchType: SwitchType.cupertino,
                        title: Text(
                          AppLocalizations.of(context)!.opasnuiGruz,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            // color: AppColors.primaryColors[0],
                          ),
                        ),
                      ),
                      // SizedBox(height: 20),
                      pm.sysUserType == "4"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.voditel,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    // color: AppColors.primaryColors[0],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    dropDown1(),
                                    (isDriverSelected == null ||
                                            (isDriverSelected != null &&
                                                isDriverSelected!))
                                        ? SizedBox()
                                        : Text(
                                            'Жүргізуші таңдау міндетті',
                                            style: TextStyle(color: Colors.red),
                                          )
                                  ],
                                ),
                                SizedBox(height: 20),
                                Text(
                                  AppLocalizations.of(context)!.avto,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    // color: AppColors.primaryColors[0],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    dropDown2(),
                                    (isCarSelected == null ||
                                            (isCarSelected != null &&
                                                isCarSelected!))
                                        ? SizedBox()
                                        : Text(
                                            'Көлікті таңдау міндетті',
                                            style: TextStyle(color: Colors.red),
                                          )
                                  ],
                                )
                              ],
                            )
                          : Column()
                    ],
                  ),
                ),
              ),
              Center(child: Text(notMsq, style: TextStyle(color: Colors.red))),
              SizedBox(height: 10),
              SizedBox(height: 9),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     OutlinedButton(
                    //       onPressed: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => RouteView()),
                    //         );
                    //       },
                    //       child: Text('Показать маршрут'),
                    //     ),
                    //     OutlinedButton(
                    //       onPressed: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => RouteView()),
                    //         );
                    //       },
                    //       child: Text('Рассчет суммы'),
                    //     ),
                    //   ],
                    // ),
                    // Text(
                    //   'Рекомендуемая цена: 120 000 тг',
                    //   style: TextStyle(
                    //     fontSize: 12.0,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    // Text(
                    //   '*Сумма может отличаться от рекомендуемой цены',
                    //   style: TextStyle(
                    //     fontSize: 12.0,
                    //     color: Colors.blueGrey,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                    onPressed: () {
                      if ((isDriverSelected == null) || !isDriverSelected!) {
                        isDriverSelected = false;
                        setState(() {});
                        return null;
                      }
                      if ((isCarSelected == null) || !isCarSelected!) {
                        isCarSelected = false;
                        setState(() {});
                        return null;
                      }
                      var allDateNotSel = false;
                      var allPriceNotSel = false;

                      for (var i = 0; i < routes.length - 1; i++) {
                        if (routes[i].addressDate.text == 'выбрать') {
                          allDateNotSel = true;
                        }
                        if (routes[i].addressPrice.text == '0') {
                          allPriceNotSel = true;
                        }
                      }

                      if (routes.length < 2) {
                        setState(() {
                          notMsq =
                              AppLocalizations.of(context)!.vibiriteMin2Adresa;
                        });
                      } else if (allDateNotSel) {
                        setState(() {
                          notMsq = AppLocalizations.of(context)!
                              .neVibranaDataPoezdki;
                        });
                      } else if (allPriceNotSel) {
                        setState(() {
                          notMsq =
                              AppLocalizations.of(context)!.nuzhnoUkazatTcenu;
                        });
                      } else {
                        setState(() {
                          notMsq = '';
                        });
                        print('Все норм');

                        var tripPoints = [];

                        for (var i = 0; i < routes.length - 1; i++) {
                          tripPoints.add({
                            "orderName": '${routes[i].addressDesk.text}',
                            "tripDate": routes[i].addressDate.text.toString(),
                            "bookerOfferPrice": double.parse(routes[i]
                                .addressPrice
                                .text
                                .replaceAll(" ", "")
                                .toString()),
                            "currencyId": routes[i].currency_id,
                            "beginCountryName": routes[i].addressCountry,
                            "beginCityName": routes[i].addressCity,
                            "beginPoint":
                                '${routes[i].addressDetails?.geometry?.location.lat},${routes[i].addressDetails?.geometry?.location.lng}',
                            "beginPointName": routes[i].addressName,
                            "endCountryName": routes[i + 1].addressCountry,
                            "endCityName": routes[i + 1].addressCity,
                            "endPoint":
                                '${routes[i + 1].addressDetails?.geometry?.location.lat},${routes[i + 1].addressDetails?.geometry?.location.lng}',
                            "endPointName": routes[i + 1].addressName
                          });
                        }
                        print(tripPoints.length);

                        showLoadingIndicator(context);
                        print('Creating order==>');

                        dynamic data = {
                          "orderName": orderName.text,
                          "orderStatus": 0,
                          "isDanger": _isdanger ? 1 : 0,
                          "isAdd": _isdogruz ? 1 : 0,
                          "routes": tripPoints,
                          "finalPrice": 0.0,
                          "sysUserType": int.parse(pm.sysUserType),
                          "carId": carId,
                          "driverId": driverId,
                          "carTypeId": carTypeId
                        };

                        // print(data);

                        CreateNewOrder(
                          token: pm.token,
                          jdata: data,
                        ).Create().then(
                          (value) {
                            print('Response: $value');
                            hideOpenDialog(context);

                            if (value.toString() == '401') {
                              final provider = SessionDataProvider();
                              provider.setSessionId(null);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  MainNavigationRouteNames.changeLang,
                                  (Route<dynamic> route) => false);
                            }

                            if (value.contains('success')) {
                              _onBasicAlertPressed(context);
                            } else {
                              _onBasicAlertPressed3(context);
                            }
                          },
                        );
                      }
                    },
                    label: Text(AppLocalizations.of(context)!.zayavit),
                    icon: Image.asset("images/11check.png",
                        width: 16, height: 16, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Center selectAdress(BuildContext context, LocaleProvider provider) {
    return Center(
      child: Column(
        children: [
          Text(notMsq, style: TextStyle(color: Colors.red)),
          SizedBox(height: 5),
          ...routes.map(
            (val) {
              var tempControl = TextEditingController(text: val.addressName);
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
                    borderSide:
                        BorderSide(color: Color.fromRGBO(228, 232, 250, 1))),
              );

              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color.fromRGBO(80, 155, 213, 1).withOpacity(0.1),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                routes.indexOf(val) == 0
                                    ? AppLocalizations.of(context)!.from
                                    : routes.indexOf(val) == routes.length - 1
                                        ? AppLocalizations.of(context)!.to
                                        : "",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  // color: AppColors.primaryColors[0],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    routes.removeAt(routes.indexOf(val));
                                    routes.length < 2
                                        ? addrError = true
                                        : addrError = false;
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.close))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
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
                                          onPlacePicked: (result) {
                                            var tempInd = routes.indexOf(val);

                                            var temp = MultiRoute();

                                            temp.addressDetails = result;

                                            var country = result
                                                .addressComponents!
                                                .where((e) =>
                                                    e.types.first == 'country')
                                                .first
                                                .longName;
                                            var city = result.addressComponents!
                                                .where((e) =>
                                                    e.types.first == 'locality')
                                                .first
                                                .longName;

                                            print("$city, $country");

                                            temp.addressName =
                                                "$city, $country";
                                            temp.addressCity = city;
                                            temp.addressCountry = country;
                                            routes[tempInd] = temp;

                                            Navigator.of(context).pop();

                                            routes.length < 2
                                                ? addrError = true
                                                : addrError = false;
                                            setState(() {});
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: TextField(
                                  style: fSt,
                                  enabled: false,
                                  maxLines: 1,
                                  keyboardType: TextInputType.multiline,
                                  controller: tempControl,
                                  decoration: fDec,
                                ),
                              ),
                              SizedBox(height: 16),
                              routes.indexOf(val) == routes.length - 1 &&
                                      routes.length > 1
                                  ? SizedBox()
                                  : Column(
                                      children: [
                                        Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                new Flexible(
                                                  flex: 4,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .prise,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12,
                                                          // color: AppColors
                                                          //     .primaryColors[0],
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      TextFormField(
                                                        inputFormatters: [
                                                          MaskTextInputFormatter(
                                                            mask:
                                                                "### ### ### ###",
                                                          )
                                                        ],
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            val.addressPrice,
                                                        style: fSt,
                                                        decoration: fDec,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                new Flexible(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .currency,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12,
                                                          // color: AppColors
                                                          //     .primaryColors[0],
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      DropdownSearch<String>(
                                                        dropdownSearchDecoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 8),
                                                          isDense: true,
                                                          fillColor: provider
                                                                      .selectedThemeMode ==
                                                                  ThemeMode.dark
                                                              ? Color.fromRGBO(
                                                                  53, 54, 61, 1)
                                                              : Colors.white,
                                                          filled: true,
                                                          border: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          228,
                                                                          232,
                                                                          250,
                                                                          1))),
                                                        ),
                                                        mode: Mode.BOTTOM_SHEET,
                                                        items: currency_name,
                                                        selectedItem: 'выбрать',
                                                        onChanged: (newValue) {
                                                          val.currency_id =
                                                              currency_id[
                                                                  currency_name
                                                                      .indexOf(
                                                            newValue!,
                                                          )];
                                                          setState(() {});
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .date,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                // color:
                                                //     AppColors.primaryColors[0],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        InkWell(
                                          child: TextFormField(
                                            enabled: false,
                                            keyboardType: TextInputType.number,
                                            controller: val.addressDate,
                                            style: fSt,
                                            decoration: InputDecoration(
                                              suffixIcon: Icon(
                                                Icons.calendar_today_outlined,
                                                // color: AppColors
                                                //     .primaryColors[0],
                                              ),
                                              isDense: true,
                                              fillColor:
                                                  provider.selectedThemeMode ==
                                                          ThemeMode.dark
                                                      ? Color.fromRGBO(
                                                          53, 54, 61, 1)
                                                      : Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromRGBO(
                                                          228, 232, 250, 1))),
                                            ),
                                          ),
                                          onTap: () {
                                            DatePicker.showDatePicker(
                                              context,
                                              currentTime: DateTime.now(),
                                              locale: LocaleType.ru,
                                              showTitleActions: true,
                                              minTime: DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  DateTime.now().day),
                                              maxTime: DateTime(
                                                  DateTime.now().year + 1),
                                              onConfirm: (date) {
                                                setState(() {
                                                  val.addressDate.text =
                                                      new DateFormat(
                                                              'yyyy.MM.dd')
                                                          .format(date);
                                                });
                                              },
                                            );
                                          },
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .comment,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                // color:
                                                //     AppColors.primaryColors[0],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        TextFormField(
                                          controller: val.addressDesk,
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.multiline,
                                          minLines: 3,
                                          maxLines: 3,
                                          style: fSt,
                                          decoration: fDec,
                                        ),
                                      ],
                                    ),
                              routes.indexOf(val) == routes.length - 1 &&
                                      routes.indexOf(val) > 0
                                  ? SizedBox()
                                  : SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  routes.indexOf(val) == routes.length - 1
                      ? SizedBox()
                      : SizedBox(height: 20),
                ],
              );
            },
          ),
          SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
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
                          onPlacePicked: (result) {
                            var temp = MultiRoute();
                            temp.addressDetails = result;

                            var country = result.addressComponents!
                                .where((e) => e.types.first == 'country')
                                .first
                                .longName;
                            var city = result.addressComponents!
                                .where((e) => e.types.first == 'locality')
                                .first
                                .longName;

                            print("$city, $country");

                            temp.addressName = "$city, $country";
                            temp.addressCity = city;
                            temp.addressCountry = country;
                            routes.add(temp);

                            Navigator.of(context).pop();
                            setState(() {
                              routes.length < 2
                                  ? addrError = true
                                  : addrError = false;
                            });
                          },
                        );
                      },
                    ),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.dobavitAddress,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    // color: AppColors.primaryColors[0],
                    fontSize: 12,
                  ),
                ),
                style: ButtonStyle(
                  // side: MaterialStateProperty.all<BorderSide>(
                  //     BorderSide(width: 2, color: AppColors.primaryColors[0])),
                  // foregroundColor:
                  //     MaterialStateProperty.all<Color>(Colors.white),
                  // backgroundColor:
                  //     MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
      desc: AppLocalizations.of(context)!.zakazUspeshnoSozdan,
      buttons: [
        DialogButton(
          onPressed: () async {
            Navigator.of(context).pushNamedAndRemoveUntil(
                MainNavigationRouteNames.mainScreen,
                (Route<dynamic> route) => false);
          },
          child: Text(
            AppLocalizations.of(context)!.prodolzhit,
            style: TextStyle(fontSize: 20),
          ),
        )
      ]).show();
}

_onBasicAlertPressed3(context) {
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
      desc: AppLocalizations.of(context)!.povtoritePopitku2,
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppLocalizations.of(context)!.prodolzhit,
            style: TextStyle(fontSize: 20),
          ),
        )
      ]).show();
}

class MultiRoute {
  String? currency_id;
  String? addressName;
  String? addressCity;
  String? addressCountry;
  PickResult? addressDetails;
  TextEditingController addressDate = TextEditingController(text: 'выбрать');
  TextEditingController addressPrice = TextEditingController(text: '0');
  TextEditingController addressDesk = TextEditingController();
}

List<String> currency_name = [];
List<String> currency_id = [];
