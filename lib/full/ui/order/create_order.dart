import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';

class CreateOrderView extends StatefulWidget {
  CreateOrderView({
    Key? key,
  }) : super(key: key);

  @override
  _CreateOrderViewState createState() => _CreateOrderViewState();
}

class _CreateOrderViewState extends State<CreateOrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Создание заказа',
          style: TextStyle(
            // color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: MyStatefulWidget(),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool isChecked1 = true;
  bool isChecked2 = false;

  bool isAdd1 = true;
  bool isAdd2 = false;

  String isEmpWidget = '';

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

  dropDown() {
    final sugars = ['Тент', 'Холодильник'];
    String? _currentSugars = 'Тент';
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
        carTypeId.text =
            (sugars.indexOf(_currentSugars.toString()) + 1).toString();
      }),
    );
  }

  dropDownPayment() {
    final sugars = ['Наличный', 'Без наличный'];
    String? _currentSugars = 'Наличный';
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
        paymentType.text =
            (sugars.indexOf(_currentSugars.toString()) + 1).toString();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    final textStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.blueGrey,
    );
    final textFieldDecorator = const InputDecoration(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1)),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        isCollapsed: true);

    final pm = ProfileModel();
    pm.setupLocale(context);

    return SingleChildScrollView(
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
                  SizedBox(height: 5),
                  Text('Описание груза *', style: textStyle),
                  SizedBox(height: 5),
                  TextField(
                    decoration: textFieldDecorator,
                    controller: orderName,
                    // inputFormatters: <TextInputFormatter>[
                    //   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    // ],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  Text('Вес груза(тонна) *', style: textStyle),
                  SizedBox(height: 5),
                  TextField(
                    controller: lugWeigth,
                    decoration: textFieldDecorator,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  Text('Объем(м3)', style: textStyle),
                  SizedBox(height: 5),
                  TextField(
                    controller: lugSize,
                    decoration: textFieldDecorator,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  Text('Опасный груз ', style: textStyle),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        shape: CircleBorder(),
                        value: isChecked1,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked1 = value!;
                            isChecked2 = false;
                            isDanger = isChecked1;
                            // notCkecked = '';
                            // print(isChecked2);
                          });
                        },
                      ),
                      Text('Да', style: textStyle),
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        shape: CircleBorder(),
                        value: isChecked2,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked2 = value!;
                            isChecked1 = false;
                            isDanger = isChecked2;
                            // notCkecked = '';
                            // print(isChecked2);
                          });
                        },
                      ),
                      Text('Нет', style: textStyle),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text('Догруз ', style: textStyle),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        shape: CircleBorder(),
                        value: isAdd1,
                        onChanged: (bool? value) {
                          setState(() {
                            isAdd1 = value!;
                            isAdd2 = false;
                            isAdd = isAdd1;
                            // notCkecked = '';
                            // print(isChecked2);
                          });
                        },
                      ),
                      Text('Да', style: textStyle),
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        shape: CircleBorder(),
                        value: isAdd2,
                        onChanged: (bool? value) {
                          setState(() {
                            isAdd2 = value!;
                            isAdd1 = false;
                            isAdd = isAdd2;
                            // notCkecked = '';
                            // print(isChecked2);
                          });
                        },
                      ),
                      Text('Нет', style: textStyle),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text('Тип транспорта', style: textStyle),
                  SizedBox(height: 5),
                  dropDown(),
                  SizedBox(height: 5),
                ],
              ),
            ),
            Text(
              'Маршрут',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 5),
            Column(
              children: [
                // selectedPlaceB == null ? Container() : Text(selectedPlaceB?.formattedAddress ?? ""),
                getRouteData1(),
                Divider(color: Colors.grey, height: 10),
                getRouteData2(),

                OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ImgView()),
                      );
                    },
                    child: Text('Map')),
                // Card(
                //   elevation: 5,
                //   child: Padding(
                //     padding: EdgeInsets.all(10.0),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: <Widget>[
                //         Row(
                //           children: [
                //             Text(
                //               ' A',
                //               style: TextStyle(
                //                 fontSize: 14.0,
                //                 color: Colors.grey,
                //               ),
                //             ),
                //             SizedBox(width: 10.0),
                //             Text(
                //               // filteredData[index].email.toLowerCase(),
                //               'Улы дала 12, Нур-Султан',
                //               style: TextStyle(
                //                 fontSize: 14.0,
                //                 color: Colors.black,
                //               ),
                //               maxLines: 1,
                //               overflow: TextOverflow.fade,
                //             ),
                //           ],
                //         ),
                //         Divider(
                //           color: Colors.grey,
                //           height: 10,
                //         ),
                //         //машрут точка Б
                //         Row(
                //           children: [
                //             Text(
                //               ' B',
                //               style: TextStyle(
                //                 fontSize: 14.0,
                //                 color: Colors.grey,
                //               ),
                //             ),
                //             SizedBox(width: 10.0),
                //             Text(
                //               // filteredData[index].email.toLowerCase(),
                //               'Улы дала 12, Нур-Султан',
                //               style: TextStyle(
                //                 fontSize: 14.0,
                //                 color: Colors.black,
                //               ),
                //               maxLines: 1,
                //               overflow: TextOverflow.fade,
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                SizedBox(height: 5),

                Text(
                  'Рекомендуемая цена: 120 000 тг',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  '*Сумма может отличаться от рекомендуемой цены',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
            Text(
              'Дата',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Выберите дату *',
                        style: textStyle,
                      ),
                      OutlinedButton(
                        onPressed: () => showPicker(context),
                        child: Text('Выбрать дату'),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  TextField(
                    decoration: textFieldDecorator,
                    controller: tripDate,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    textInputAction: TextInputAction.next,
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
                  Text('Сумма оплаты', style: textStyle),
                  SizedBox(height: 5),
                  TextField(
                    decoration: textFieldDecorator,
                    controller: bookerOfferPrice,
                    // inputFormatters: <TextInputFormatter>[
                    //   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    // ],
                    textInputAction: TextInputAction.done,
                  ),
                  // SizedBox(height: 5),
                  // Text('Тип оплаты', style: textStyle),
                  // dropDownPayment(),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 20)),
                  onPressed: () {
                    print('Creating order==>');

                    dynamic data = {
                      "orderName": orderName.text,
                      "orderStatus": 0,
                      "isDanger": isChecked1 ? 1 : 0, //0 каусыз 1 кауыпты
                      "isAdd": isAdd1 ? 1 : 0, //0 догруз да нет 1 кауыпты
                      "beginPoint": beginPoint.text,
                      "beginPointName": beginPointName.text,
                      "endPoint": endPoint.text,
                      "endPointName": endPointName.text,
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
    );
  }
}

class ImgView extends StatelessWidget {
  const ImgView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map',
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
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Продолжить",
            style: TextStyle(fontSize: 20),
          ),
        )
      ]).show();
}
