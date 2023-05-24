import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'profile/profile_model.dart';

class RailwayCO extends StatefulWidget {
  @override
  _RailwayCOState createState() => _RailwayCOState();
}

class _RailwayCOState extends State<RailwayCO> {
  PickResult? selectedPlaceA;
  PickResult? selectedPlaceB;

  bool isChecked1 = true;
  bool isChecked2 = false;

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

  String _selectedDate = 'выбрать';
  bool _isdanger = false;
  bool _isdogruz = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2023),
    );
    if (d != null)
      setState(() {
        _selectedDate = new DateFormat('dd-MM-yyyy').format(d);
        tripDate.text = new DateFormat('dd-MM-yyyy').format(d);
      });
  }

  getRouteData1() {
    final sugars = [
      'Нур-Султан',
      'Алматы',
      'Атырау',
      'Актау',
      'Караганда',
      'Семей',
      'Тараз',
      'Шымкент'
    ];
    final coord = [
      '51.160522,71.470360',
      '43.222015,76.851250',
      '47.094498,51.923836',
      '43.66170605,51.1807854010264',
      '49.8161282,73.1026622',
      '50.405029,80.249176',
      '42.8943882,71.3920902',
      '42.3146962,69.5883282'
    ];
    String? _currentSugars = 'Нур-Султан';
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: _currentSugars,
      items: sugars.map((sugar) {
        return DropdownMenuItem(
          value: sugar,
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
      onChanged: (val) => setState(() {
        _currentSugars = val;
        print(_currentSugars);
        print(sugars.indexOf(_currentSugars.toString()));
        beginPoint.text = coord[sugars.indexOf(_currentSugars.toString())];
        beginPointName.text = _currentSugars.toString();
      }),
    );
  }

  getRouteData2() {
    final sugars = [
      'Нур-Султан',
      'Алматы',
      'Атырау',
      'Актау',
      'Караганда',
      'Семей',
      'Тараз',
      'Шымкент'
    ];
    final coord = [
      '51.160522,71.470360',
      '43.222015,76.851250',
      '47.094498,51.923836',
      '43.66170605,51.1807854010264',
      '49.8161282,73.1026622',
      '50.405029,80.249176',
      '42.8943882,71.3920902',
      '42.3146962,69.5883282'
    ];
    String? _currentSugars = 'Алматы';
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: _currentSugars,
      items: sugars.map((sugar) {
        return DropdownMenuItem(
          value: sugar,
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
      onChanged: (val) => setState(() {
        _currentSugars = val;
        print(_currentSugars);
        print(sugars.indexOf(_currentSugars.toString()));
        endPoint.text = coord[sugars.indexOf(_currentSugars.toString())];
        endPointName.text = _currentSugars.toString();
      }),
    );
  }

  dropDownVagonType() {
    final sugars = [
      'Открытый',
      'Полувагон',
      'Платформа',
      'Контейнер',
      'Цистерна',
      'Хоппер',
      'Рефрижератор',
    ];

    String? _currentSugars = 'Открытый';
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        border: const OutlineInputBorder(),
      ),
      isExpanded: true,
      value: _currentSugars,
      items: sugars.map((sugar) {
        return DropdownMenuItem(
          value: sugar,
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
      onChanged: (val) => setState(() {
        _currentSugars = val;
        print(_currentSugars);
        print(sugars.indexOf(_currentSugars.toString()));
        carTypeId.text =
            (sugars.indexOf(_currentSugars.toString()) + 1).toString();
      }),
    );
  }

  dropDownPayment() {
    final sugars = ['Наличный', 'Без наличный'];
    String? _currentSugars = 'Наличный';
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        border: const OutlineInputBorder(),
      ),
      isExpanded: true,
      value: _currentSugars,
      items: sugars.map((sugar) {
        return DropdownMenuItem(
          value: sugar,
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
      onChanged: (val) => setState(() {
        _currentSugars = val;
        print(_currentSugars);
        print(sugars.indexOf(_currentSugars.toString()));
        paymentType.text =
            (sugars.indexOf(_currentSugars.toString()) + 1).toString();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.blueGrey,
    );

    final pm = ProfileModel();
    pm.setupLocale(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Создание заказа - ЖД"),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Груз',
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
                        labelText: 'Описание груза *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: lugWeigth,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Вес груза(тонна) *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: lugSize,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Объем(м3)',
                        border: OutlineInputBorder(),
                      ),
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
                      subtitle: const Text(
                        'Комментарии',
                      ),
                      switchType: SwitchType.cupertino,
                      title: const Text(
                        'Опасный груз',
                      ),
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
                      subtitle: const Text(
                        'Комментарии',
                      ),
                      switchType: SwitchType.cupertino,
                      title: const Text(
                        'Догруз',
                      ),
                    ),

                    SizedBox(height: 5),
                    Text('Тип вагона', style: textStyle),
                    SizedBox(height: 5),
                    dropDownVagonType(),
                    SizedBox(height: 5),
                  ],
                ),
              ),

              Text(
                'Маршрут - код станции',
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
                  children: [
                    TextField(
                      minLines: 1,
                      maxLines: 5, // allow user to enter 5 line in textfield
                      keyboardType: TextInputType.multiline,
                      controller: selectPlaceA,
                      decoration: InputDecoration(
                        labelText: 'Отправление',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.done),
                        prefixIcon: Icon(
                          Icons.circle,
                          size: 15,
                          color: Colors.red,
                        ),
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
                                  selectedPlaceA = result;
                                  selectPlaceA.text = selectedPlaceA
                                      ?.formattedAddress as String;

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
                        labelText: 'Назначение',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.done),
                        prefixIcon: Icon(
                          Icons.circle,
                          size: 15,
                          color: Colors.black,
                        ),
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
                                  selectedPlaceB = result;
                                  selectPlaceB.text = selectedPlaceB
                                      ?.formattedAddress as String;

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
              ),

              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RouteView()),
                            );
                          },
                          child: Text('Показать маршрут'),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RouteView()),
                            );
                          },
                          child: Text('Рассчет суммы'),
                        ),
                      ],
                    ),
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
              Text(
                'Дата',
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
                          'Выберите дату *',
                          style: textStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        width: 0.5, color: Colors.grey),
                                    left: BorderSide(
                                        width: 0.5, color: Colors.grey),
                                    right: BorderSide(
                                        width: 0.5, color: Colors.grey),
                                    bottom: BorderSide(
                                        width: 0.5, color: Colors.grey),
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
                                        "   " + _selectedDate,
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
                                      tooltip: 'Выбрать дату',
                                      onPressed: () {
                                        _selectDate(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              Text(
                'Оплата',
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
                    TextFormField(
                      controller: bookerOfferPrice,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Сумма оплаты',
                        border: OutlineInputBorder(),
                      ),
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

                      dynamic data = {
                        "orderName": orderName.text,
                        "orderStatus": 0,
                        "isDanger": isChecked1 ? 1 : 0, //0 каусыз 1 кауыпты
                        "isAdd": isAdd1 ? 1 : 0, //0 догруз да нет 1 кауыпты
                        "beginPoint":
                            '${selectedPlaceA?.geometry?.location.lat},${selectedPlaceA?.geometry?.location.lng}',
                        "beginPointName": selectedPlaceA?.formattedAddress,
                        "endPoint":
                            '${selectedPlaceB?.geometry?.location.lat},${selectedPlaceB?.geometry?.location.lng}',
                        "endPointName": selectedPlaceB?.formattedAddress,
                        "carTypeId": int.parse(carTypeId.text), //1 тент 2 холод
                        "bookerOfferPrice":
                            double.parse(bookerOfferPrice.text), //багасы
                        "finalPrice": 0.0,
                        "tripDate": tripDate.text,
                        // "paymentType":
                        //     int.parse(paymentType.text), //1nal 2 beznal
                        "lugWeight": double.parse(lugWeigth.text),
                        "lugSize": double.parse(lugSize.text),
                        "sysUserType": int.parse(pm.sysUserType)
                      };

                      print(data);

                      CreateNewOrder(
                        token: pm.token,
                        jdata: data,
                      ).Create().then(
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
                    child: const Text('Создать заказ'),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );

    // return Scaffold(
    //     appBar: AppBar(
    //       title: Text("Создание заказа"),
    //     ),
    //     body: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: <Widget>[
    //           ElevatedButton(
    //             child: Text("Load Google Map"),
    //             onPressed: () {
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (context) {
    //                     return PlacePicker(
    //                       apiKey: 'AIzaSyAkUdrVbgXV_52Qrid_vdeqzTbBfmFxrNM',
    //                       initialPosition: LatLng(-33.8567844, 151.213108),
    //                       useCurrentLocation: true,
    //                       selectInitialPosition: true,
    //                       autocompleteLanguage: "ru",

    //                       //usePlaceDetailSearch: true,
    //                       onPlacePicked: (result) {
    //                         selectedPlace = result;
    //                         Navigator.of(context).pop();
    //                         setState(() {});
    //                       },
    //                     );
    //                   },
    //                 ),
    //               );
    //             },
    //           ),
    //           selectedPlace == null ? Container() : Text(selectedPlace?.formattedAddress ?? ""),
    //         ],
    //       ),
    //     ));
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
          'Показать маршрут',
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
      desc: "Заказ успешно создан!",
      buttons: [
        DialogButton(
          onPressed: () async {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: Text(
            "Продолжить",
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
      desc: "Повторите запрос",
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Продолжить",
            style: TextStyle(fontSize: 20),
          ),
        )
      ]).show();
}
