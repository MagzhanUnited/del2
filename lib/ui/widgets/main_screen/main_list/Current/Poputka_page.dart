import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/order/driver_datail_card.dart';
import 'package:themoviedb/full/ui/register/register_step1_page.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/src/place_picker.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/my_app.dart';
import '../../menu_list/profile/my_cars.dart';

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PoputkaView extends StatefulWidget {
  PoputkaView({Key? key}) : super(key: key);

  @override
  _PoputkaViewState createState() => _PoputkaViewState();
}

String orderBy = '';
String carT = '';
String money = '';

class _PoputkaViewState extends State<PoputkaView> {
  dynamic data = [];
  bool load = true;
  final pm = ProfileModel();
  bool _isdanger = false;
  bool _isdogruz = false;
  var carTypeTxt = '';

  List<String> CarTypes = [];
  List<int> TypeId = [];

  var f = DriverFiltering(
    beginCityName: TextEditingController(),
    endCityName: TextEditingController(),
    beginPrice: TextEditingController(),
    endPrice: TextEditingController(),
    beginDate: TextEditingController(),
    endDate: TextEditingController(),
    isdanger: -1,
    isdogruz: -1,
    carTypeId: 0,
    brandId: 0,
    modelId: 0,
    cur_id: '0',
    orderBy: TextEditingController(text: 'driver'),
    orderType: TextEditingController(text: 'desc'),
  );

  CarTypeDetail? CarTypeDet;
  List<String> currency_name = [];
  List<String> currency_id = [];

  List<String> brand_name = [];
  List<int> brand_id = [];

  List<String> model_name = [];
  List<int> model_id = [];

  // Timer? _timer;

  void resetElements() {
    orderBy = '';
    carT = '';
    money = '';
  }

