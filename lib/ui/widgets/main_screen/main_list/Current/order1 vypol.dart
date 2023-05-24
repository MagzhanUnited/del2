import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/order/order_datail_card.dart';
import 'package:themoviedb/full/ui/order/order_status.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../controllers/location_controller.dart';
import '../../../app/my_app.dart';
import '../../menu_list/analitika/AppStat.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class MyAppOrder1 extends StatefulWidget {
  @override
  State<MyAppOrder1> createState() => _MyAppOrder1State();
}

class _MyAppOrder1State extends State<MyAppOrder1> {
  List data = [];
  bool load = true;

  bool errorload = false;

  final pm = ProfileModel();

  // int carId = 0;

  // bool _start = false;
  // Timer? timer;
  LocationController locationController = Get.find();

  @override
  void initState() {
    // _start = false;
    // locationController.socket = null;
    locationController.carId.value = 0;

    super.initState();

    load = true;
    errorload = false;

    pm.setupLocale(context).then(
      (value) async {
        if (pm.sysUserType == "3" || pm.sysUserType == "5") {
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
                  locationController.carId.value = int.parse(value);
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

                //выпол
                data = docs;
                load = false;
                errorload = false;

                setState(() {});
              } else {
                load = false;
                errorload = true;

                setState(() {});
                print('Не удалось получить список моих заказов');
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
    // timer?.cancel();
    super.dispose();
  }

  Future<bool> isTcpConnectionAlive(String host, int port) async {
    try {
      final socket = await Socket.connect(host, port);
      socket.destroy();
      return true;
    } on SocketException catch (_) {
      return false;
    }
  }

  // void main() async {
  //   try {
  //     if (locationController.socket.value == null) {
  //       locationController.socket.value =
  //           await Socket.connect('185.116.193.86', 8088);
  //       print(
  //           'Connected to: ${locationController.socket.value!.remoteAddress.address}:${locationController.socket.value!.remotePort}');
  //       locationController.socket.value!.listen(
  //         (Uint8List data) {
  //           final serverResponse = String.fromCharCodes(data);
  //           print('Server: $serverResponse');
  //         },

  //         onError: (error) {
  //           print(locationController.socket.value);
  //           print(error);
  //           locationController.socket.value!.destroy();
  //           locationController.socket.value = null;
  //           setState(() {});
  //         },

  //         // handle server ending connection
  //         onDone: () {
  //           locationController.socket.value = null;
  //           print('Server left.');
  //           // locationController.socket.value!.destroy();
  //           setState(() {});
  //         },
  //       );
  //     }

  //     if (locationController.start.value) {
  //       await sendMessage(locationController.socket.value!, 'Banana');
  //     }
  //   } catch (e) {
  //     locationController.socket.value = null;
  //     print('socket error ' + e.toString());
  //   }
  // }

  // Future<void> sendMessage(Socket socket, String message) async {
  //   Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((value) {
  //     var temp =
  //         '${value.latitude}/${value.longitude}/${locationController.carId.value}/carnet';

  //     try {
  //       socket.write(temp);

  //       print('Client: $temp');
  //     } catch (e) {
  //       print("sendMessage ERROR " + e.toString());
  //     }
  //   });
  //   // await Future.delayed(Duration(seconds: 1));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: load && !errorload
            ? LoadingData(context)
            : !load && errorload
                ? ErorLoadingData(context)
                : MyOrders(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: locationController.carId.value <= 0
          ? TextButton(onPressed: null, child: Text(''))
          : FloatingActionButton.extended(
              onPressed: () async {
                locationController.start.value =
                    !locationController.start.value;

                try {
                  if (locationController.start.value) {
                    try {
                      locationController.timeStart(locationController);
                      // timer = Timer.periodic(
                      //   Duration(seconds: 10),
                      //   (Timer t) =>
                      //       locationController.main1(locationController),
                      // );
                    } catch (e) {
                      print(e);
                    }

                    print('Connect');
                  } else {
                    try {
                      // locationController.socket.value!.flush();
                      print(
                          "Socked value: ${locationController.socket.value == null}");
                      bool isAlive =
                          await isTcpConnectionAlive('185.116.193.86', 8088);
                      if (isAlive) {
                        if (locationController.socket.value != null) {
                          locationController.socket.value!.destroy();
                        }
                        // locationController.socket.value = null;
                      }

                      // locationController.socket.value = null;

                      // timer?.cancel();
                      print('Disconnect');
                      setState(() {});
                    } catch (e) {
                      print("Disconnect error ${e.toString()}");
                    }
                  }
                } catch (e) {
                  print(e);
                }

                setState(() {});
                print("Socked value: ${locationController.socket.value}");
                print('finished');
              },
              backgroundColor:
                  locationController.start.value ? Colors.green : Colors.grey,
              icon: locationController.start.value
                  ? Icon(Icons.location_on)
                  : Icon(Icons.location_off),
              label: Text(AppLocalizations.of(context)!.mestopolozhenie),
            ),
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
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 24),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        var formatted = DateFormat('dd.MM.yyyy, hh:mm')
                            .format(DateTime.parse(data[index]['tripDate']))
                            .toString();

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

                        var pnum = data[index]['car']['carNumber']
                            .toString()
                            .toUpperCase();

                        var carTypeName = data[index]['car']['carTypeNameRu']
                            .toString()
                            .toUpperCase();
                        var year = data[index]['car']['modelYear'];
                        var tonna = data[index]['car']['carWeight'];

                        var carDet1 = '${brand} ${model} ';
                        var carDet2 = '${pnum} ${year}Г';
                        var carDet3 = '${carTypeName} ${tonna}T';

                        // int carType = data[index]['carTypeId'];

                        int st = 999;
                        try {
                          st = int.parse('${data[index]['orderStatus']}');
                        } catch (e) {}

                        final provider = Provider.of<LocaleProvider>(context);

                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 12, left: 16, right: 16),
                          child: Card(
                            elevation: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Багасы
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${NumberFormat("#,##0", "pt_BR").format(data[index]['bookerOfferPrice'])} ${data[index]['currencyIcon']}',
                                            style: TextStyle(
                                                // color:
                                                //     AppColors.primaryColors[0],
                                                fontSize: 18,
                                                letterSpacing: 0.3,
                                                fontWeight: FontWeight.w800),
                                          ),
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
                                                      Image.asset(
                                                        "images/calendar16.png",
                                                        height: 16,
                                                        color: provider
                                                                    .selectedThemeMode ==
                                                                ThemeMode.dark
                                                            ? Colors.white
                                                            : AppColors
                                                                .primaryColors[0],
                                                      ),
                                                      SizedBox(width: 6.0),
                                                      Text(
                                                        // filteredData[index].name,
                                                        formatted.toString(),
                                                        style: TextStyle(
                                                            // color: AppColors
                                                            //         .primaryColors[
                                                            //     0],
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        OrderStatus.getStatusName(st, context),
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          color: OrderStatus.StatusColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
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
                                                      AppLocalizations.of(
                                                              context)!
                                                          .zabrat,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .primaryColors[3],
                                                          fontSize: 12,
                                                          letterSpacing: 0.3,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      '${data[index]['beginPointName']}',
                                                      style: TextStyle(
                                                          // color: AppColors
                                                          //     .primaryColors[0],
                                                          fontSize: 15,
                                                          letterSpacing: 0.3,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    SizedBox(height: 16),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .dostavit,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .primaryColors[3],
                                                          fontSize: 12,
                                                          letterSpacing: 0.3,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      '${data[index]['endPointName']}',
                                                      style: TextStyle(
                                                          // color: AppColors
                                                          //     .primaryColors[0],
                                                          fontSize: 15,
                                                          letterSpacing: 0.3,
                                                          fontWeight:
                                                              FontWeight.w400),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        maxLines: 5,
                                        style: TextStyle(
                                            // color: AppColors.primaryColors[0],
                                            fontSize: 15,
                                            letterSpacing: 0.3,
                                            height: 1.2,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: 20.0),
                                      pm.sysUserType == "4"
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${AppLocalizations.of(context)!.gruzOtprav}:',
                                                          style: TextStyle(
                                                              color: AppColors
                                                                      .primaryColors[
                                                                  3],
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  0.3,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(height: 8.0),
                                                        Text(
                                                          creator.toUpperCase(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        SizedBox(height: 20.0),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '${AppLocalizations.of(context)!.voditel}:',
                                                                  style: TextStyle(
                                                                      color:
                                                                          AppColors.primaryColors[
                                                                              3],
                                                                      fontSize:
                                                                          12,
                                                                      letterSpacing:
                                                                          0.3,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        8.0),
                                                                Text(
                                                                  driverName
                                                                      .toUpperCase(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        13,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(width: 30),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '${AppLocalizations.of(context)!.avto}:',
                                                                  style: TextStyle(
                                                                      color:
                                                                          AppColors.primaryColors[
                                                                              3],
                                                                      fontSize:
                                                                          12,
                                                                      letterSpacing:
                                                                          0.3,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        8.0),
                                                                Text(
                                                                  "${carDet1.toUpperCase()}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        13,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            pm.sysUserType ==
                                                                    "4"
                                                                ? SheetBarDriverCompany(
                                                                    context,
                                                                    driverPhoneNumber,
                                                                    creatorPhone,
                                                                    driverName,
                                                                    creator)
                                                                : _launchURL(
                                                                    driverPhoneNumber);
                                                          },
                                                          icon: Image.asset(
                                                              "images/Call.png",
                                                              height: 60),
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
                                                  '${AppLocalizations.of(context)!.gruzPerevoz}:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          driverName,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          // width: 180,
                                                          child: Text(
                                                            carDet1,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
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
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
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
                                                                companyName ==
                                                                        ''
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
                                                                    color: Colors
                                                                        .white,
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
                                      SizedBox(height: 20.0),
                                      ElevatedButton(
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
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .podrobnoe),
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
                  ),
                ],
              ),
      ],
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
          title: Text(
        'Закрыть',
        style: TextStyle(color: Colors.blueAccent),
      )),
    );
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
                AppLocalizations.of(context)!.voditel,
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
                AppLocalizations.of(context)!.kompaniya,
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
          title: Text(
        AppLocalizations.of(context)!.zakrit,
        style: TextStyle(color: Colors.blueAccent),
      )),
    );
  }
}
