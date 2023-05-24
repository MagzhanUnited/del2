import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/Theme/app_colors.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_list/Current/newCurrentOrder.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/Settings_page.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/my_cars.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';

import 'google_route.dart';

class OrderDatailIndiView extends StatefulWidget {
  final dynamic jdata;
  final dynamic UserData;
  OrderDatailIndiView({
    Key? key,
    required this.jdata,
    required this.UserData,
  }) : super(key: key);

  @override
  _OrderDatailIndiViewState createState() => _OrderDatailIndiViewState();
}

class _OrderDatailIndiViewState extends State<OrderDatailIndiView> {
  @override
  Widget build(BuildContext context) {
    // print(widget.jdata);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.detaliGruza,
          style: TextStyle(
            // color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: MyStatefulWidget(
          jdata: widget.jdata,
          UserData: widget.UserData,
        ),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  final dynamic jdata;
  final dynamic UserData;
  MyStatefulWidget({
    Key? key,
    required this.jdata,
    required this.UserData,
  }) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState(
        jdata: jdata,
        UserData: UserData,
      );
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final dynamic jdata;
  final dynamic UserData;
  _MyStatefulWidgetState({
    required this.jdata,
    required this.UserData,
  });

  int orderId = -1;
  int driverId = -1;
  int carId = -1;
  int offerPrice = -1;

  bool isChecked1 = true;
  bool isChecked2 = true;
  String isEmpWidget = '';
  TextEditingController offerPriceField = TextEditingController();
  final pm = ProfileModel();
  var carTypeTxt = '';

  @override
  void initState() {
    super.initState();

    var data = widget.jdata;
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
    var data = widget.jdata;

    //Сохраняем номер заказаы
    orderId = data['orderId'];
    // driverId = myDrivers[0]['clientId'];
    // carId = myCars[0]['carId'];
    offerPrice = data['bookerOfferPrice'];

    var formatted = data['tripDate'];
    try {
      DateTime parseDate =
          new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(formatted);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('dd.MM.yyyy');
      var outputDate = outputFormat.format(inputDate);
      // print(outputDate);
      formatted = outputDate;
    } catch (e) {
      print('date parse error');
    }

    // int carType1 = data['carTypeId'];
    // final payType = ['Наличный', 'Без наличный'];

    final lugDesk = TextEditingController(text: data['orderName']);
    final lugWeigth = TextEditingController(text: data['lugWeight'].toString());
    final lugKub = TextEditingController(text: data['lugSize'].toString());
    final carT = TextEditingController(text: carTypeTxt);
    final lugDate = TextEditingController(text: formatted);
    final money = TextEditingController(text: "${data['bookerOfferPrice']} тг");

    // final cashType = TextEditingController(text: payType[carType1 - 1]);

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

    var coord1 = data['beginPoint'].toString().split(",");
    var coord2 = data['endPoint'].toString().split(",");
    int orderStatusId = data['orderStatus'];

    return SingleChildScrollView(
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
                  SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.opisanieGruz,
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
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
                    '${AppLocalizations.of(context)!.vesGruz}(${AppLocalizations.of(context)!.tonna})',
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
                    AppLocalizations.of(context)!.obem,
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
                    AppLocalizations.of(context)!.opasnuiGruz,
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
                      data['isDanger'] == 1
                          ? Text(AppLocalizations.of(context)!.yes,
                              style: textStyle)
                          : Text(AppLocalizations.of(context)!.no,
                              style: textStyle),
                    ],
                  ),
                  SizedBox(height: 5),
                  SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.dogruz,
                    style: textStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        shape: CircleBorder(),
                        value: data['isAdd'] == 1,
                        onChanged: (bool? value) {
                          // setState(() {
                          //   isChecked2 = value!;
                          //   isChecked1 = false;
                          //   // notCkecked = '';
                          //   // print(isChecked2);
                          // });
                        },
                      ),
                      data['isAdd'] == 1
                          ? Text(AppLocalizations.of(context)!.yes,
                              style: textStyle)
                          : Text(AppLocalizations.of(context)!.no,
                              style: textStyle),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.tipKuzova,
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
              AppLocalizations.of(context)!.marshrut,
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
                                data['beginPointName'],
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
                                data['endPointName'],
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
                                  Text(AppLocalizations.of(context)!.marshrut,
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
              AppLocalizations.of(context)!.gruzOtprav,
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
                                      '${data['creator']['lastName']} ${data['creator']['firstName']}',
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
              AppLocalizations.of(context)!.date,
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
              AppLocalizations.of(context)!.prise,
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
                    AppLocalizations.of(context)!.tsenaKlienta,
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
              AppLocalizations.of(context)!.vashePredlozhenie,
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
                    AppLocalizations.of(context)!.vashaCena,
                    style: textStyle,
                  ),
                  TextField(
                    decoration: textFieldDecorator,
                    controller: offerPriceField,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 20),
                  // Text(
                  //   'Водитель',
                  //   style: textStyle,
                  // ),
                  // dropDown1(),
                  // SizedBox(height: 20),
                  // Text(
                  //   'Авто',
                  //   style: textStyle,
                  // ),
                  // dropDown2(),
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
                          : data['bookerOfferPrice'];
                      carId = UserData['clientIndivisual']['car']['carId'];
                      driverId = UserData['clientIndivisual']['clientId'];
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

                          // print('Response: $value');
                          if (value.contains('NotCompletedOrder')) {
                            warningMsg(context);
                          } else if (value.contains('Error')) {
                            errorMsg(context);
                          } else {
                            sucsessMsg(context);
                            Navigator.of(context).pop();
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
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.predlozhitCenu,
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
                    AppLocalizations.of(context)!.vyNeMozheteOtpravZapYvasEstZakaz,
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
                    AppLocalizations.of(context)!.zayavkaUspeshOtpravlena,
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
                    AppLocalizations.of(context)!.povtoritePopitku2,
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
