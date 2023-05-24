import 'dart:convert';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../app/my_app.dart';
import 'draiverge usinis detailder.dart';
import 'notifylar_order.dart';

class NotifyCurrentOrders extends StatefulWidget {
  NotifyCurrentOrders({
    Key? key,
  }) : super(key: key);

  @override
  _NotifyCurrentOrdersState createState() => _NotifyCurrentOrdersState();
}

class _NotifyCurrentOrdersState extends State<NotifyCurrentOrders> {
  List data = [];
  String token = '';

  final pm = ProfileModel();

  bool load = true;
  bool errorLoad = false;

  @override
  void initState() {
    super.initState();

    load = true;
    errorLoad = false;

    pm.setupLocale(context).then(
      (value) {
        if (pm.sysUserType == "1" || pm.sysUserType == "2") {
          GetNotListClient(
            token: pm.token.toString(),
          ).getList().then(
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
                  data = docs;
                  token = pm.token.toString();
                  load = false;
                  errorLoad = false;
                });
              } else {
                setState(() {
                  load = false;
                  errorLoad = true;
                });
                print('Не удалось получить список моих заказов');
              }
            },
          );
        } else {
          NotListDriver(
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
                  data = docs;
                  // if(data.length > 0){
                  //   data = data.where((element) => element[])
                  // }
                  token = pm.token.toString();
                  load = false;
                  errorLoad = false;
                });
              } else {
                setState(() {
                  load = false;
                  errorLoad = true;
                });
                print('Не удалось получить список моих заказов');
              }
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.uvedomleniya),
      ),
      body: load && !errorLoad
          ? LoadingData()
          : !load && errorLoad
              ? ErorLoadingData()
              : notifyData(),
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
                ElevatedButton(
                    onPressed: () {
                      // initState();
                    },
                    child: Text(AppLocalizations.of(context)!.prodolzhit))
              ],
            ),
          ],
        )
      ],
    );
  }

  Column notifyData() {
    return data.length == 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(AppLocalizations.of(context)!.netDannyh),
              ),
            ],
          )
        : Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                // child: dropDown(),
              ),
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  itemCount: data.length,
                  // itemExtent: 225,
                  itemBuilder: (BuildContext context, int index) {
                    var formatted = data[index]['tripDate'];

                    return Card(
                      elevation: 5,
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
                                  '${AppLocalizations.of(context)!.vashaCena}: ${data[index]['bookerOfferPrice']} ${data[index]['currencyIcon']}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    // color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
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
                                // Container(
                                //   child: Text(
                                //     '${data[index]['lugWeight']}T',
                                //     style: TextStyle(
                                //       fontSize: 14.0,
                                //       color: Colors.grey,
                                //       // fontWeight: FontWeight.bold,
                                //       // backgroundColor: Colors.grey,
                                //     ),
                                //   ),
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(10),
                                //     color: Colors.white,
                                //     boxShadow: [
                                //       BoxShadow(
                                //         color: Colors.grey,
                                //         spreadRadius: 1,
                                //       ),
                                //     ],
                                //   ),
                                //   // height: 50,
                                // ),
                              ],
                            ),
                            // SizedBox(height: 5.0),
                            Divider(
                              color: Colors.grey,
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
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
                                                  AppLocalizations.of(context)!
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
                                                  AppLocalizations.of(context)!
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

                            Divider(
                              color: Colors.grey,
                              height: 10,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.description,
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
                                      // color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notification_add,
                                  size: 14,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 10.0),
                                SizedBox(
                                  width: 288.0,
                                  child: Text(
                                    "${data[index]['notifications'].length}",
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.red,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (pm.sysUserType == "1" ||
                                    pm.sysUserType == "2") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Notifylar(
                                              token: token.toString(),
                                              jdata: data[index],
                                            )),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DriverNot(
                                              token: token.toString(),
                                              jdata: data[index],
                                            )),
                                  );
                                }
                              },
                              child: Text(
                                  AppLocalizations.of(context)!.otkrytUvedom),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          );
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
        title: Text(
      AppLocalizations.of(context)!.zakrit,
      style: TextStyle(color: Colors.blueAccent),
    )),
  );
}
