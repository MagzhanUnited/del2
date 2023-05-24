import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/order/order_datail_card.dart';
import 'package:themoviedb/full/ui/order/order_datail_card_driver.dart';
import 'package:themoviedb/full/ui/order/order_status.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'client_zibergen_menin_usunistarum.dart';

class MyCurrentOrders extends StatefulWidget {
  MyCurrentOrders({
    Key? key,
  }) : super(key: key);

  @override
  _MyCurrentOrdersState createState() => _MyCurrentOrdersState();
}

class _MyCurrentOrdersState extends State<MyCurrentOrders> {
  List data = []; //выпол
  List data2 = []; // новые
  List data3 = []; //заявки
  bool load = true;
  bool load2 = true;
  bool load3 = true;

  bool errorload = false;
  bool errorload2 = false;
  bool errorload3 = false;

  final pm = ProfileModel();

  bool pmLoad = true;
  bool pmLoadError = false;

  int carId = 0;

  bool _start = false;
  Timer? timer;

  @override
  void initState() {
    _start = false;
    socket = null;
    carId = 0;

    super.initState();

    pmLoad = true;
    pmLoadError = false;

    load = true;
    errorload = false;

    load2 = true;
    errorload2 = false;

    load3 = true;
    errorload3 = false;

    pm.setupLocale(context).then(
      (value) async {
        pmLoad = false;
        pmLoadError = false;

        if (pm.sysUserType == "3") {
          await GetCarId(
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
                print('GetCarId sucsess');

                try {
                  carId = int.parse(value);
                } catch (e) {
                  print('Ошибка при парсинге GetCarId');
                }
              } else {
                print('Не удалось получить GetCarId');
              }
              setState(() {});
            },
          );
        }

        if (pm.sysUserType == "1" || pm.sysUserType == "2") {
          await GetMyOrderList(
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
                  //выпол
                  data = docs;
                  load = false;
                  errorload = false;

                  //новые
                  data2 = docs;
                  load2 = false;
                  errorload2 = false;
                });
              } else {
                setState(() {
                  load = false;
                  errorload = true;

                  load2 = false;
                  errorload2 = true;
                });
                print('Не удалось получить список моих заказов');
              }
            },
          );

          await MyAdverListClient(
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
                  data3 = docs;
                  load3 = false;
                  errorload3 = false;
                });
              } else {
                setState(() {
                  load3 = false;
                  errorload3 = true;
                });
                print('Не удалось получить список заказов');
              }
            },
          );
        } else if (pm.sysUserType == "3" || pm.sysUserType == "4") {
          await DriverActiveOrders(
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
                  //выпол
                  data = docs;
                  load = false;
                  errorload = false;
                });
              } else {
                setState(() {
                  load = false;
                  errorload = true;
                });
                print('Не удалось получить список заказов');
              }
            },
          );
          await MyAdverListDriver(
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
                  //новые
                  data2 = docs;
                  load2 = false;
                  errorload2 = false;
                });
              } else {
                setState(() {
                  load2 = false;
                  errorload2 = true;
                });
                print('Не удалось получить список заказов');
              }
            },
          );

          await GetMyOrderList(
            token: pm.token.toString(),
          ).getMyZayavkiDriver().then(
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
                  data3 = docs;
                  load3 = false;
                  errorload3 = false;
                });
              } else {
                setState(() {
                  load3 = false;
                  errorload3 = true;
                });
                print('Не удалось получить список моих заказов');
              }
            },
          );
        } else {
          await DriverActiveOrders(
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
                  //выпол
                  data = docs;
                  load = false;
                  errorload = false;
                });
              } else {
                setState(() {
                  load = false;
                  errorload = true;
                });
                print('Не удалось получить список заказов');
              }
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Socket? socket = null;
  void main() async {
    try {
      if (socket == null) {
        socket = await Socket.connect('185.116.193.86', 8088);
        print(
            'Connected to: ${socket!.remoteAddress.address}:${socket!.remotePort}');
        socket!.listen(
          (Uint8List data) {
            final serverResponse = String.fromCharCodes(data);
            print('Server: $serverResponse');
          },

          onError: (error) {
            print(error);
            socket!.destroy();
            socket = null;
            setState(() {});
          },

          // handle server ending connection
          onDone: () {
            socket = null;
            print('Server left.');
            socket!.destroy();
            setState(() {});
          },
        );
      }

      await sendMessage(socket!, 'Banana');
    } catch (e) {
      socket = null;
      print('socket error ' + e.toString());
    }
  }

  Future<void> sendMessage(Socket socket, String message) async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      var temp = '${value.latitude}/${value.longitude}/${carId}/carnet';

      try {
        socket.write(temp);

        print('Client: $temp');
      } catch (e) {
        print("sendMessage ERROR " + e.toString());
      }
    });

    // await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return pm.sysUserType == "5"
        ? Scaffold(
            body: DefaultTabController(
              initialIndex: 0, //выбрать с какого листа начать
              length: 1,
              child: Scaffold(
                appBar: AppBar(
                  bottom: const TabBar(
                    indicatorColor: Colors.white,
                    labelPadding: const EdgeInsets.all(0.0),
                    tabs: [Tab(text: 'Выполняющиеся')],
                  ),
                  title: const Text('Текущие заказы'),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: carId <= 0
                    ? SizedBox()
                    : FloatingActionButton.extended(
                        onPressed: () {
                          _start = !_start;

                          if (_start) {
                            timer = Timer.periodic(
                                Duration(seconds: 10), (Timer t) => main());

                            print('Connect');
                          } else {
                            try {
                              socket!.flush();
                              socket!.destroy();
                              socket = null;

                              timer?.cancel();
                              print('Disconnect');
                              setState(() {});
                            } catch (e) {
                              print("Disconnect error ${e.toString()}");
                            }
                          }

                          setState(() {});
                        },
                        backgroundColor: _start ? Colors.green : Colors.grey,
                        icon: _start
                            ? Icon(Icons.location_on)
                            : Icon(Icons.location_off),
                        label: Text('Местоположение'),
                      ),
                body: TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    load && !errorload
                        ? LoadingData()
                        : !load && errorload
                            ? ErorLoadingData()
                            : MyOrders(),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            body: pmLoad
                ? LoadingData()
                : DefaultTabController(
                    initialIndex: 0, //выбрать с какого листа начать
                    length: 3,
                    child: Scaffold(
                      appBar: AppBar(
                        bottom: const TabBar(
                          unselectedLabelColor: Colors.grey,
                          labelColor: Colors.black,
                          indicatorColor: Colors.black,
                          labelPadding: const EdgeInsets.all(0.0),
                          tabs: [
                            Tab(
                              text: 'Выполняющиеся',
                            ),
                            Tab(
                              text: 'Новые',
                            ),
                            Tab(
                              text: 'Мои заявки',
                            ),
                          ],
                        ),
                        title: Text('Текущие заказы'),
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.centerFloat,
                      floatingActionButton: carId <= 0
                          ? SizedBox()
                          : FloatingActionButton.extended(
                              onPressed: () {
                                _start = !_start;

                                if (_start) {
                                  timer = Timer.periodic(Duration(seconds: 10),
                                      (Timer t) => main());

                                  print('Connect');
                                } else {
                                  try {
                                    socket!.flush();
                                    socket!.destroy();
                                    socket = null;

                                    timer?.cancel();
                                    print('Disconnect');
                                    setState(() {});
                                  } catch (e) {
                                    print("Disconnect error ${e.toString()}");
                                  }
                                }

                                setState(() {});
                              },
                              backgroundColor:
                                  _start ? Colors.green : Colors.grey,
                              icon: _start
                                  ? Icon(Icons.location_on)
                                  : Icon(Icons.location_off),
                              label: Text('Местоположение'),
                            ),
                      body: TabBarView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          load && !errorload
                              ? LoadingData()
                              : !load && errorload
                                  ? ErorLoadingData()
                                  : MyOrders(),
                          load2 && !errorload2
                              ? LoadingData()
                              : !load2 && errorload2
                                  ? ErorLoadingData()
                                  : MyOrders2(),
                          load3 && !errorload3
                              ? LoadingData()
                              : !load && errorload
                                  ? ErorLoadingData()
                                  : MyOrders3(),
                        ],
                      ),
                    ),
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
                SizedBox(height: 100),
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
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Stack MyOrders() {
    if (data.length > 0) {
      data = data.where((element) => element['orderStatus'] == 3).toList();
    }

    return Stack(
      children: [
        data.length == 0
            ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Center(child: Text(AppLocalizations.of(context)!.netDannyh))
              ])
            : ListView.builder(
                padding: EdgeInsets.only(top: 5),

                ///если мы что-то ввели и начали скролл - клавиатура уйдет
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: data.length,
                itemExtent: 262,
                itemBuilder: (BuildContext context, int index) {
                  var formatted = data[index]['tripDate'];

                  var creator = data[index]['creator']['firstName'] != ""
                      ? "${data[index]['creator']['firstName']} ${data[index]['creator']['lastName']}"
                      : data[index]['creator']['orderInChargeName'];

                  var creatorPhone =
                      "${data[index]['creator']['orderInChargePhone']}";

                  var driverName = data[index]['driver']['firstName'] +
                      " " +
                      data[index]['driver']['lastName'];

                  var driverPhoneNumber =
                      data[index]['driver']['orderInChargePhone'];

                  var companyName =
                      data[index]['companyName'].toString().toUpperCase();
                  var componyPhoneNumber = data[index]['companyPhone'];

                  var brand = data[index]['car']['brandNameRu']
                      .toString()
                      .toUpperCase();
                  var model = data[index]['car']['modelNameRu']
                      .toString()
                      .toUpperCase();

                  var pnum =
                      data[index]['car']['carNumber'].toString().toUpperCase();

                  var carTypeName = data[index]['car']['carTypeNameRu']
                      .toString()
                      .toUpperCase();
                  var year = data[index]['car']['modelYear'];
                  var tonna = data[index]['car']['carWeight'];

                  var carDet1 = '${brand} ${model} ';
                  var carDet2 = '${pnum} ${year}Г';
                  var carDet3 = '${carTypeName} ${tonna}T';

                  try {
                    DateTime parseDate =
                        new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                            .parse(formatted);
                    var inputDate = DateTime.parse(parseDate.toString());
                    var outputFormat = DateFormat('dd.MM.yyyy');
                    var outputDate = outputFormat.format(inputDate);
                    // print(outputDate);
                    formatted = outputDate;
                  } catch (e) {
                    print('date parse error');
                  }

                  // int carType = data[index]['carTypeId'];

                  int st = 999;
                  try {
                    st = int.parse('${data[index]['orderStatus']}');
                  } catch (e) {}

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Stack(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    (pm.sysUserType == "3" ||
                                            pm.sysUserType == "4")
                                        ? Row(
                                            children: [
                                              Text(
                                                '${NumberFormat("#,##0", "pt_BR").format(data[index]['driverOfferPrice'])} ${data[index]['currencyIcon']}',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              Text(
                                                ' / ',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                '${NumberFormat("#,##0", "pt_BR").format(data[index]['bookerOfferPrice'])} ${data[index]['currencyIcon']}',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            '${NumberFormat("#,##0", "pt_BR").format(data[index]['bookerOfferPrice'])} ${data[index]['currencyIcon']}',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                    Text(
                                      OrderStatus.getStatusName(st, context),
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        color: OrderStatus.StatusColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    //Тонна
                                    SizedBox(
                                      height: 30,
                                      width: 150,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderDatailCardView(
                                                jdata: data[index],
                                                myCars: null,
                                                myDrivers: null,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.description_sharp,
                                          size: 11,
                                        ),
                                        label: Text(
                                          "Детали заказа",
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // SizedBox(height: 5.0),
                                Divider(
                                  color: Colors.grey,
                                  height: 10,
                                ),
                                //машрут точка А
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
                                      width: 288.0,
                                      child: Text(
                                        // filteredData[index].email.toLowerCase(),
                                        data[index]['beginPointName'],
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0),
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
                                      width: 288.0,
                                      child: Text(
                                        // filteredData[index].email.toLowerCase(),
                                        data[index]['endPointName'],
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ],
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
                                    SizedBox(
                                      width: 288.0,
                                      child: Text(
                                        data[index]['orderName'],
                                        maxLines: 2,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),

                                pm.sysUserType == "4"
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Грузоотправитель:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    creator.toUpperCase(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Водитель:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    driverName.toUpperCase(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Авто:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${carDet1.toUpperCase()} ${carDet2.toUpperCase()}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${carDet3.toUpperCase()}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  ClipOval(
                                                    child: Material(
                                                      color: Colors
                                                          .green, // Button color
                                                      child: InkWell(
                                                        splashColor: Colors
                                                            .red, // Splash color
                                                        onTap: () {
                                                          // var num = driverPhoneNumber;
                                                          pm.sysUserType == "4"
                                                              ? SheetBarDriverCompany(
                                                                  context,
                                                                  driverPhoneNumber,
                                                                  creatorPhone,
                                                                  driverName,
                                                                  creator)
                                                              : _launchURL(
                                                                  driverPhoneNumber);
                                                          // _launchURL(num);
                                                        },
                                                        child: SizedBox(
                                                            width: 40,
                                                            height: 40,
                                                            child: Icon(
                                                              Icons.call,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Перевозчик:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    driverName,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    // width: 180,
                                                    child: Text(
                                                      carDet1,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    carDet2,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Text(
                                                    carDet3,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  ClipOval(
                                                    child: Material(
                                                      color: Colors
                                                          .green, // Button color
                                                      child: InkWell(
                                                        splashColor: Colors
                                                            .red, // Splash color
                                                        onTap: () {
                                                          // var num = driverPhoneNumber;
                                                          companyName == ''
                                                              ? _launchURL(
                                                                  driverPhoneNumber)
                                                              : SheetBarClient(
                                                                  context,
                                                                  driverPhoneNumber,
                                                                  componyPhoneNumber,
                                                                  driverName,
                                                                  companyName);
                                                          // _launchURL(num);
                                                        },
                                                        child: SizedBox(
                                                            width: 40,
                                                            height: 40,
                                                            child: Icon(
                                                              Icons.call,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }

  Stack MyOrders2() {
    if (data2.length > 0) {
      data2 = data2.where((element) => element['orderStatus'] == 0).toList();
    }

    return Stack(
      children: [
        data2.length == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(AppLocalizations.of(context)!.netDannyh),
                  ),
                ],
              )
            : ListView.builder(
                padding: EdgeInsets.only(top: 5),

                ///если мы что-то ввели и начали скролл - клавиатура уйдет
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: data2.length,
                itemExtent: 160,
                itemBuilder: (BuildContext context, int index) {
                  var formatted = data2[index]['tripDate'];

                  try {
                    DateTime parseDate =
                        new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                            .parse(formatted);
                    var inputDate = DateTime.parse(parseDate.toString());
                    var outputFormat = DateFormat('dd.MM.yyyy');
                    var outputDate = outputFormat.format(inputDate);
                    // print(outputDate);
                    formatted = outputDate;
                  } catch (e) {
                    print('date parse error');
                  }

                  // int carType = data2[index]['carTypeId'];

                  int st = 999;
                  try {
                    st = int.parse('${data2[index]['orderStatus']}');
                  } catch (e) {}

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Stack(
                      children: [
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Багасы
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${NumberFormat("#,##0", "pt_BR").format(data2[index]['bookerOfferPrice'])} ${data2[index]['currencyIcon']}',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      OrderStatus.getStatusName(st, context),
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        color: OrderStatus.StatusColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                              // filtereddata2[index].name,
                                              formatted.toString(),
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
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
                                        ' ${data2[index]['lugWeight']} T ',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                          // fontWeight: FontWeight.bold,
                                          // backgroundColor: Colors.grey,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: 1,
                                          ),
                                        ],
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
                                      width: 288.0,
                                      child: Text(
                                        // filtereddata2[index].email.toLowerCase(),
                                        data2[index]['beginPointName'],
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0),
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
                                      width: 288.0,
                                      child: Text(
                                        // filtereddata2[index].email.toLowerCase(),
                                        data2[index]['endPointName'],
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ],
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
                                    SizedBox(
                                      width: 288.0,
                                      child: Text(
                                        data2[index]['orderName'],
                                        maxLines: 2,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Material(
                          ///без color содержимое контейнера пропадает
                          ///поэтому добавляем прозрачность
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              (pm.sysUserType == "1" || pm.sysUserType == "2")
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderDatailCardView(
                                          jdata: data2[index],
                                          myCars: null,
                                          myDrivers: null,
                                        ),
                                      ),
                                    )
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderDatailCardDriverView(
                                          jdata: data2[index],
                                          myCars: null,
                                          myDrivers: null,
                                        ),
                                      ),
                                    );
                              print('click');
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }

  Stack MyOrders3() {
    return Stack(
      children: [
        data3.length == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(AppLocalizations.of(context)!.netDannyh),
                  ),
                ],
              )
            : ListView.builder(
                padding: EdgeInsets.only(top: 5),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: data3.length,
                // itemExtent: 201,
                itemBuilder: (BuildContext context, int index) {
                  var formatted = data3[index]['tripDate'];

                  try {
                    DateTime parseDate =
                        new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                            .parse(formatted);
                    var inputDate = DateTime.parse(parseDate.toString());
                    var outputFormat = DateFormat('dd.MM.yyyy');
                    var outputDate = outputFormat.format(inputDate);
                    // print(outputDate);
                    formatted = outputDate;
                  } catch (e) {
                    print('date parse error');
                  }

                  // int carType = data3[index]['carTypeId'];

                  int st = 999;
                  try {
                    st = int.parse('${data3[index]['orderStatus']}');
                  } catch (e) {}

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Stack(
                      children: [
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Багасы

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    (pm.sysUserType == "1" ||
                                            pm.sysUserType == "2")
                                        ? Text(
                                            'Созданная цена ${NumberFormat("#,##0", "pt_BR").format(data3[index]['bookerOfferPrice'])} ${data3[index]['currencyIcon']}',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          )
                                        : Text(
                                            'Цена клиента ${NumberFormat("#,##0", "pt_BR").format(data3[index]['bookerOfferPrice'])} ${data3[index]['currencyIcon']}',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                    Text(
                                      OrderStatus.getStatusName(st, context),
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        color: OrderStatus.StatusColor,
                                      ),
                                    ),
                                  ],
                                ),
                                (pm.sysUserType == "1" || pm.sysUserType == "2")
                                    ? SizedBox()
                                    : Text(
                                        'Ваша цена ${NumberFormat("#,##0", "pt_BR").format(data3[index]['driverOfferPrice'])} ${data3[index]['currencyIcon']}',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                      ),
                                SizedBox(height: 5.0),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                              // filtereddata3[index].name,
                                              formatted.toString(),
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
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
                                        ' ${data3[index]['lugWeight']} T ',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                          // fontWeight: FontWeight.bold,
                                          // backgroundColor: Colors.grey,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: 1,
                                          ),
                                        ],
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
                                      width: 288.0,
                                      child: Text(
                                        // filtereddata3[index].email.toLowerCase(),
                                        data3[index]['beginPointName'],
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0),
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
                                      width: 288.0,
                                      child: Text(
                                        // filtereddata3[index].email.toLowerCase(),
                                        data3[index]['endPointName'],
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ],
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
                                    SizedBox(
                                      width: 288.0,
                                      child: Text(
                                        data3[index]['orderName'],
                                        maxLines: 2,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrderDatailCardView(
                                              jdata: data3[index],
                                              myCars: null,
                                              myDrivers: null,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.description_sharp,
                                        size: 12,
                                      ),
                                      label: Text(
                                        "Детали заказа",
                                        style: TextStyle(fontSize: 11),
                                      ),
                                    ),
                                    (pm.sysUserType == "1" ||
                                            pm.sysUserType == "2")
                                        ? ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Usunus(
                                                          token: pm.token
                                                              .toString(),
                                                          jdata: data3[index],
                                                        )),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.add_alert_rounded,
                                              size: 12,
                                            ),
                                            label: Text(
                                              "Показать заявки ${data3[index]['notifications'].length}",
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }
}

Future<dynamic> SheetBarClient(BuildContext context, driverPhoneNumber,
    componyPhoneNumber, String driverName, String companyName) {
  return showAdaptiveActionSheet(
    context: context,
    actions: <BottomSheetAction>[
      BottomSheetAction(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Водитель',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              '${driverName}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onPressed: (context) {
          Navigator.pop(context);
          _launchURL(driverPhoneNumber);
        },
        leading: const Icon(Icons.phone, size: 25),
      ),
      BottomSheetAction(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Компания',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              '${companyName}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onPressed: (context) {
          Navigator.pop(context);
          _launchURL(componyPhoneNumber);
        },
        leading: const Icon(Icons.phone, size: 25),
      ),
    ],
    cancelAction: CancelAction(
        title: const Text(
      'Закрыть',
      style: TextStyle(color: Colors.blueAccent),
    )),
  );
}

Future<dynamic> SheetBarDriverCompany(BuildContext context, driverPhoneNumber,
    componyPhoneNumber, String driverName, String companyName) {
  return showAdaptiveActionSheet(
    context: context,
    actions: <BottomSheetAction>[
      BottomSheetAction(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Водитель',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              '${driverName}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onPressed: (context) {
          Navigator.pop(context);
          _launchURL(driverPhoneNumber);
        },
        leading: const Icon(Icons.phone, size: 25),
      ),
      BottomSheetAction(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Клиент',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              '${companyName}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onPressed: (context) {
          Navigator.pop(context);
          _launchURL(componyPhoneNumber);
        },
        leading: const Icon(Icons.phone, size: 25),
      ),
    ],
    cancelAction: CancelAction(
        title: const Text(
      'Закрыть',
      style: TextStyle(color: Colors.blueAccent),
    )),
  );
}

_launchURL(String phoneNumber) async {
  var url = 'tel:$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<dynamic> SheetBar(BuildContext context) {
  return showAdaptiveActionSheet(
    context: context,
    title: Text(
      AppLocalizations.of(context)!.dlyaProdRabotyZareg,
      textAlign: TextAlign.center,
    ),
    actions: <BottomSheetAction>[
      BottomSheetAction(
        title: Text(
          AppLocalizations.of(context)!.register,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: (context) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => CurrentView()),
          // );
        },
        // leading: const Icon(Icons.circle_outlined, size: 25),
      ),
    ],
    cancelAction: CancelAction(
        title: const Text(
      'Закрыть',
      style: TextStyle(color: Colors.blueAccent),
    )),
  );
}
