import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
// import 'package:themoviedb/full/ui/order/google_route.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_list/Current/newCurrentOrder.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/my_cars.dart';
import '../../app/my_app.dart';
import 'Settings_page.dart';
import 'profile/profile_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class AutoCO extends StatefulWidget {
  @override
  _AutoCOState createState() => _AutoCOState();
}

class _AutoCOState extends State<AutoCO> {
  PickResult? selectedPlaceA;
  PickResult? selectedPlaceB;
  bool? isCarTypeSelected;
  bool isChecked1 = true;
  bool isChecked2 = false;
  bool CurencySelected = false;
  bool isAdd1 = true;
  bool isAdd2 = false;
  bool isPriceGiven = false;
  String isEmpWidget = '';
  String? errorText1;
  String? errorText2;
  String? errorText3;
  String? errorText4;
  String? errorText5;
  String? adressErrorText1;
  String? adressErrorText2;
  String ChoosenDate = '';
  var selectPlaceA = TextEditingController();
  var selectPlaceB = TextEditingController();

  final fName = TextEditingController();
  final lName = TextEditingController();
  final pName = TextEditingController();
  final iin = TextEditingController();
  final eMail = TextEditingController();

  final orderName = TextEditingController();
  final lugWeigth = TextEditingController();

  final lugHeight = TextEditingController();
  final lugWidth = TextEditingController();
  final lugDepth = TextEditingController();

  final lugSize = TextEditingController();

  bool isDanger = false;
  bool isAdd = false;

  final carTypeId = TextEditingController();

  final beginPoint = TextEditingController();
  final endPoint = TextEditingController();
  final beginPointName = TextEditingController();
  final endPointName = TextEditingController();

  final tripDate = TextEditingController();
  final bookerOfferPrice = TextEditingController();
  String cur_id = '0';
  final paymentType = TextEditingController();

  DateTime selectedDate = DateTime.now();

  var customFormat = DateFormat('yyyy.MM.dd');
  var isDateSelected = false;
  List<String> currency_name = [];
  List<String> currency_id = [];

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