  @override
  void initState() {
    super.initState();

    orderBy = '';
    carT = '';
    money = '';

    _isdanger = false;
    _isdogruz = false;

    currency_name = [];
    currency_id = [];

    brand_name = [];
    brand_id = [];

    model_name = [];
    model_id = [];

    pm.setupLocale(context).then((value) async {
      print(pm.token);

      await GetCarBrands(
        token: pm.token.toString(),
      ).get().then(
        (value) {
          if (value.toString() == '401') {
            final provider = SessionDataProvider();
            provider.setSessionId(null);
            Navigator.of(context).pushNamedAndRemoveUntil(
                MainNavigationRouteNames.changeLang,
                (Route<dynamic> route) => false);
          }

          if (value != 'error') {
            var temp = json.decode(value);

            for (var item in temp["carBrands"]) {
              brand_id.add(item['brandId']);
              brand_name.add(item['brandNameRu'].toString());
            }
            setState(() {});
            print('GetCarBrands ${temp.length}');
          } else {
            print('Не удалось получить GetCarBrands');
          }
        },
      );

      await CurrencyList(
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
            var temp = json.decode(value);
            for (var item in temp) {
              currency_id.add(item['currencyId'].toString());
              currency_name.add(item['currencyCode'].toString());
            }
            setState(() {});
            print('CurrencyList ${temp.length}');
          } else {
            print('Не удалось получить CurrencyList');
          }
        },
      );

      await GetCarType(
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
          } else {
            final parsedJson = jsonDecode(value);
            CarTypeDet = CarTypeDetail.fromJson(parsedJson);

            for (var item in CarTypeDet!.carTypes) {
              CarTypes.add(item.nameRu);
              TypeId.add(item.carTypeId);
            }
          }
        },
      );

      if (pm.sysUserType == "0") {
        GetPoputki(
          token: pm.token.toString(),
          data: f.toJson(),
        ).getGuest().then(
          (value) {
            if (value.toString() == '401') {
              final provider = SessionDataProvider();
              provider.setSessionId(null);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MainNavigationRouteNames.changeLang,
                  (Route<dynamic> route) => false);
            }

            try {
              setState(() {
                data = json.decode(value) as List;
                load = false;
              });
            } catch (e) {
              print('GetPoputki error ===> $e');
            }
          },
        );
      } else {
        GetPoputki(
          token: pm.token.toString(),
          data: f.toJson(),
        ).get().then(
          (value) {
            if (value.toString() == '401') {
              final provider = SessionDataProvider();
              provider.setSessionId(null);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MainNavigationRouteNames.changeLang,
                  (Route<dynamic> route) => false);
            }

            try {
              setState(() {
                data = json.decode(value) as List;
                load = false;
              });
            } catch (e) {
              print('GetPoputki error ===> $e');
            }
          },
        );

        // _timer = Timer.periodic(Duration(seconds: 15), (Timer t) {
        //   print(DateTime.now());

        //   GetPoputki(
        //     token: pm.token.toString(),
        //     data: f.toJson(),
        //   ).get().then(
        //     (value) {
        //       if (value.toString() == '401') {
        //         final provider = SessionDataProvider();
        //         provider.setSessionId(null);
        //         Navigator.of(context).pushNamedAndRemoveUntil(
        //             MainNavigationRouteNames.changeLang,
        //             (Route<dynamic> route) => false);
        //       }

        //       try {
        //         setState(() {
        //           result = json.decode(value) as List;
        //           load = false;
        //         });
        //       } catch (e) {
        //         print('GetPoputki error ===> $e');
        //       }
        //     },
        //   );
        // });
      }
    });
  }

  // @override
  // void dispose() {
  //   _timer?.cancel();
  //   super.dispose();
  // }

  void getModelByBrand(int brandId) {
    GetCarModels(token: pm.token, brandId: brandId).get().then(
      (value) {
        if (value.toString() == '401') {
          final provider = SessionDataProvider();
          provider.setSessionId(null);
          Navigator.of(context).pushNamedAndRemoveUntil(
              MainNavigationRouteNames.changeLang,
              (Route<dynamic> route) => false);
        }

        if (value != 'error') {
          var temp = json.decode(value);

          for (var item in temp["carModels"]) {
            model_id.add(item['modelId']);
            model_name.add(item['modelNameRu'].toString());
          }
          setState(() {});
          print('GetCarModels ${temp.length}');
        } else {
          print('Не удалось получить GetCarModels');
        }
      },
    );
  }

  void GetFilter() {
    if (pm.sysUserType == "0") {
      GetPoputki(
        token: pm.token.toString(),
        data: f.toJson(),
      ).getGuest().then(
        (value) {
          if (value.toString() == '401') {
            final provider = SessionDataProvider();
            provider.setSessionId(null);
            Navigator.of(context).pushNamedAndRemoveUntil(
                MainNavigationRouteNames.changeLang,
                (Route<dynamic> route) => false);
          }

          try {
            setState(() {
              data = json.decode(value) as List;
              load = false;
            });
          } catch (e) {
            print('GetPoputki error ===> $e');
          }
        },
      );
    } else {
      GetPoputki(
        token: pm.token.toString(),
        data: f.toJson(),
      ).get().then(
        (value) {
          if (value.toString() == '401') {
            final provider = SessionDataProvider();
            provider.setSessionId(null);
            Navigator.of(context).pushNamedAndRemoveUntil(
                MainNavigationRouteNames.changeLang,
                (Route<dynamic> route) => false);
          }

          try {
            setState(() {
              data = json.decode(value) as List;
              load = false;
            });
          } catch (e) {
            print('GetPoputki error ===> $e');
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.poputPerevozki),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // filter(context);
              DriverSettings(context);
            },
            icon: Image.asset(
              "images/poisk.gruza.filter.icon.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
            ),
          ),
          // TextButton(
          //   onPressed: () {
          //     filter(context);
          //   },
          //   child: Icon(
          //     Icons.filter_list_rounded,
          //     color: Colors.black,
          //   ),
          // ),
        ],
      ),
      body: load
          ? LoadingData()
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

                      var brand = data[index]['car']['brandNameRu']
                          .toString()
                          .toUpperCase();
                      var model = data[index]['car']['modelNameRu']
                          .toString()
                          .toUpperCase();

                      var carDet1 = '${brand} ${model} ';

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${NumberFormat("#,##0", "pt_BR").format(data[index]['bookerOfferPrice'])} ${data[index]['currencyIcon']}',
                                          style: TextStyle(
                                              // color: AppColors.primaryColors[0],
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
                                                                .primaryColors[0]),
                                                    SizedBox(width: 6.0),
                                                    Text(
                                                      // filteredData[index].name,
                                                      formatted.toString(),
                                                      style: TextStyle(
                                                          // color: AppColors
                                                          //     .primaryColors[0],
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400),
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
                                  ],
                                ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    Column(
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
                                                  '${AppLocalizations.of(context)!.gruzPerevoz}:',
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .primaryColors[3],
                                                      fontSize: 12,
                                                      letterSpacing: 0.3,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(height: 8.0),
                                                Text(
                                                  creator.toUpperCase(),
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                SizedBox(height: 20.0),
                                                Text(
                                                  '${AppLocalizations.of(context)!.avto}:',
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .primaryColors[3],
                                                      fontSize: 12,
                                                      letterSpacing: 0.3,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(height: 8.0),
                                                Text(
                                                  "${carDet1.toUpperCase()}",
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // _onBasicAlertPressed(context);
                                            if (pm.sysUserType == "0") {
                                              _onBasicAlertPressed(context);
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DriverDatailCardView(
                                                    jdata: data[index],
                                                    myCars: null,
                                                    myDrivers: null,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.description,
                                                size: 13,
                                              ),
                                              Text(AppLocalizations.of(context)!
                                                  .podrobnoe),
                                            ],
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.green),
                                          onPressed: () {
                                            if (pm.sysUserType == "0") {
                                              _onBasicAlertPressed(context);
                                            } else {
                                              _launchURL(
                                                  '${data[index]['creator']['orderInChargePhone']}');
                                            }
                                            //  _onBasicAlertPressed(context);
                                            // _callNumber(result[index]['creator']
                                            //     ['orderInChargePhone']);
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.phone,
                                                size: 13,
                                              ),
                                              Text(AppLocalizations.of(context)!
                                                  .call),
                                            ],
                                          ),
                                        ),
                                      ],
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
                    fontWeight: FontWeight.bold,
                    // color: Colors.black54,
                  ),
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

  // Column PoputkaData() {
  //   return Column(
  //     children: <Widget>[
  //       Expanded(
  //         child: ListView.builder(
  //           padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  //           itemCount: result.length,
  //           // itemExtent: 221,
  //           itemBuilder: (BuildContext context, int index) {
  //             return Card(
  //               elevation: 20,
  //               child: Padding(
  //                 padding:
  //                     const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       // formatted,
  //                       result[index]['beginPointName'],
  //                       style: TextStyle(
  //                         fontSize: 13.0,
  //                         fontWeight: FontWeight.bold,
  //                         // color: Colors.black87,
  //                       ),
  //                     ),
  //                     Text(
  //                       // formatted,
  //                       result[index]['endPointName'],
  //                       style: TextStyle(
  //                         fontSize: 13.0,
  //                         fontWeight: FontWeight.normal,
  //                         // color: Colors.grey,
  //                       ),
  //                     ),
  //                     SizedBox(height: 5),
  //                     Text(
  //                       // formatted,
  //                       "${NumberFormat("#,##0", "pt_BR").format(result[index]['bookerOfferPrice'])} ${result[index]['currencyIcon']}",
  //                       style: TextStyle(
  //                         fontSize: 13.0,
  //                         fontWeight: FontWeight.normal,
  //                         color: Colors.red,
  //                       ),
  //                     ),
  //                     SizedBox(height: 5),
  //                     Text(
  //                       // formatted,
  //                       result[index]['tripDate'],
  //                       style: TextStyle(
  //                         fontSize: 13.0,
  //                         fontWeight: FontWeight.normal,
  //                         // color: Colors.grey,
  //                       ),
  //                     ),
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           result[index]['creator']['orderInChargeName'],
  //                           style: TextStyle(
  //                             fontSize: 13.0,
  //                             fontWeight: FontWeight.normal,
  //                             // color: Colors.black,
  //                           ),
  //                         ),
  //                         Text(
  //                           " ",
  //                           style: TextStyle(
  //                             fontSize: 13.0,
  //                             fontWeight: FontWeight.normal,
  //                             // color: Colors.black,
  //                           ),
  //                         ),
  //                         Icon(
  //                           Icons.star_rounded,
  //                           color: AppColors.mainOrange,
  //                           size: 13,
  //                         ),
  //                         Text(
  //                           '5.0',
  //                           style: TextStyle(
  //                             fontSize: 13.0,
  //                             fontWeight: FontWeight.normal,
  //                             // color: Colors.black,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(width: 10),
  //                     Text(
  //                       '${result[index]['car']['carTypeNameRu']} ${result[index]['car']['carWeight']}T',
  //                       style: TextStyle(
  //                         fontSize: 13.0,
  //                         fontWeight: FontWeight.normal,
  //                         // color: Colors.black,
  //                       ),
  //                     ),
  //                     Text(
  //                       '${result[index]['car']['brandNameRu']} ${result[index]['car']['modelNameRu']} ${result[index]['car']['modelYear']}'
  //                           .toUpperCase(),
  //                       style: TextStyle(
  //                         fontSize: 13.0,
  //                         fontWeight: FontWeight.normal,
  //                         // color: Colors.black,
  //                       ),
  //                     ),
  //                     Text(
  //                       '${result[index]['car']['carNumber']}'.toUpperCase(),
  //                       style: TextStyle(
  //                         fontSize: 13.0,
  //                         fontWeight: FontWeight.bold,
  //                         // color: Colors.black,
  //                       ),
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         ElevatedButton(
  //                           onPressed: () {
  //                             // _onBasicAlertPressed(context);
  //                             if (pm.sysUserType == "0") {
  //                               _onBasicAlertPressed(context);
  //                             } else {
  //                               Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                   builder: (context) => DriverDatailCardView(
  //                                     jdata: result[index],
  //                                     myCars: null,
  //                                     myDrivers: null,
  //                                   ),
  //                                 ),
  //                               );
  //                             }
  //                           },
  //                           child: Row(
  //                             children: [
  //                               Icon(
  //                                 Icons.description,
  //                                 size: 13,
  //                               ),
  //                               const Text(' Подробнее'),
  //                             ],
  //                           ),
  //                         ),
  //                         ElevatedButton(
  //                           style:
  //                               ElevatedButton.styleFrom(primary: Colors.green),
  //                           onPressed: () {
  //                             if (pm.sysUserType == "0") {
  //                               _onBasicAlertPressed(context);
  //                             } else {
  //                               _launchURL(
  //                                   '${result[index]['creator']['orderInChargePhone']}');
  //                             }
  //                             //  _onBasicAlertPressed(context);
  //                             // _callNumber(result[index]['creator']
  //                             //     ['orderInChargePhone']);
  //                           },
  //                           child: Row(
  //                             children: [
  //                               Icon(
  //                                 Icons.phone,
  //                                 size: 13,
  //                               ),
  //                               const Text(' Позвонить'),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       )
  //     ],
  //   );
  // }

  void filter(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final textStyle = const TextStyle(
          fontSize: 16,
          color: Color(0xff212529),
        );
        return AlertDialog(
          // contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          title: Text('Cортировка и фильтрация'),
          content: Container(
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  DropdownSearch<String>(
                    mode: Mode.BOTTOM_SHEET,
                    showSearchBox: true,
                    showSelectedItem: true,
                    items: sortData,
                    label: "Сортировка",
                    selectedItem: sortData.first,
                    onChanged: (newValue) {
                      print(newValue);

                      switch (sortData
                          .indexWhere((element) => element == newValue)) {
                        case 0:
                          setState(() {
                            f.orderBy.text = 'driver';
                            f.orderType.text = 'desc';
                          });
                          break;
                        case 1:
                          setState(() {
                            f.orderBy.text = 'driver';
                            f.orderType.text = 'asc';
                          });
                          break;
                        case 2:
                          setState(() {
                            f.orderBy.text = 'rank';
                            f.orderType.text = 'desc';
                          });
                          break;
                        case 3:
                          setState(() {
                            f.orderBy.text = 'rank';
                            f.orderType.text = 'asc';
                          });
                          break;
                        case 4:
                          setState(() {
                            f.orderBy.text = 'byPrice';
                            f.orderType.text = 'desc';
                          });
                          break;
                        case 5:
                          setState(() {
                            f.orderBy.text = 'byPrice';
                            f.orderType.text = 'asc';
                          });
                          break;
                        default:
                      }
                      // setState(() {
                      //   selectYear = newValue!;
                      // });
                    },
                  ),
                  SizedBox(height: 15),
                  TextField(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PlacePicker(
                              apiKey: 'AIzaSyAkUdrVbgXV_52Qrid_vdeqzTbBfmFxrNM',
                              initialPosition: LatLng(-33.8567844, 151.213108),
                              useCurrentLocation: true,
                              selectInitialPosition: true,
                              autocompleteLanguage: "ru",

                              //usePlaceDetailSearch: true,
                              onPlacePicked: (result) {
                                var city = result.addressComponents!
                                    .where((e) => e.types.first == 'locality')
                                    .first
                                    .longName;

                                f.beginCityName.text = city;

                                Navigator.of(context).pop();
                                setState(() {});
                              },
                            );
                          },
                        ),
                      );
                    },
                    controller: f.beginCityName,
                    style: TextStyle(fontSize: 15),
                    enabled: true,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      isDense: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 3, horizontal: 0),
                      labelText: 'Откуда',
                      prefixIcon: SizedBox(
                        child: Center(
                          widthFactor: 0.0,
                          child: Ink(
                            width: 35,
                            decoration: const ShapeDecoration(
                              shape: CircleBorder(
                                  side: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                            child: Center(
                              child: Text("A",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PlacePicker(
                              apiKey: 'AIzaSyAkUdrVbgXV_52Qrid_vdeqzTbBfmFxrNM',
                              initialPosition: LatLng(-33.8567844, 151.213108),
                              useCurrentLocation: true,
                              selectInitialPosition: true,
                              autocompleteLanguage: "ru",

                              //usePlaceDetailSearch: true,
                              onPlacePicked: (result) {
                                var city = result.addressComponents!
                                    .where((e) => e.types.first == 'locality')
                                    .first
                                    .longName;

                                f.endCityName.text = city;

                                Navigator.of(context).pop();
                                setState(() {});
                              },
                            );
                          },
                        ),
                      );
                    },
                    controller: f.endCityName,
                    style: TextStyle(fontSize: 15),
                    enabled: true,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      isDense: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 3, horizontal: 0),
                      labelText: 'Куда',
                      prefixIcon: SizedBox(
                        child: Center(
                          widthFactor: 0.0,
                          child: Ink(
                            width: 35,
                            decoration: const ShapeDecoration(
                              shape: CircleBorder(
                                  side: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                            child: Center(
                              child: Text("Б",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text('Дата', style: textStyle),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: new TextFormField(
                            onTap: () {
                              DatePicker.showDatePicker(
                                context,
                                currentTime: DateTime.now(),
                                locale: LocaleType.ru,
                                showTitleActions: true,
                                minTime: DateTime(
                                  DateTime.now().year - 1,
                                  // DateTime.now().month, DateTime.now().day
                                ),
                                maxTime: DateTime(DateTime.now().year + 1),
                                onConfirm: (date) {
                                  setState(() {
                                    f.beginDate.text =
                                        new DateFormat('yyyy.MM.dd')
                                            .format(date);
                                  });
                                },
                              );
                            },
                            keyboardType: TextInputType.number,
                            controller: f.beginDate,
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: false,
                                contentPadding: EdgeInsets.all(15),
                                labelText: "От"),
                          ),
                        ),
                      ),
                      new Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: new TextFormField(
                            onTap: () {
                              DatePicker.showDatePicker(
                                context,
                                currentTime: DateTime.now(),
                                locale: LocaleType.ru,
                                showTitleActions: true,
                                minTime: DateTime(
                                  DateTime.now().year - 1,
                                  // DateTime.now().month, DateTime.now().day
                                ),
                                maxTime: DateTime(DateTime.now().year + 1),
                                onConfirm: (date) {
                                  setState(() {
                                    f.endDate.text =
                                        new DateFormat('yyyy.MM.dd')
                                            .format(date);
                                  });
                                },
                              );
                            },
                            keyboardType: TextInputType.number,
                            controller: f.endDate,
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(15),
                                labelText: "До"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text('Цена', style: textStyle),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: new TextFormField(
                            keyboardType: TextInputType.number,
                            controller: f.beginPrice,
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: false,
                                contentPadding: EdgeInsets.all(15),
                                labelText: "От"),
                          ),
                        ),
                      ),
                      new Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: new TextFormField(
                            keyboardType: TextInputType.number,
                            controller: f.endPrice,
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(15),
                                labelText: "До"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  DropdownSearch<String>(
                    mode: Mode.BOTTOM_SHEET,
                    showSearchBox: true,
                    showSelectedItem: true,
                    items: currency_name,
                    label: "Валюта",
                    selectedItem: "выбрать",
                    onChanged: (newValue) {
                      f.cur_id = currency_id[currency_name.indexOf(newValue!)];
                      setState(() {});
                    },
                  ),
                  ListTileSwitch(
                    value: _isdanger,
                    leading: const Icon(Icons.dangerous_outlined),
                    onChanged: (value) {
                      setState(() {
                        _isdanger = value;
                        f.isdanger = _isdanger ? 1 : 0;
                      });
                      Navigator.of(context).pop();
                      filter(context);
                    },
                    switchActiveColor: Colors.teal,
                    switchScale: 1,
                    switchType: SwitchType.cupertino,
                    title: const Text(
                      'Опасный груз',
                    ),
                  ),
                  ListTileSwitch(
                    value: _isdogruz,
                    leading: const Icon(Icons.add_road),
                    onChanged: (value) {
                      setState(() {
                        _isdogruz = value;
                        f.isdogruz = _isdogruz ? 1 : 0;
                      });
                      Navigator.of(context).pop();
                      filter(context);
                    },
                    switchActiveColor: Colors.teal,
                    switchScale: 1,
                    // subtitle: const Text(
                    //   'Комментарии',
                    // ),
                    switchType: SwitchType.cupertino,
                    title: const Text(
                      'Догруз',
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownSearch<String>(
                    mode: Mode.BOTTOM_SHEET,
                    showSearchBox: true,
                    showSelectedItem: true,
                    items: CarTypes,
                    label: "Тип кузова",
                    selectedItem: f.carTypeId == 0
                        ? "выбрать"
                        : CarTypes[TypeId.indexWhere(
                            (element) => element == f.carTypeId)],
                    onChanged: (newValue) {
                      print(newValue);

                      var idd =
                          CarTypes.indexWhere((element) => element == newValue);
                      f.carTypeId = TypeId[idd];
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownSearch<String>(
                    mode: Mode.BOTTOM_SHEET,
                    showSearchBox: true,
                    showSelectedItem: true,
                    items: brand_name,
                    label: "Марка",
                    selectedItem: f.brandId == 0
                        ? "выбрать"
                        : brand_name[brand_id
                            .indexWhere((element) => element == f.brandId)],
                    onChanged: (newValue) {
                      print(newValue);

                      var idd = brand_name
                          .indexWhere((element) => element == newValue);
                      f.brandId = brand_id[idd];
                      getModelByBrand(f.brandId);

                      setState(() {});
                      Navigator.of(context).pop();
                      filter(context);
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownSearch<String>(
                    mode: Mode.BOTTOM_SHEET,
                    showSearchBox: true,
                    showSelectedItem: true,
                    items: model_name,
                    label: "Модель",
                    selectedItem: f.modelId == 0
                        ? "выбрать"
                        : model_name[model_id
                            .indexWhere((element) => element == f.modelId)],
                    onChanged: (newValue) {
                      print(newValue);

                      var idd = model_name
                          .indexWhere((element) => element == newValue);
                      f.modelId = model_id[idd];
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
          elevation: 24,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cбросить',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                f.resetFilter();
                setState(() {});
                GetFilter();
              },
            ),
            TextButton(
              child: Text(
                'Показать',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();

                GetFilter();
              },
            ),
            TextButton(
              child: Text(
                'Отменить',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void DriverSettings(BuildContext context) {
    showModalBottomSheet(
      barrierColor: AppColors.primaryColors[0].withOpacity(0.9),
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      builder: (_) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter state) {
          final provider = Provider.of<LocaleProvider>(context);

          var fSt = TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            // color: AppColors.primaryColors[0],
          );
          var fDec = InputDecoration(
            isDense: true,
            fillColor: provider.selectedThemeMode == ThemeMode.dark
                ? Color.fromRGBO(53, 54, 61, 1)
                : Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(228, 232, 250, 1)),
            ),
          );

          return FractionallySizedBox(
            heightFactor: 0.9,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.nastroikiPoiska,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            // color: AppColors.primaryColors[0],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.close))
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.sort,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            // color: AppColors.primaryColors[0],
                          ),
                        ),
                        SizedBox(height: 8),
                        DropdownSearch<String>(
                          dropdownSearchDecoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            isDense: true,
                            fillColor:
                                provider.selectedThemeMode == ThemeMode.dark
                                    ? Color.fromRGBO(53, 54, 61, 1)
                                    : Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(228, 232, 250, 1))),
                          ),
                          dropDownButton: Image.asset(
                            "images/Vector30.png",
                            height: 8,
                          ),
                          mode: Mode.BOTTOM_SHEET,
                          showSearchBox: true,
                          showSelectedItem: true,
                          items: sortData,
                          selectedItem: orderBy,
                          onChanged: (newValue) {
                            print(newValue);
                            orderBy = newValue!;

                            switch (sortData
                                .indexWhere((element) => element == newValue)) {
                              case 0:
                                f.orderBy.text = 'client';
                                f.orderType.text = 'desc';
                                break;
                              case 1:
                                f.orderBy.text = 'client';
                                f.orderType.text = 'asc';
                                break;
                              case 2:
                                f.orderBy.text = 'rank';
                                f.orderType.text = 'desc';
                                break;
                              case 3:
                                f.orderBy.text = 'rank';
                                f.orderType.text = 'asc';
                                break;
                              case 4:
                                f.orderBy.text = 'byPrice';
                                f.orderType.text = 'desc';
                                break;
                              case 5:
                                f.orderBy.text = 'byPrice';
                                f.orderType.text = 'asc';
                                break;
                              default:
                            }
                            state(() {});
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(80, 155, 213, 1).withOpacity(0.1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.from,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              // color: AppColors.primaryColors[0],
                            ),
                          ),
                          SizedBox(height: 8),
                          InkWell(
                            child: TextField(
                              enabled: false,
                              controller: f.beginCityName,
                              style: fSt,
                              decoration: fDec,
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
                                        var locality = result.addressComponents!
                                            .where((e) =>
                                                e.types.first == 'locality')
                                            .first
                                            .longName;

                                        f.beginCityName.text = locality;

                                        Navigator.of(context).pop();
                                        state(() {});
                                        setState(() {});
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.to,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              // color: AppColors.primaryColors[0],
                            ),
                          ),
                          SizedBox(height: 8),
                          InkWell(
                            child: TextField(
                              enabled: false,
                              controller: f.endCityName,
                              style: fSt,
                              decoration: fDec,
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
                                        var locality = result.addressComponents!
                                            .where((e) =>
                                                e.types.first == 'locality')
                                            .first
                                            .longName;

                                        f.endCityName.text = locality;

                                        Navigator.of(context).pop();
                                        state(() {});
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      AppLocalizations.of(context)!.tipKuzova,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        // color: AppColors.primaryColors[0],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: DropdownSearch<String>(
                      dropdownSearchDecoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8),
                        isDense: true,
                        fillColor: provider.selectedThemeMode == ThemeMode.dark
                            ? Color.fromRGBO(53, 54, 61, 1)
                            : Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(228, 232, 250, 1))),
                      ),
                      dropDownButton: Image.asset(
                        "images/Vector30.png",
                        height: 8,
                      ),
                      mode: Mode.BOTTOM_SHEET,
                      showSearchBox: true,
                      showSelectedItem: true,
                      items: CarTypes,
                      selectedItem: carT,
                      onChanged: (newValue) {
                        print(newValue);
                        carT = newValue!;

                        var idd = CarTypes.indexWhere(
                            (element) => element == newValue);
                        f.carTypeId = TypeId[idd];
                        setState(() {});
                        state(() {});
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      AppLocalizations.of(context)!.date,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        // color: AppColors.primaryColors[0],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: new TextFormField(
                              onTap: () {
                                DatePicker.showDatePicker(
                                  context,
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.ru,
                                  showTitleActions: true,
                                  minTime: DateTime(
                                    DateTime.now().year - 1,
                                    // DateTime.now().month, DateTime.now().day
                                  ),
                                  maxTime: DateTime(DateTime.now().year + 1),
                                  onConfirm: (date) {
                                    setState(() {
                                      f.beginDate.text =
                                          new DateFormat('yyyy.MM.dd')
                                              .format(date);
                                    });
                                  },
                                );
                              },
                              keyboardType: TextInputType.number,
                              controller: f.beginDate,
                              style: TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: false,
                                  fillColor: provider.selectedThemeMode ==
                                          ThemeMode.dark
                                      ? Color.fromRGBO(53, 54, 61, 1)
                                      : Colors.white,
                                  contentPadding: EdgeInsets.all(15),
                                  labelText:
                                      AppLocalizations.of(context)!.otTsena),
                            ),
                          ),
                        ),
                        new Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: new TextFormField(
                              onTap: () {
                                DatePicker.showDatePicker(
                                  context,
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.ru,
                                  showTitleActions: true,
                                  minTime: DateTime(
                                    DateTime.now().year - 1,
                                    // DateTime.now().month, DateTime.now().day
                                  ),
                                  maxTime: DateTime(DateTime.now().year + 1),
                                  onConfirm: (date) {
                                    setState(() {
                                      f.endDate.text =
                                          new DateFormat('yyyy.MM.dd')
                                              .format(date);
                                    });
                                  },
                                );
                              },
                              keyboardType: TextInputType.number,
                              controller: f.endDate,
                              style: TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  fillColor: provider.selectedThemeMode ==
                                          ThemeMode.dark
                                      ? Color.fromRGBO(53, 54, 61, 1)
                                      : Colors.white,
                                  contentPadding: EdgeInsets.all(15),
                                  labelText:
                                      AppLocalizations.of(context)!.doTsena),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      AppLocalizations.of(context)!.prise,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        // color: AppColors.primaryColors[0],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: new TextFormField(
                              keyboardType: TextInputType.number,
                              controller: f.beginPrice,
                              style: TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: false,
                                  fillColor: provider.selectedThemeMode ==
                                          ThemeMode.dark
                                      ? Color.fromRGBO(53, 54, 61, 1)
                                      : Colors.white,
                                  contentPadding: EdgeInsets.all(15),
                                  labelText:
                                      AppLocalizations.of(context)!.otTsena),
                            ),
                          ),
                        ),
                        new Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: new TextFormField(
                              keyboardType: TextInputType.number,
                              controller: f.endPrice,
                              style: TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  fillColor: provider.selectedThemeMode ==
                                          ThemeMode.dark
                                      ? Color.fromRGBO(53, 54, 61, 1)
                                      : Colors.white,
                                  contentPadding: EdgeInsets.all(15),
                                  labelText:
                                      AppLocalizations.of(context)!.doTsena),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      AppLocalizations.of(context)!.currency,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        // color: AppColors.primaryColors[0],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: DropdownSearch<String>(
                      dropdownSearchDecoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8),
                        isDense: true,
                        fillColor: provider.selectedThemeMode == ThemeMode.dark
                            ? Color.fromRGBO(53, 54, 61, 1)
                            : Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(228, 232, 250, 1))),
                      ),
                      dropDownButton:
                          Image.asset("images/Vector30.png", height: 8),
                      mode: Mode.BOTTOM_SHEET,
                      showSearchBox: true,
                      showSelectedItem: true,
                      items: currency_name,
                      selectedItem: money,
                      onChanged: (newValue) {
                        money = newValue!;

                        f.cur_id = currency_id[currency_name.indexOf(newValue)];
                        setState(() {});
                        state(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTileSwitch(
                          value: f.isdanger == -1 ? false : _isdanger,
                          leading: const Icon(Icons.dangerous_outlined),
                          onChanged: (value) {
                            _isdanger = value;
                            f.isdanger = _isdanger ? 1 : 0;
                            setState(() {});
                            state(() {});
                          },
                          switchActiveColor: Colors.teal,
                          switchScale: 1,
                          switchType: SwitchType.cupertino,
                          title: Text(
                            AppLocalizations.of(context)!.opasnuiGruz,
                          ),
                        ),
                        ListTileSwitch(
                          value: f.isdogruz == -1 ? false : _isdogruz,
                          leading: const Icon(Icons.add_road),
                          onChanged: (value) {
                            _isdogruz = value;
                            f.isdogruz = _isdogruz ? 1 : 0;
                            setState(() {});
                            state(() {});
                          },
                          switchActiveColor: Colors.teal,
                          switchScale: 1,
                          // subtitle: const Text(
                          //   'Комментарии',
                          // ),
                          switchType: SwitchType.cupertino,
                          title: Text(
                            AppLocalizations.of(context)!.dogruz,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();

                            GetFilter();

                            state(() {});
                            setState(() {});
                          },
                          label: Text(AppLocalizations.of(context)!.primenit),
                          icon: Image.asset("images/11check.png",
                              width: 16, height: 16, color: Colors.white),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            f.resetFilter();
                            GetFilter();

                            resetElements();

                            state(() {});
                            setState(() {});
                          },
                          label: Text(AppLocalizations.of(context)!.sbrosit),
                          icon:
                              Icon(Icons.refresh_rounded, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

var sortData = [
  "Сначала свежие объявления",
  "Сначала старые объявления",
  "По убыванию ранга",
  "По возрастанию ранга",
  "По убыванию цены",
  "По возрастанию цены",
];

final textStyle = const TextStyle(
  fontSize: 16,
  // color: Color(0xff212529),
);

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
      desc: AppLocalizations.of(context)!.dlyaProdRabotyZareg,
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterStep1View()),
            );
          },
          child: Text(
            AppLocalizations.of(context)!.register,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
}

