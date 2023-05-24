import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_list/Current/newCurrentOrder.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/Settings_page.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/my_cars.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../ui/widgets/app/my_app.dart';
import 'Select_order_type_page.dart';

class DriverDatailCardView extends StatefulWidget {
  final dynamic jdata;
  final dynamic myDrivers;
  final dynamic myCars;
  DriverDatailCardView({
    Key? key,
    required this.jdata,
    required this.myDrivers,
    required this.myCars,
  }) : super(key: key);

  @override
  _DriverDatailCardViewState createState() => _DriverDatailCardViewState();
}

class _DriverDatailCardViewState extends State<DriverDatailCardView> {
  @override
  Widget build(BuildContext context) {
    // print(widget.jdata);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.dannyePerevozki,
          style: TextStyle(
            // color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: MyStatefulWidget(
        jdata: widget.jdata,
        myDrivers: widget.myDrivers,
        myCars: widget.myCars,
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
  final dynamic jdata;
  final dynamic myDrivers;
  final dynamic myCars;
  _MyStatefulWidgetState({
    required this.jdata,
    required this.myDrivers,
    required this.myCars,
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

  bool load = true;
  List myOrdersData = [];

  @override
  void initState() {
    super.initState();

    var data = widget.jdata;
    int carType = data['carTypeId'];

    pm.setupLocale(context).then(
      (value) {
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
        GetMyOrderList(
          token: pm.token.toString(),
        ).getListClient().then(
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
                myOrdersData = docs;

                myOrdersData = myOrdersData
                    .where((element) => element['orderStatus'] < 3)
                    .toList();

                load = false;
              });
            } else {
              print('Не удалось получить список моих заказов');
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.jdata);

    final pm = ProfileModel();
    pm.setupLocale(context);

    var data = widget.jdata;

    //Сохраняем номер заказаы
    orderId = data['orderId'];
    // driverId = myDrivers[0]['clientId'];
    driverId = 1;
    // carId = myCars[0]['carId'];
    carId = 1;
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

    return Stack(
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black38,
                  width: 1,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: Colors.black38,
              ),
              // color: AppColors.mainDarkBlue,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.gruzPerevoz,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        // color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Card(
                      elevation: 10,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 280,
                                      child: Text(
                                        // formatted,
                                        data['beginPointName'],
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                          // color: Colors.black87,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 280,
                                      child: Text(
                                        // formatted,
                                        data['endPointName'],
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.normal,
                                          // color: Colors.grey,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      // formatted,
                                      "${NumberFormat("#,##0", "pt_BR").format(data['bookerOfferPrice'])} ${data['currencyIcon']}",
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      formatted,
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.normal,
                                        // color: Colors.grey,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['creator']['orderInChargeName'],
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.normal,
                                            // color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          " ",
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.normal,
                                            // color: Colors.black,
                                          ),
                                        ),
                                        Icon(
                                          Icons.star_rounded,
                                          color: Colors.orange,
                                          size: 13,
                                        ),
                                        Text(
                                          '5.0',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.normal,
                                            // color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '${data['car']['carTypeNameRu']} ${data['car']['carWeight']}T   ' +
                                          '${data['car']['carNumber']}'
                                              .toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        // color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      '${data['car']['brandNameRu']} ${data['car']['modelNameRu']} ${data['car']['modelYear']}'
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.italic,
                                        // color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.vyberiteSvoiGruzIliSozdaite,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        // color: Colors.white,
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              // Navigator.of(context).pop();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return SelectOrderType();
                                  },
                                ),
                              );
                            },
                            icon: Icon(Icons.add_box),
                            label: Text(
                                AppLocalizations.of(context)!.sozdatNewZakaz),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            load ? LoadingData() : myOrders(),
          ],
        )
      ],
    );
  }

  Expanded myOrders() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        itemCount: myOrdersData.length,
        itemBuilder: (BuildContext context, int index) {
          var formatted = myOrdersData[index]['tripDate'];

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

          // int carType = myOrdersData[index]['carTypeId'];
          // final sugars = ['Тент', 'Холодильник'];

          return Card(
            elevation: 10,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Багасы
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${NumberFormat("#,##0", "pt_BR").format(myOrdersData[index]['bookerOfferPrice'])} ${myOrdersData[index]['currencyIcon']}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          // color: Colors.grey,
                        ),
                      ),
                      Text(
                        '',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          // color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //дата заказа
                      Padding(
                        padding: EdgeInsets.only(),
                        child: ButtonTheme(
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_sharp,
                                size: 14,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                // filteredData[index].name,
                                formatted.toString(),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  // color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //Тонна
                      Container(
                        child: Text(
                          ' ${myOrdersData[index]['lugWeight']}T ',
                          style: TextStyle(
                            fontSize: 14.0,
                            // color: Colors.grey,
                            // fontWeight: FontWeight.bold,
                            // backgroundColor: Colors.grey,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // color: Colors.white,
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          // boxShadow: [
                          //   BoxShadow(
                          //     // color: Colors.grey,
                          //     spreadRadius: 1,
                          //   ),
                          // ],
                        ),
                        // height: 50,
                      ),
                    ],
                  ),
                  // SizedBox(height: 5.0),
                  Divider(
                    color: Colors.grey,
                    height: 10,
                  ),
                  //машрут точка А
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(80, 155, 213, 1).withOpacity(0.1),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Image.asset("images/ZakazAB.png", height: 70),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.zabrat,
                                        style: TextStyle(
                                            color: AppColors.primaryColors[3],
                                            fontSize: 12,
                                            letterSpacing: 0.3,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${myOrdersData[index]['beginPointName']}',
                                        style: TextStyle(
                                            // color: AppColors
                                            //     .primaryColors[0],
                                            fontSize: 15,
                                            letterSpacing: 0.3,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        AppLocalizations.of(context)!.dostavit,
                                        style: TextStyle(
                                            color: AppColors.primaryColors[3],
                                            fontSize: 12,
                                            letterSpacing: 0.3,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${myOrdersData[index]['endPointName']}',
                                        style: TextStyle(
                                            // color: AppColors
                                            //     .primaryColors[0],
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
                  Divider(
                    color: Colors.grey,
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.comment,
                        size: 14,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        myOrdersData[index]['orderName'],
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 14.0,
                          // color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _onAlertWithCustomContentPressed(
                              context, pm, myOrdersData[index], widget.jdata);
                        },
                        child: Text(AppLocalizations.of(context)!.select),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
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
                SizedBox(height: 50),
                Text(
                  AppLocalizations.of(context)!.zagruzkaDannyh,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54),
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

  Text noOrders() {
    return Text(
      AppLocalizations.of(context)!.netDannyh,
      style: TextStyle(
        fontSize: 13.0,
        // fontWeight: FontWeight.bold,
        color: Colors.black54,
      ),
    );
  }
}

// _onBasicAlertPressed(context, ProfileModel pm, myOrdersData, jdata) {
//   var alertStyle = AlertStyle(
//       animationType: AnimationType.fromTop,
//       isCloseButton: true,
//       isOverlayTapDismiss: true,
//       descStyle: TextStyle(
//         fontWeight: FontWeight.normal,
//         fontSize: 16,
//       ),
//       animationDuration: Duration(milliseconds: 250),
//       alertBorder: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//         side: BorderSide(
//           color: Colors.grey,
//         ),
//       ),
//       titleStyle: TextStyle(
//         color: Colors.red,
//       ));
//   Alert(
//       context: context,
//       style: alertStyle,
//       // title: "RFLUTTER ALERT",
//       desc: "Вы действительно хотите отправить предложение?",
//       buttons: [
//         DialogButton(
//           onPressed: () {
//             hideOpenDialog(context);
//           },
//           child: Text(
//             "Нет",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           color: Colors.red,
//         ),
//         DialogButton(
//           onPressed: () {
//             hideOpenDialog(context);

//             // _onAlertWithCustomContentPressed(context);

//             // MakeOfferToDriver(
//             //   token: pm.token.toString(),
//             //   clientOrderId: myOrdersData['orderId'],
//             //   driverOrderId: jdata['orderId'],
//             //   driverType: jdata['sysUserType'],
//             //   offerPrice:
//             //       double.parse(myOrdersData['bookerOfferPrice'].toString()),
//             // ).sendData().then(
//             //   (value) {
//             //     if (value.toString() == '401') {
//             //       final provider = SessionDataProvider();
//             //       provider.setSessionId(null);
//             //       Navigator.of(context).pushNamedAndRemoveUntil(
//             //           MainNavigationRouteNames.changeLang,
//             //           (Route<dynamic> route) => false);
//             //     }

//             //     if (value.contains('already made offer')) {
//             //       _AlertAlredy(context);
//             //     } else if (value != 'error') {
//             //       _AlertContinue(context);
//             //     } else {
//             //       _AlertError(context);
//             //       print('Не удалось получить список моих заказов');
//             //     }
//             //   },
//             // );
//           },
//           child: Text(
//             "Да",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           color: Colors.green,
//         )
//       ]).show();
// }

_onAlertWithCustomContentPressed(
    context, ProfileModel pm, myOrdersData, jdata) {
  var price =
      TextEditingController(text: myOrdersData['bookerOfferPrice'].toString());
  var _validate = false;
  Alert(
    context: context,
    title: AppLocalizations.of(context)!.vashePredlozhenie,
    content: Column(
      children: <Widget>[
        TextField(
          controller: price,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            icon: Icon(Icons.money),
            labelText: AppLocalizations.of(context)!.vashaCena,
            errorText: _validate ? 'Цена должна быть заполненной' : null,
          ),
        ),
      ],
    ),
    buttons: [
      DialogButton(
        onPressed: () {
          print(price.text);
          if (price.text != "") {
            MakeOfferToDriver(
              token: pm.token.toString(),
              clientOrderId: myOrdersData['orderId'],
              driverOrderId: jdata['orderId'],
              driverType: jdata['sysUserType'],
              offerPrice: double.parse(price.text),
            ).sendData().then(
              (value) {
                if (value.toString() == '401') {
                  final provider = SessionDataProvider();
                  provider.setSessionId(null);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      MainNavigationRouteNames.changeLang,
                      (Route<dynamic> route) => false);
                }

                if (value.contains('already made offer')) {
                  _AlertAlredy(context);
                } else if (value != 'error') {
                  _AlertContinue(context);
                } else {
                  _AlertError(context);
                  print('Не удалось получить список моих заказов');
                }
              },
            );
          }
        },
        child: Text(AppLocalizations.of(context)!.predlozhitCenu,
            style: TextStyle(fontSize: 20)),
      )
    ],
  ).show();
}

_AlertContinue(context) {
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
      desc: AppLocalizations.of(context)!.predlozhenieOtpravleno,
      buttons: [
        DialogButton(
          onPressed: () {
            hideOpenDialog(context);
            hideOpenDialog(context);
            hideOpenDialog(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewCurrentOrders(),
              ),
            );
          },
          child: Text(
            AppLocalizations.of(context)!.prodolzhit,
            style: TextStyle(fontSize: 20),
          ),
          color: Colors.green,
        )
      ]).show();
}

_AlertError(context) {
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
          onPressed: () {
            hideOpenDialog(context);
          },
          child: Text(
            AppLocalizations.of(context)!.prodolzhit,
            style: TextStyle(fontSize: 20),
          ),
          color: Colors.green,
        )
      ]).show();
}

_AlertAlredy(context) {
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
      desc: AppLocalizations.of(context)!.vyuzheOtpraviliCenu,
      buttons: [
        DialogButton(
          onPressed: () {
            hideOpenDialog(context);
            hideOpenDialog(context);
          },
          child: Text(
            AppLocalizations.of(context)!.prodolzhit,
            style: TextStyle(fontSize: 20),
          ),
          color: Colors.green,
        )
      ]).show();
}
