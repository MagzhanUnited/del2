import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/order/order_datail_card.dart';
import 'package:themoviedb/full/ui/order/order_datail_card_driver.dart';
import 'package:themoviedb/full/ui/order/order_status.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../app/my_app.dart';
import '../../menu_list/analitika/AppStat.dart';

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class MyAppOrder2 extends StatefulWidget {
  @override
  State<MyAppOrder2> createState() => _MyAppOrder2State();
}

class _MyAppOrder2State extends State<MyAppOrder2> {
  List data2 = [];
  bool load2 = true;
  bool errorload2 = false;

  final pm = ProfileModel();

  @override
  void initState() {
    super.initState();

    load2 = true;
    errorload2 = false;

    pm.setupLocale(context).then(
      (value) async {
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
                print('Не удалось получить список моих заказов');
              }
            },
          );
        } else if (pm.sysUserType == "3" || pm.sysUserType == "4") {
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
        } else {
          load2 = false;
          errorload2 = false;
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
        child: load2 && !errorload2
            ? LoadingData(context)
            : !load2 && errorload2
                ? ErorLoadingData(context)
                : MyOrders2(),
      ),
    );
  }

  Stack MyOrders2() {
    if (data2.length > 0) {
      data2 = data2.where((element) => element['orderStatus'] == 0).toList();
    }

    return Stack(
      children: [
        data2.length == 0
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
                      itemCount: data2.length,
                      itemBuilder: (BuildContext context, int index) {
                        var formatted = DateFormat('dd.MM.yyyy, hh:mm')
                            .format(DateTime.parse(data2[index]['tripDate']))
                            .toString();

                        int st = 999;
                        try {
                          st = int.parse('${data2[index]['orderStatus']}');
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
                                            '${NumberFormat("#,##0", "pt_BR").format(data2[index]['bookerOfferPrice'])} ${data2[index]['currencyIcon']}',
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
                                                        // filtereddata2[index].name,
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
                                                      '${data2[index]['beginPointName']}',
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
                                                      '${data2[index]['endPointName']}',
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
                                        data2[index]['orderName'],
                                        maxLines: 5,
                                        style: TextStyle(
                                            // color: AppColors.primaryColors[0],
                                            fontSize: 15,
                                            letterSpacing: 0.3,
                                            height: 1.2,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: 20.0),
                                      ElevatedButton(
                                        onPressed: () {
                                          (pm.sysUserType == "1" ||
                                                  pm.sysUserType == "2")
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
                        //                   Text(
                        //                     '${NumberFormat("#,##0", "pt_BR").format(data2[index]['bookerOfferPrice'])} ${data2[index]['currencyIcon']}',
                        //                     style: TextStyle(
                        //                       fontSize: 18.0,
                        //                       fontWeight: FontWeight.bold,
                        //                       color: Colors.black,
                        //                     ),
                        //                   ),
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
                        //                             // filtereddata2[index].name,
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
                        //                       ' ${data2[index]['lugWeight']} T ',
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
                        //                       // filtereddata2[index].email.toLowerCase(),
                        //                       data2[index]['beginPointName'],
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
                        //                       // filtereddata2[index].email.toLowerCase(),
                        //                       data2[index]['endPointName'],
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
                        //                       data2[index]['orderName'],
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
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //       Material(
                        //         ///без color содержимое контейнера пропадает
                        //         ///поэтому добавляем прозрачность
                        //         color: Colors.transparent,
                        //         child: InkWell(
                        //           borderRadius: BorderRadius.circular(10),
                        //           onTap: () {
                        //             (pm.sysUserType == "1" ||
                        //                     pm.sysUserType == "2")
                        //                 ? Navigator.push(
                        //                     context,
                        //                     MaterialPageRoute(
                        //                       builder: (context) =>
                        //                           OrderDatailCardView(
                        //                         jdata: data2[index],
                        //                         myCars: null,
                        //                         myDrivers: null,
                        //                       ),
                        //                     ),
                        //                   )
                        //                 : Navigator.push(
                        //                     context,
                        //                     MaterialPageRoute(
                        //                       builder: (context) =>
                        //                           OrderDatailCardDriverView(
                        //                         jdata: data2[index],
                        //                         myCars: null,
                        //                         myDrivers: null,
                        //                       ),
                        //                     ),
                        //                   );
                        //             print('click');
                        //           },
                        //         ),
                        //       )
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