  bool _isdanger = false;
  bool _isdogruz = false;

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
        // ChoosenDate = date.toString().split('.')[0];
        print('confirm3212 $date');
        isDateSelected = false;
        setState(() {
          ChoosenDate = new DateFormat('dd.MM.yyyy').format(date);
          tripDate.text = new DateFormat('dd.MM.yyyy').format(date);
        });
      },
    );

    // final DateTime? d = await showDatePicker(
    //   context: context,
    //   initialDate: DateTime.now(),
    //   firstDate: DateTime(2020),
    //   lastDate: DateTime(2024),
    // );
    // if (d != null)
    //   setState(() {
    //     _selectedDate = new DateFormat('yyyy.MM.dd').format(d);
    //     tripDate.text = new DateFormat('yyyy.MM.dd').format(d);
    //   });
  }

  late CarModelDetail CarModelsDet;
  late CarTypeDetail CarTypeDet;
  List<String> CarModels = [];
  List<String> CarTypes = [];

  @override
  void initState() {
    super.initState();

    currency_name = [];
    currency_id = [];
    tripDate.text = '';
    final pm = ProfileModel();
    pm.setupLocale(context).then((value) {
      print(pm.token);

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

      GetCarType(
        token: pm.token,
      ).get().then(
        (value) {
          // hideOpenDialog(context);
          print('Response: $value');

          if (value.toString() == '401') {
            final provider = SessionDataProvider();
            provider.setSessionId(null);
            Navigator.of(context).pushNamedAndRemoveUntil(
                MainNavigationRouteNames.changeLang,
                (Route<dynamic> route) => false);
          }

          if (value.contains('Error')) {
            showErrorIndicator(context);
          } else {
            final parsedJson = jsonDecode(value);
            CarTypeDet = CarTypeDetail.fromJson(parsedJson);
            List<String> aaa = [];
            for (var item in CarTypeDet.carTypes) {
              aaa.add(item.nameRu);
            }
            CarTypes = aaa;
            carTypeId.text = CarTypeDet.carTypes.first.carTypeId.toString();

            setState(() {});
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      // color: Colors.blueGrey,
    );

    final pm = ProfileModel();
    pm.setupLocale(context).then((value) => null);

    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.sozdatNewZakaz),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.gruz,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blueGrey,
                ),
              ),
              // SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isEmpWidget,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.red,
                      ),
                    ),
                    TextFormField(
                      controller: orderName,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText:
                              '${AppLocalizations.of(context)!.opisanieGruz} *',
                          isDense: true,
                          fillColor:
                              provider.selectedThemeMode == ThemeMode.dark
                                  ? Color.fromRGBO(53, 54, 61, 1)
                                  : Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(228, 232, 250, 1)),
                          ),
                          errorText: errorText1),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: lugWeigth,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(5)
                      ],
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText:
                              '${AppLocalizations.of(context)!.vesGruz}(${AppLocalizations.of(context)!.tonna}) *',
                          isDense: true,
                          fillColor:
                              provider.selectedThemeMode == ThemeMode.dark
                                  ? Color.fromRGBO(53, 54, 61, 1)
                                  : Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(228, 232, 250, 1)),
                          ),
                          errorText: errorText2),
                    ),
                    // SizedBox(height: 10),
                    // TextFormField(
                    //   controller: lugSize,
                    //   textInputAction: TextInputAction.next,
                    //   keyboardType: TextInputType.number,
                    //   decoration: InputDecoration(
                    //     labelText: 'Объем(м3)',
                    //     border: OutlineInputBorder(),
                    //   ),
                    // ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: lugHeight,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(3)
                      ],
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.visota,
                          isDense: true,
                          fillColor:
                              provider.selectedThemeMode == ThemeMode.dark
                                  ? Color.fromRGBO(53, 54, 61, 1)
                                  : Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(228, 232, 250, 1)),
                          ),
                          errorText: errorText3),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(3)
                      ],
                      controller: lugWidth,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.shirina,
                          isDense: true,
                          fillColor:
                              provider.selectedThemeMode == ThemeMode.dark
                                  ? Color.fromRGBO(53, 54, 61, 1)
                                  : Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(228, 232, 250, 1)),
                          ),
                          errorText: errorText4),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(3)
                      ],
                      controller: lugDepth,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.dlina,
                          isDense: true,
                          fillColor:
                              provider.selectedThemeMode == ThemeMode.dark
                                  ? Color.fromRGBO(53, 54, 61, 1)
                                  : Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(228, 232, 250, 1)),
                          ),
                          errorText: errorText5),
                    ),
                    SizedBox(height: 10),

                    //https://pub.dev/packages/list_tile_switch/example
                    ListTileSwitch(
                      value: _isdogruz,
                      leading: const Icon(Icons.dangerous_rounded),
                      onChanged: (value) {
                        setState(() {
                          _isdogruz = value;
                        });
                      },
                      switchActiveColor: Colors.teal,
                      switchScale: 1,
                      // subtitle: const Text(
                      //   'Комментарии',
                      // ),
                      switchType: SwitchType.cupertino,
                      title: Text(AppLocalizations.of(context)!.dogruz),
                    ),

                    ListTileSwitch(
                      value: _isdanger,
                      leading: const Icon(Icons.view_column),
                      onChanged: (value) {
                        setState(() {
                          _isdanger = value;
                        });
                      },
                      switchActiveColor: Colors.teal,
                      switchScale: 1,
                      // subtitle: const Text(
                      //   'Комментарии',
                      // ),
                      switchType: SwitchType.cupertino,
                      title: Text(AppLocalizations.of(context)!.opasnuiGruz),
                    ),

                    SizedBox(height: 5),
                    Text(AppLocalizations.of(context)!.tipKuzova,
                        style: textStyle),
                    SizedBox(height: 5),

                    CarTypes.length == 0
                        ? Text('Нет данных по типу кузова')
                        : Column(
                            children: [
                              DropdownSearch<String>(
                                mode: Mode.BOTTOM_SHEET,
                                showSearchBox: true,
                                showSelectedItem: true,
                                items: CarTypes,
                                // label: "Валюта",
                                selectedItem: "Выберите тип кузова",
                                onChanged: (newValue) {
                                  isCarTypeSelected = true;
                                  var id = CarTypeDet.carTypes.where(
                                      (element) => element.nameRu == newValue);

                                  carTypeId.text =
                                      (id.last.carTypeId).toString();
                                  print(carTypeId.text);
                                  setState(() {});
                                },
                              ),
                              (isCarTypeSelected == null || isCarTypeSelected!)
                                  ? SizedBox()
                                  : Text(
                                      'Выберите тип кузова',
                                      style: TextStyle(color: Colors.red),
                                    )
                            ],
                          ),

                    SizedBox(height: 5),
                  ],
                ),
              ),

              Text(
                AppLocalizations.of(context)!.marshrut,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(height: 5),

              selectAdress(context), // Построение маршрута

              SizedBox(height: 5),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   child: Column(
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           ElevatedButton(
              //             onPressed: () {
              //               if (selectedPlaceA != null &&
              //                   selectedPlaceB != null) {
              //                 var coord1 =
              //                     '${selectedPlaceA?.geometry?.location.lat},${selectedPlaceA?.geometry?.location.lng}'
              //                         .split(",");
              //                 var coord2 =
              //                     '${selectedPlaceB?.geometry?.location.lat},${selectedPlaceB?.geometry?.location.lng}'
              //                         .split(",");

              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (context) => MapPage(
              //                       coord1: coord1,
              //                       coord2: coord2,
              //                     ),
              //                   ),
              //                 );
              //               }
              //             },
              //             child: Text('Показать маршрут'),
              //           ),
              //           ElevatedButton(
              //             onPressed: () {
              //               // Navigator.push(
              //               //   context,
              //               //   MaterialPageRoute(
              //               //       builder: (context) => RouteView()),
              //               // );
              //             },
              //             child: Text('Рассчет суммы'),
              //           ),
              //         ],
              //       ),
              //       // Text(
              //       //   'Рекомендуемая цена: 120 000 тг',
              //       //   style: TextStyle(
              //       //     fontSize: 12.0,
              //       //     color: Colors.black,
              //       //   ),
              //       // ),
              //       // SizedBox(height: 5),
              //       // Text(
              //       //   '*Сумма может отличаться от рекомендуемой цены',
              //       //   style: TextStyle(
              //       //     fontSize: 12.0,
              //       //     color: Colors.blueGrey,
              //       //   ),
              //       // ),
              //     ],
              //   ),
              // ),
              Text(
                AppLocalizations.of(context)!.date,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blueGrey,
                ),
              ),

              // SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ChoosenDate == ''
                              ? '${AppLocalizations.of(context)!.viberiteDatu} *'
                              : ChoosenDate,
                          style: textStyle,
                        ),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        width: 0.5,
                                        color: isDateSelected
                                            ? Colors.red
                                            : Colors.grey),
                                    left: BorderSide(
                                        width: 0.5,
                                        color: isDateSelected
                                            ? Colors.red
                                            : Colors.grey),
                                    right: BorderSide(
                                        width: 0.5,
                                        color: isDateSelected
                                            ? Colors.red
                                            : Colors.grey),
                                    bottom: BorderSide(
                                        width: 0.5,
                                        color: isDateSelected
                                            ? Colors.red
                                            : Colors.grey),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    InkWell(
                                      child: Text(
                                        "   " +
                                            AppLocalizations.of(context)!
                                                .select,
                                        textAlign: TextAlign.center,
                                        // style: TextStyle(color: Color(0xFF000000)),
                                      ),
                                      onTap: () {
                                        _selectDate(context);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.calendar_today,
                                        color: Colors.grey,
                                      ),
                                      tooltip:
                                          AppLocalizations.of(context)!.select,
                                      onPressed: () {
                                        _selectDate(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            isDateSelected
                                ? Text(
                                    'Выберите дату',
                                    style: TextStyle(color: Colors.red),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              Text(
                AppLocalizations.of(context)!.oplata,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 5),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Flexible(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: new TextFormField(
                              inputFormatters: [
                                MaskTextInputFormatter(mask: "### ### ### ###")
                              ],
                              keyboardType: TextInputType.number,
                              controller: bookerOfferPrice,
                              style: TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                  errorText:
                                      isPriceGiven ? 'Введите цену' : null,
                                  isDense: true,
                                  fillColor: provider.selectedThemeMode ==
                                          ThemeMode.dark
                                      ? Color.fromRGBO(53, 54, 61, 1)
                                      : Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(228, 232, 250, 1)),
                                  ),
                                  suffixIcon: Icon(Icons.payments_sharp),
                                  contentPadding: EdgeInsets.all(15),
                                  labelText:
                                      AppLocalizations.of(context)!.summa),
                            ),
                          ),
                        ),
                        new Flexible(
                          flex: 3,
                          child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Column(
                                children: [
                                  CurencySelected
                                      ? Text(
                                          'Выберите валюту',
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : SizedBox(),
                                  new DropdownSearch<String>(
                                    mode: Mode.BOTTOM_SHEET,
                                    showSearchBox: true,
                                    showSelectedItem: true,
                                    items: currency_name,
                                    label:
                                        AppLocalizations.of(context)!.currency,
                                    selectedItem:
                                        AppLocalizations.of(context)!.select,
                                    onChanged: (newValue) {
                                      CurencySelected = false;
                                      cur_id = currency_id[
                                          currency_name.indexOf(newValue!)];
                                      setState(() {});
                                    },
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 100, vertical: 20)),
                    onPressed: () {
                      print('Creating order==>');
                      if (orderName.text == '') {
                        errorText1 = 'Жүк сипаттамасы міндетті';
                        setState(() {});
                        return null;
                      } else {
                        errorText1 = null;
                      }
                      if (lugWeigth.text == '') {
                        errorText2 = 'Жүк салмағы міндетті';
                        setState(() {});
                        return null;
                      } else {
                        errorText2 = null;
                      }
                      if (lugHeight.text == '') {
                        errorText3 = 'Жүк биіктігі міндетті';
                        setState(() {});
                        return null;
                      } else {
                        errorText3 = null;
                      }
                      if (lugWidth.text == '') {
                        errorText4 = 'Жүк ені міндетті';
                        setState(() {});
                        return null;
                      } else {
                        errorText4 = null;
                      }
                      if (lugDepth.text == '') {
                        errorText5 = 'Жүк ұзындығы міндетті';
                        setState(() {});
                        return null;
                      } else {
                        errorText5 = null;
                      }
                      if (selectedPlaceA == null) {
                        adressErrorText1 = 'Адресс міндетті';
                        setState(() {});
                        return null;
                      } else {
                        adressErrorText1 = null;
                      }
                      if (selectedPlaceB == null) {
                        adressErrorText2 = 'Адресс міндетті';
                        setState(() {});
                        return null;
                      } else {
                        adressErrorText2 = null;
                      }
                      if (tripDate.text == '') {
                        isDateSelected = true;
                        setState(() {});
                        return null;
                      } else {
                        isDateSelected = false;
                      }
                      if (bookerOfferPrice.text == '') {
                        isPriceGiven = true;
                        setState(() {});
                        return null;
                      } else {
                        isPriceGiven = false;
                      }
                      if (cur_id == '0') {
                        CurencySelected = true;
                        setState(() {});
                        return null;
                      } else {
                        CurencySelected = false;
                      }
                      if (isCarTypeSelected == null || !isCarTypeSelected!) {
                        isCarTypeSelected = false;
                        setState(() {});
                        return null;
                      } else {
                        isCarTypeSelected = true;
                      }
                      var countryA = selectedPlaceA!.addressComponents!
                          .where((e) => e.types.first == 'country')
                          .first
                          .longName;
                      var cityA = selectedPlaceA!.addressComponents!
                          .where((e) => e.types.first == 'locality')
                          .first
                          .longName;

                      var countryB = selectedPlaceB!.addressComponents!
                          .where((e) => e.types.first == 'country')
                          .first
                          .longName;
                      var cityB = selectedPlaceB!.addressComponents!
                          .where((e) => e.types.first == 'locality')
                          .first
                          .longName;

                      dynamic data = {
                        "orderName": orderName.text,
                        "orderStatus": 0,
                        "isDanger": _isdanger ? 1 : 0, //0 кауыпсыз 1 кауыпты
                        "isAdd": _isdogruz ? 1 : 0, //0 догруз да нет 1 кауыпты

                        "beginCountryName": countryA,
                        "beginCityName": cityA,
                        "beginPoint":
                            '${selectedPlaceA?.geometry?.location.lat},${selectedPlaceA?.geometry?.location.lng}',
                        "beginPointName": selectedPlaceA?.formattedAddress,

                        "endCountryName": countryB,
                        "endCityName": cityB,
                        "endPoint":
                            '${selectedPlaceB?.geometry?.location.lat},${selectedPlaceB?.geometry?.location.lng}',
                        "endPointName": selectedPlaceB?.formattedAddress,

                        "carTypeId": int.parse(carTypeId.text), //1 тент 2 холод
                        "bookerOfferPrice": double.parse(
                            bookerOfferPrice.text.replaceAll(" ", "")), //багасы
                        "currencyId": cur_id,
                        "finalPrice": 0.0,
                        "tripDate": tripDate.text,
                        "lugHeight": double.parse(lugHeight.text),
                        "lugWidth": double.parse(lugWidth.text),
                        "lugDepth": double.parse(lugDepth.text),
                        "lugWeight": double.parse(lugWeigth.text),
                        "lugSize": 0,
                        "sysUserType": int.parse(pm.sysUserType)
                      };

                      print(data);

                      CreateNewOrder(
                        token: pm.token,
                        jdata: data,
                      ).CreateOrderClient().then(
                        (value) {
                          print('Response: $value');

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

                          // if (value != 'error') {}
                        },
                      );

                      setState(() {
                        // final fn = fName.text;
                        // final ln = lName.text;
                        // final em = eMail.text;
                        // final iint = iin.text;
                        // if (fn.isEmpty ||
                        //     ln.isEmpty ||
                        //     iint.isEmpty ||
                        //     em.isEmpty) {
                        //   isEmpWidget = 'Должны быть заполнены все поля с *';
                        // }
                        // if (em.isNotEmpty && !em.contains("@")) {
                        //   isEmpWidget = 'не правильный email';
                        // }
                        // if (iint.isNotEmpty && iint.length <= 11) {
                        //   isEmpWidget = 'не правильный ИИН';
                        // }

                        // if (isChecked1) {
                        //   // Navigator.push(
                        //   //   context,
                        //   //   MaterialPageRoute(
                        //   //       builder: (context) => RegisterStep1View()),
                        //   // );
                        // } else if (isChecked2) {
                        //   // Navigator.push(
                        //   //   context,
                        //   //   MaterialPageRoute(
                        //   //       builder: (context) => RegisterStep1View()),
                        //   // );
                        // }
                      });
                    },
                    child: Text(AppLocalizations.of(context)!.sozdatZakaz),
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

  Padding selectAdress(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TextField(
            minLines: 1,
            maxLines: 5, // allow user to enter 5 line in textfield
            keyboardType: TextInputType.multiline,
            controller: selectPlaceA,
            decoration: InputDecoration(
              errorText: adressErrorText1,
              isDense: true,
              fillColor: provider.selectedThemeMode == ThemeMode.dark
                  ? Color.fromRGBO(53, 54, 61, 1)
                  : Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(228, 232, 250, 1)),
              ),
              labelText: AppLocalizations.of(context)!.from,
              suffixIcon: Icon(Icons.done),
              prefixIcon: Icon(Icons.circle, size: 15, color: Colors.red),
            ),
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
                        selectedPlaceA = result;
                        selectPlaceA.text =
                            selectedPlaceA?.formattedAddress as String;

                        Navigator.of(context).pop();
                        setState(() {});
                      },
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(height: 10),
          TextField(
            minLines: 1,
            maxLines: 4, // allow user to enter 5 line in textfield
            keyboardType: TextInputType.multiline,
            controller: selectPlaceB,
            decoration: InputDecoration(
              errorText: adressErrorText2,
              isDense: true,
              fillColor: provider.selectedThemeMode == ThemeMode.dark
                  ? Color.fromRGBO(53, 54, 61, 1)
                  : Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(228, 232, 250, 1)),
              ),
              labelText: AppLocalizations.of(context)!.to,
              suffixIcon: Icon(Icons.done),
              prefixIcon: Icon(Icons.circle, size: 15, color: Colors.black),
            ),
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
                        selectedPlaceB = result;
                        selectPlaceB.text =
                            selectedPlaceB?.formattedAddress as String;

                        Navigator.of(context).pop();
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
    );
  }
}

class RouteView extends StatelessWidget {
  const RouteView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.pokazatMarshrut,
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Center(),
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
          color: AppColors.primaryColors[0],
          onPressed: () async {
            Navigator.of(context).pop(); //закрывает уведомление
            Navigator.of(context).pop(); //закрывает доставку
            Navigator.of(context).pop(); //закрывает тип доставки
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewCurrentOrders(),
              ),
            );
          },
          child: Text(
            AppLocalizations.of(context)!.prodolzhit,
            style: TextStyle(fontSize: 20, color: Colors.white),
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
          color: AppColors.primaryColors[0],
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppLocalizations.of(context)!.prodolzhit,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        )
      ]).show();
}
