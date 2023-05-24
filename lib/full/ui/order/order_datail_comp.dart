import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:themoviedb/Theme/app_colors.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_list/Current/newCurrentOrder.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/Settings_page.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/my_cars.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';

import 'google_route.dart';

class OrderDatailView extends StatefulWidget {
  final dynamic jdata;
  final dynamic myDrivers;
  final dynamic myCars;
  OrderDatailView({
    Key? key,
    required this.jdata,
    required this.myDrivers,
    required this.myCars,
  }) : super(key: key);

  @override
  _OrderDatailViewState createState() => _OrderDatailViewState();
}

class _OrderDatailViewState extends State<OrderDatailView> {
  @override
  Widget build(BuildContext context) {
    // print(widget.jdata);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Детали груза',
          style: TextStyle(
            // color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: MyStatefulWidget(
          jdata: widget.jdata,
          myDrivers: widget.myDrivers,
          myCars: widget.myCars,
        ),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  final dynamic jdata;
  final dynamic myDrivers;
  final dynamic myCars;
  MyStatefulWidget({
    Key? key,
    required this.jdata,
    required this.myDrivers,
    required this.myCars,
  }) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState(
        jdata: jdata,
        myCars: myCars,
        myDrivers: myDrivers,
      );
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  dynamic jdata = [];
  dynamic myDrivers = [];
  dynamic myCars = [];
  _MyStatefulWidgetState({
    required this.jdata,
    required this.myDrivers,
    required this.myCars,
  });

  int orderId = -1;
  int driverId = -1;
  int carId = -1;
  int offerPrice = -1;

  dropDown1() {
    List<String> drivers = [];
    String testD = '';
    for (var item in myDrivers) {
      var value = '${item['firstName']} ${item['lastName']} ${item['iin']}';
      drivers.add(value);
      testD = value;
    }

    final sugars = drivers;
    String? _currentSugars = testD;
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
        int ind = sugars.indexOf(_currentSugars.toString());
        print(ind);
        print(myDrivers[ind]['clientId']);
        driverId = myDrivers[ind]['clientId'];
      }),
    );
  }

  dropDown2() {
    List<String> cars = [];
    String testD = '';
    for (var item in myCars) {
      var value =
          '${item['carTypeNameRu']} ${item['brandNameRu']} ${item['modelNameRu']} ${item['modelYear']} ${item['carNumber']}';
      cars.add(value);
      testD = value;
    }

    final sugars = cars;
    String? _currentSugars = testD;
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
              fontSize: 13,
              color: Colors.blueGrey,
            ),
          ),
        );
      }).toList(),
      onChanged: (val) => setState(() {
        _currentSugars = val;
        print(_currentSugars);
        int ind = sugars.indexOf(_currentSugars.toString());
        print(ind);
        print(myCars[ind]['carId']);
        carId = myCars[ind]['carId'];
      }),
    );
  }

  bool isChecked1 = true;
  bool isChecked2 = true;
  String isEmpWidget = '';
  TextEditingController offerPriceField = TextEditingController();

  final pm = ProfileModel();
  var carTypeTxt = '';

  TextEditingController lugHeight = TextEditingController();
  TextEditingController lugWidth = TextEditingController();
  TextEditingController lugDepth = TextEditingController();

  TextEditingController lugDesk = TextEditingController();
  TextEditingController lugWeigth = TextEditingController();
  TextEditingController lugKub = TextEditingController();
  TextEditingController carT = TextEditingController();
  TextEditingController lugDate = TextEditingController();
  TextEditingController money = TextEditingController();

  @override
  void initState() {
    super.initState();
    var data = widget.jdata;
    var formatted = data['tripDate'];

    //Сохраняем номер заказаы
    orderId = data['orderId'];
    driverId = myDrivers[0]['clientId'];
    carId = myCars[0]['carId'];
    offerPrice = data['bookerOfferPrice'];

    lugHeight = TextEditingController(text: data['lugHeight'].toString());
    lugWidth = TextEditingController(text: data['lugWidth'].toString());
    lugDepth = TextEditingController(text: data['lugDepth'].toString());

    lugDesk = TextEditingController(text: data['orderName']);
    lugWeigth = TextEditingController(text: data['lugWeight'].toString());
    lugKub = TextEditingController(text: data['lugSize'].toString());
    carT = TextEditingController(text: carTypeTxt);
    lugDate = TextEditingController(text: formatted);
    money = TextEditingController(text: "${data['bookerOfferPrice']} тг");

    int carType = data['carTypeId'];

    pm.setupLocale(context).then((value) {
      print(pm.token);
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
            var CarTypeDet = CarTypeDetail.fromJson(parsedJson);
            var carTypeName = CarTypeDet.carTypes
                .where((element) => element.carTypeId == carType);
            setState(() {
              carTypeTxt = carTypeName.first.nameRu;
            });
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.jdata);

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

    var coord1 = widget.jdata['beginPoint'].toString().split(",");
    var coord2 = widget.jdata['endPoint'].toString().split(",");
    int orderStatusId = widget.jdata['orderStatus'];

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
                  Text(
                    'Описание груза *',
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    maxLines: 4,
                    enabled: false,
                    decoration: textFieldDecorator,
                    controller: lugDesk,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Вес груза(тонна) *',
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    enabled: false,
                    controller: lugWeigth,
                    decoration: textFieldDecorator,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Объем(м3)',
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    enabled: false,
                    controller: lugKub,
                    decoration: textFieldDecorator,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Высота(м)',
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    enabled: false,
                    controller: lugHeight,
                    decoration: textFieldDecorator,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Длина(м)',
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    enabled: false,
                    controller: lugDepth,
                    decoration: textFieldDecorator,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Ширина(м)',
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    enabled: false,
                    controller: lugWidth,
                    decoration: textFieldDecorator,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  SizedBox(height: 5),
                  Text(
                    'Опасный груз ',
                    style: textStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        shape: CircleBorder(),
                        value: isChecked2,
                        onChanged: (bool? value) {
                          // setState(() {
                          //   isChecked2 = value!;
                          //   isChecked1 = false;
                          //   // notCkecked = '';
                          //   // print(isChecked2);
                          // });
                        },
                      ),
                      widget.jdata['isDanger'] == 1
                          ? Text('да', style: textStyle)
                          : Text('Нет', style: textStyle),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Догруз ',
                    style: textStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        shape: CircleBorder(),
                        value: isChecked2,
                        onChanged: (bool? value) {
                          // setState(() {
                          //   isChecked2 = value!;
                          //   isChecked1 = false;
                          //   // notCkecked = '';
                          //   // print(isChecked2);
                          // });
                        },
                      ),
                      widget.jdata['isAdd'] == 1
                          ? Text('да', style: textStyle)
                          : Text('Нет', style: textStyle),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Тип транспорта',
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    enabled: false,
                    controller: carT,
                    decoration: textFieldDecorator,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
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
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              ' A',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Container(
                              width: 250.0,
                              child: Text(
                                // filteredData[index].email.toLowerCase(),
                                widget.jdata['beginPointName'],
                                style: TextStyle(
                                  fontSize: 14.0,
                                  // color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 10,
                        ),
                        //машрут точка Б
                        Row(
                          children: [
                            Text(
                              ' B',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Container(
                              width: 250.0,
                              child: Text(
                                // filteredData[index].email.toLowerCase(),
                                widget.jdata['endPointName'],
                                style: TextStyle(
                                  fontSize: 14.0,
                                  // color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),

                        // SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapPage(
                                        coord1: coord1,
                                        coord2: coord2,
                                        orderStatusId: orderStatusId,
                                        carId: carId,
                                      ),
                                    ),
                                  );
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.location_on),
                                  const Text('Маршут',
                                      style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Грузоотправитель',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 5),
            Column(
              children: [
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.start, //горизонтально
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // вертикально
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: Image.asset(
                                          'images/Portrait_Placeholder.png',
                                          fit: BoxFit.cover)
                                      .image,
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${widget.jdata['creator']['lastName']} ${widget.jdata['creator']['firstName']}',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rounded,
                                          color: AppColors.mainOrange,
                                          size: 13,
                                        ),
                                        Text(
                                          '5.0',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
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
                  TextField(
                    enabled: false,
                    decoration: textFieldDecorator,
                    controller: lugDate,
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
                  Text(
                    'Сумма клиента',
                    style: textStyle,
                  ),
                  TextField(
                    enabled: false,
                    decoration: textFieldDecorator,
                    controller: money,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Ваше предложение цены',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.deepOrange,
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
                  Text(
                    'Ваша сумма',
                    style: textStyle,
                  ),
                  TextField(
                    decoration: textFieldDecorator,
                    controller: offerPriceField,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Водитель',
                    style: textStyle,
                  ),
                  dropDown1(),
                  SizedBox(height: 20),
                  Text(
                    'Авто',
                    style: textStyle,
                  ),
                  dropDown2(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 70, vertical: 20)),
                    onPressed: () {
                      showLoadingIndicator(context);

                      offerPrice = offerPriceField.text != ''
                          ? int.parse(offerPriceField.text)
                          : widget.jdata['bookerOfferPrice'];
                      print(orderId);
                      print(driverId);
                      print(carId);
                      print(offerPrice);

                      dynamic orderData = {
                        "orderId": orderId,
                        "driverId": driverId,
                        "carId": carId,
                        "offerPrice": offerPrice
                      };

                      SendOrderRequest(
                        token: pm.token.toString(),
                        jdata: orderData,
                      ).send().then(
                        (value) {
                          hideOpenDialog(context);

                          if (value.toString() == '401') {
                            final provider = SessionDataProvider();
                            provider.setSessionId(null);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                MainNavigationRouteNames.changeLang,
                                (Route<dynamic> route) => false);
                          }

                          if (value.contains('Error')) {
                            errorMsg(context);
                          } else {
                            sucsessMsg(context);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewCurrentOrders(),
                              ),
                            );
                          }
                        },
                      );

                      hideOpenDialog(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Предложить услугу',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<dynamic> warningMsg(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.black54,
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 40,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Вы не можете принять заказ, так как, вы не завершили последний заказ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<dynamic> sucsessMsg(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.black54,
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 40,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Заявка успешно отправлена",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<dynamic> errorMsg(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.black54,
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 40,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Повторите попытку",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
