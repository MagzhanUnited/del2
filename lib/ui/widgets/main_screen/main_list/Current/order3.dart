import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/order/order_datail_card.dart';
import 'package:themoviedb/full/ui/order/order_status.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../app/my_app.dart';
import '../../menu_list/analitika/AppStat.dart';
import 'client_zibergen_menin_usunistarum.dart';

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class MyAppOrder3 extends StatefulWidget {
  @override
  State<MyAppOrder3> createState() => _MyAppOrder3State();
}

class _MyAppOrder3State extends State<MyAppOrder3> {
  List data3 = [];
  bool load3 = true;
  bool errorload3 = false;

  final pm = ProfileModel();

  @override
  void initState() {
    super.initState();

    load3 = true;
    errorload3 = false;

    pm.setupLocale(context).then(
      (value) async {
        if (pm.sysUserType == "1" || pm.sysUserType == "2") {
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
          load3 = false;
          errorload3 = false;
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: load3 && !errorload3
            ? LoadingData(context)
            : !load3 && errorload3
                ? ErorLoadingData(context)
                : MyOrders3(),
      ),
    );
  }

  Stack MyOrders3() {
    return Stack(
      children: [
        data3.length == 0
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
                      itemCount: data3.length,
                      // itemExtent: 201,
                      itemBuilder: (BuildContext context, int index) {
                        var formatted = DateFormat('dd.MM.yyyy, hh:mm')
                            .format(DateTime.parse(data3[index]['tripDate']))
                            .toString();

                        // int carType = data3[index]['carTypeId'];

                        int st = 999;
                        try {
                          st = int.parse('${data3[index]['orderStatus']}');
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
                                          (pm.sysUserType == "1" ||
                                                  pm.sysUserType == "2")
                                              ? Text(
                                                  '${AppLocalizations.of(context)!.sozdannayaTcena} \n${NumberFormat("#,##0", "pt_BR").format(data3[index]['bookerOfferPrice'])} ${data3[index]['currencyIcon']}',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.bold,
                                                    // color: Colors.red,
                                                  ),
                                                )
                                              : Text(
                                                  '${AppLocalizations.of(context)!.tsenaKlienta} ${NumberFormat("#,##0", "pt_BR").format(data3[index]['bookerOfferPrice'])} ${data3[index]['currencyIcon']}',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.bold,
                                                    // color: Colors.black,
                                                  ),
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
                                                        // filtereddata3[index].name,
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
                                      (pm.sysUserType == "1" ||
                                              pm.sysUserType == "2")
                                          ? SizedBox()
                                          : Text(
                                              '${AppLocalizations.of(context)!.vashaCena} ${NumberFormat("#,##0", "pt_BR").format(data3[index]['driverOfferPrice'])} ${data3[index]['currencyIcon']}',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.normal,
                                                // color: Colors.black,
                                              ),
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
                                                      '${data3[index]['beginPointName']}',
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
                                                      '${data3[index]['endPointName']}',
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
                                        data3[index]['orderName'],
                                        maxLines: 5,
                                        style: TextStyle(
                                            // color: AppColors.primaryColors[0],
                                            fontSize: 15,
                                            letterSpacing: 0.3,
                                            height: 1.2,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: 20.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
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
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .podrobnoe),
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
                                                                jdata: data3[
                                                                    index],
                                                              )),
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.add_alert_rounded,
                                                    size: 12,
                                                  ),
                                                  label: Text(
                                                    "${AppLocalizations.of(context)!.pokazatZayavki} ${data3[index]['notifications'].length}",
                                                    style:
                                                        TextStyle(fontSize: 11),
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                        // return Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       vertical: 5, horizontal: 5),
                        //   child: Stack(
                        //     children: [
                        //       Card(
                        //         elevation: 5,
                        //         child: Padding(
                        //           padding: EdgeInsets.all(10.0),
                        //           child: Column(
                        //             mainAxisAlignment: MainAxisAlignment.start,
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: <Widget>[
                        //               // Багасы

                        //               Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.spaceBetween,
                        //                 children: [
                        //                   (pm.sysUserType == "1" ||
                        //                           pm.sysUserType == "2")
                        //                       ? Text(
                        //                           'Созданная цена ${NumberFormat("#,##0", "pt_BR").format(data3[index]['bookerOfferPrice'])} ${data3[index]['currencyIcon']}',
                        //                           style: TextStyle(
                        //                             fontSize: 13.0,
                        //                             fontWeight: FontWeight.bold,
                        //                             color: Colors.red,
                        //                           ),
                        //                         )
                        //                       : Text(
                        //                           'Цена клиента ${NumberFormat("#,##0", "pt_BR").format(data3[index]['bookerOfferPrice'])} ${data3[index]['currencyIcon']}',
                        //                           style: TextStyle(
                        //                             fontSize: 13.0,
                        //                             fontWeight: FontWeight.bold,
                        //                             color: Colors.black,
                        //                           ),
                        //                         ),
                        //                   Text(
                        //                     OrderStatus.getStatusName(st),
                        //                     style: TextStyle(
                        //                       fontSize: 13.0,
                        //                       fontWeight: FontWeight.bold,
                        //                       color: OrderStatus.StatusColor,
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               (pm.sysUserType == "1" ||
                        //                       pm.sysUserType == "2")
                        //                   ? SizedBox()
                        //                   : Text(
                        //                       'Ваша цена ${NumberFormat("#,##0", "pt_BR").format(data3[index]['driverOfferPrice'])} ${data3[index]['currencyIcon']}',
                        //                       style: TextStyle(
                        //                         fontSize: 13.0,
                        //                         fontWeight: FontWeight.normal,
                        //                         color: Colors.black,
                        //                       ),
                        //                     ),
                        //               SizedBox(height: 5.0),

                        //               Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.spaceBetween,
                        //                 children: <Widget>[
                        //                   //дата заказа
                        //                   Padding(
                        //                     padding: EdgeInsets.only(),
                        //                     child: ButtonTheme(
                        //                       child: Row(
                        //                         children: [
                        //                           Icon(
                        //                             Icons.calendar_today_sharp,
                        //                             size: 14,
                        //                           ),
                        //                           SizedBox(width: 10.0),
                        //                           Text(
                        //                             // filtereddata3[index].name,
                        //                             formatted.toString(),
                        //                             style: TextStyle(
                        //                               fontSize: 14.0,
                        //                               color: Colors.black,
                        //                               fontWeight:
                        //                                   FontWeight.normal,
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   //Тонна
                        //                   Container(
                        //                     child: Text(
                        //                       ' ${data3[index]['lugWeight']} T ',
                        //                       style: TextStyle(
                        //                         fontSize: 14.0,
                        //                         color: Colors.grey,
                        //                         // fontWeight: FontWeight.bold,
                        //                         // backgroundColor: Colors.grey,
                        //                       ),
                        //                     ),
                        //                     decoration: BoxDecoration(
                        //                       borderRadius:
                        //                           BorderRadius.circular(10),
                        //                       color: Colors.white,
                        //                       boxShadow: [
                        //                         BoxShadow(
                        //                           color: Colors.grey,
                        //                           spreadRadius: 1,
                        //                         ),
                        //                       ],
                        //                     ),
                        //                     // height: 50,
                        //                   ),
                        //                 ],
                        //               ),
                        //               // SizedBox(height: 5.0),
                        //               Divider(
                        //                 color: Colors.grey,
                        //                 height: 10,
                        //               ),
                        //               //машрут точка А
                        //               Row(
                        //                 children: [
                        //                   Text(
                        //                     ' A',
                        //                     style: TextStyle(
                        //                       fontSize: 14.0,
                        //                       color: Colors.grey,
                        //                     ),
                        //                   ),
                        //                   SizedBox(width: 10.0),
                        //                   Container(
                        //                     width: 288.0,
                        //                     child: Text(
                        //                       // filtereddata3[index].email.toLowerCase(),
                        //                       data3[index]['beginPointName'],
                        //                       style: TextStyle(
                        //                         fontSize: 14.0,
                        //                         color: Colors.black,
                        //                       ),
                        //                       maxLines: 1,
                        //                       overflow: TextOverflow.fade,
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               SizedBox(height: 5.0),
                        //               //машрут точка Б
                        //               Row(
                        //                 children: [
                        //                   Text(
                        //                     ' B',
                        //                     style: TextStyle(
                        //                       fontSize: 14.0,
                        //                       color: Colors.grey,
                        //                     ),
                        //                   ),
                        //                   SizedBox(width: 10.0),
                        //                   Container(
                        //                     width: 288.0,
                        //                     child: Text(
                        //                       // filtereddata3[index].email.toLowerCase(),
                        //                       data3[index]['endPointName'],
                        //                       style: TextStyle(
                        //                         fontSize: 14.0,
                        //                         color: Colors.black,
                        //                       ),
                        //                       maxLines: 1,
                        //                       overflow: TextOverflow.fade,
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               Divider(
                        //                 color: Colors.grey,
                        //                 height: 10,
                        //               ),
                        //               Row(
                        //                 children: [
                        //                   Icon(
                        //                     Icons.comment,
                        //                     size: 14,
                        //                   ),
                        //                   SizedBox(width: 10.0),
                        //                   SizedBox(
                        //                     width: 288.0,
                        //                     child: Text(
                        //                       data3[index]['orderName'],
                        //                       maxLines: 2,
                        //                       overflow: TextOverflow.fade,
                        //                       softWrap: false,
                        //                       style: TextStyle(
                        //                         fontSize: 14.0,
                        //                         color: Colors.black,
                        //                         fontWeight: FontWeight.normal,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.spaceBetween,
                        //                 children: [
                        //                   ElevatedButton.icon(
                        //                     onPressed: () {
                        //                       Navigator.push(
                        //                         context,
                        //                         MaterialPageRoute(
                        //                           builder: (context) =>
                        //                               OrderDatailCardView(
                        //                             jdata: data3[index],
                        //                             myCars: null,
                        //                             myDrivers: null,
                        //                           ),
                        //                         ),
                        //                       );
                        //                     },
                        //                     icon: Icon(
                        //                       Icons.description_sharp,
                        //                       size: 12,
                        //                     ),
                        //                     label: Text(
                        //                       "Детали заказа",
                        //                       style: TextStyle(fontSize: 11),
                        //                     ),
                        //                   ),
                        //                   (pm.sysUserType == "1" ||
                        //                           pm.sysUserType == "2")
                        //                       ? ElevatedButton.icon(
                        //                           onPressed: () {
                        //                             Navigator.push(
                        //                               context,
                        //                               MaterialPageRoute(
                        //                                   builder: (context) =>
                        //                                       Usunus(
                        //                                         token: pm.token
                        //                                             .toString(),
                        //                                         jdata: data3[
                        //                                             index],
                        //                                       )),
                        //                             );
                        //                           },
                        //                           icon: Icon(
                        //                             Icons.add_alert_rounded,
                        //                             size: 12,
                        //                           ),
                        //                           label: Text(
                        //                             "Показать заявки ${data3[index]['notifications'].length}",
                        //                             style:
                        //                                 TextStyle(fontSize: 11),
                        //                           ),
                        //                         )
                        //                       : SizedBox(),
                        //                 ],
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // );
                      },
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