_launchURL(String phoneNumber) async {
  var url = 'tel:$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class DriverFiltering {
  TextEditingController beginCityName = TextEditingController();
  TextEditingController endCityName = TextEditingController();
  TextEditingController beginPrice = TextEditingController();
  TextEditingController endPrice = TextEditingController();
  TextEditingController beginDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  int isdanger = -1;
  int isdogruz = -1;

  int carTypeId = 0;

  int brandId = 0;
  int modelId = 0;

  String cur_id = '-1';

  TextEditingController orderBy = TextEditingController(text: 'driver');
  TextEditingController orderType = TextEditingController(text: 'desc');

  DriverFiltering({
    required this.beginCityName,
    required this.endCityName,
    required this.beginPrice,
    required this.endPrice,
    required this.beginDate,
    required this.endDate,
    required this.isdanger,
    required this.isdogruz,
    required this.carTypeId,
    required this.brandId,
    required this.modelId,
    required this.cur_id,
    required this.orderBy,
    required this.orderType,
  });

  void resetFilter() async {
    beginCityName.text = '';
    endCityName.text = '';
    beginPrice.text = '';
    endPrice.text = '';
    beginDate.text = '';
    endDate.text = '';
    isdanger = -1;
    isdogruz = -1;
    carTypeId = 0;
    brandId = 0;
    modelId = 0;
    cur_id = '0';
    orderBy.text = 'driver';
    orderType.text = 'desc';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['beginCityName'] = this.beginCityName.text;
    data['endCityName'] = this.endCityName.text;

    data['beginPrice'] =
        this.beginPrice.text.isEmpty ? 0 : int.parse(this.beginPrice.text);
    data['endPrice'] =
        this.endPrice.text.isEmpty ? 0 : int.parse(this.endPrice.text);

    data['beginDate'] = this.beginDate.text;
    data['endDate'] = this.endDate.text;

    data['isAdd'] = this.isdanger;
    data['isDanger'] = this.isdogruz;

    data['currencyId'] = this.cur_id;

    data['carTypeId'] = this.carTypeId;
    data['brandId'] = brandId;
    data['modelId'] = modelId;

    data['orderBy'] = this.orderBy.text; //"rank";
    data['orderType'] = this.orderType.text; // "asc"

    return data;
  }
}
