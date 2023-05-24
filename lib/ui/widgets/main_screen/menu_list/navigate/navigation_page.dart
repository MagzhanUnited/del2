import 'dart:async';
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/google_maps_place_picker.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/bottom_screens/menu_page.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_list/Current/current_page.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../full/ui/order/Select_order_type_page.dart';
import '../../../app/my_app.dart';
import '../../main_list/Current/Poputka_page.dart';
import '../ZayavitTransport.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'locations.dart' as locations;

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({Key? key}) : super(key: key);

  @override
  _NavigationViewState createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();

    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          icon: office.type == "1"
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
              : BitmapDescriptor.defaultMarker,
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "CarNet",
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w600),
              ),
              Text(
                "Навигация",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              )
            ],
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black87,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          automaticallyImplyLeading: true,
          actions: <Widget>[
            Opacity(
              opacity: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.share,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: GoogleMap(
          mapType: MapType.terrain,

          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(51.188139, 71.457105),
            zoom: 10,
          ),
          // markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}

bool clickSVH = true;
bool clickTLC = true;
bool clickKoridor = true;
bool clickPP = true;
// bool _isdanger = false;

class NavigationMiniView extends StatefulWidget {
  const NavigationMiniView({Key? key}) : super(key: key);

  @override
  _NavigationMiniViewState createState() => _NavigationMiniViewState();
}

var filtering = NaviFiltering(
  CityCvh: TextEditingController(),
  ClassesCvh: TextEditingController(),
  beginCountryKoridor: TextEditingController(),
  endCountryKoridor: TextEditingController(),
  carTypeCoridor: 0,
  RoadPP: -1,
  TimePP: -1,
  CountryPP: TextEditingController(),
);

class _NavigationMiniViewState extends State<NavigationMiniView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  BitmapDescriptor? pinLocationIconSVH;
  BitmapDescriptor? pinLocationIconTLC;

  Map<String, Marker> _markers = {};
  Map<String, Marker> _markersKoridor = {};
  MapType _currentMapType = MapType.terrain;

  dynamic googleOfficesCopy = {};
  dynamic DataCoridors = [];
  dynamic DataControlPoints = [];
  dynamic DataSvhTlc = [];
  ProfileModel pm = ProfileModel();

  @override
  void initState() {
    pm.setupLocale(context).then((value) async {
      await LoadSvhTlc(
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
            DataSvhTlc = docs;
            drowSvhTlC();
            print('LoadSvhTlc Sucsess (${docs.length})');
          } else {
            print('Не удалось получить список LoadSvhTlc');
          }
          setState(() {});
        },
      );

      await Loadcontrolpoints(
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
            DataControlPoints = docs;
            drowCP();
            print('Loadcontrolpoints Sucsess (${docs.length})');
          } else {
            print('Не удалось получить список Loadcontrolpoints');
          }
          setState(() {});
        },
      );

      await LoadCoridors(
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
            DataCoridors = docs;
            if (DataCoridors.length > 0) {
              drowHalls();
            }
            print('LoadCoridors Sucsess (${docs.length})');
          } else {
            print('Не удалось получить список LoadCoridors');
          }
          setState(() {});
        },
      );
    });

    setCustomMapPin();
    clickSVH = true;
    clickTLC = true;
    clickKoridor = true;
    clickPP = true;

    // googleOfficesCopy = googleOffices;

    super.initState();
  }

  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyAkUdrVbgXV_52Qrid_vdeqzTbBfmFxrNM";
  Set<Polyline> _polylines = {};

  @override
  void dispose() {
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    _markers.clear();

    for (final item in DataControlPoints) {
      if (item['countryNameRu'] != filtering.CountryPP.text &&
          filtering.CountryPP.text.isNotEmpty) {
        continue;
      }
      if (item['workTime'] != filtering.TimePP && filtering.TimePP != -1) {
        continue;
      }
      if (item['roadType'] != filtering.RoadPP && filtering.RoadPP != -1) {
        continue;
      }

      final marker = Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: MarkerId(item['nameKz'] + "PunkProp"),
        position: LatLng(double.parse(item['lat']), double.parse(item['lan'])),
        infoWindow: InfoWindow(
          title: "ПП " + item['nameKz'],
          snippet: item['countryNameRu'],
          onTap: () {
            scaffoldKey.currentState!.showBottomSheet((context) => Container(
                  child: getBottomSheetPP(item),
                  height: 150,
                  color: Colors.black38,
                ));
          },
        ),
      );

      if (clickPP) {
        _markers[item['nameKz']] = marker;
      }
    }

    if (pinLocationIconSVH != null && pinLocationIconTLC != null) {
      // _markers.clear();

      for (final office in DataSvhTlc) {
        if (office['objects'] == null) {
          continue;
        }

        var iconData =
            office['catId'] == 1 ? pinLocationIconSVH! : pinLocationIconTLC!;
        // ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
        // : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);

        if (office['catId'] == 1) {
          for (var item in office['objects']) {
            if (item['cityNameRu'] != filtering.CityCvh.text &&
                filtering.CityCvh.text.isNotEmpty) {
              continue;
            }

            if (item['className'] != filtering.ClassesCvh.text &&
                filtering.ClassesCvh.text.isNotEmpty) {
              continue;
            }

            final marker = Marker(
              icon: iconData,
              markerId: MarkerId(item['wareHouseNameRu'] + "SVH"),
              position:
                  LatLng(double.parse(item['lat']), double.parse(item['lan'])),
              infoWindow: InfoWindow(
                title: item['wareHouseNameRu'],
                snippet:
                    "${office['catId'] == 1 ? '${AppLocalizations.of(context)!.svh} ' : '${AppLocalizations.of(context)!.tlc} '}",
                onTap: () {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) => Container(
                            child: getBottomSheet(item, office['catId']),
                            height: 230,
                            color: Colors.black38,
                          ));
                },
              ),
            );

            if (clickSVH && office['catId'] == 1) {
              _markers[item['wareHouseNameRu']] = marker;
            }
          }
        }
        if (office['catId'] == 2) {
          for (var item in office['objects']) {
            if (item['cityNameRu'] != filtering.CityCvh.text &&
                filtering.CityCvh.text.isNotEmpty) {
              continue;
            }
            if (item['className'] != filtering.ClassesCvh.text &&
                filtering.ClassesCvh.text.isNotEmpty) {
              continue;
            }

            final marker = Marker(
              icon: iconData,
              markerId: MarkerId(item['wareHouseNameRu'] + "TLC"),
              position:
                  LatLng(double.parse(item['lat']), double.parse(item['lan'])),
              infoWindow: InfoWindow(
                title: item['wareHouseNameRu'],
                snippet: "${office['catId'] == 1 ? 'СВХ ' : 'ТЛЦ '}",
                onTap: () {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) => Container(
                            child: getBottomSheet(item, office['catId']),
                            height: 230,
                            color: Colors.black38,
                          ));
                },
              ),
            );

            if (clickTLC && office['catId'] == 2) {
              _markers[item['wareHouseNameRu']] = marker;
            }
          }
        }
      }
    }

    if (clickKoridor) {
      _markers.addAll(_markersKoridor);
    }

    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(child: MenuView()),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.navigate),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                NaviSettings2(context);
              },
              icon: Icon(Icons.settings_outlined)),
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.symmetric(vertical: 70, horizontal: 8),
            zoomControlsEnabled: false, //кнопки + -
            zoomGesturesEnabled: true, // увелечение двумя пальцами
            mapToolbarEnabled: true, //доп функции в виде кнопки маршрута
            trafficEnabled: false, //траффик дороги
            tiltGesturesEnabled: true, //  жесты наклона.
            scrollGesturesEnabled: true, //  жесты прокрутки.
            rotateGesturesEnabled: false, //   жесты поворота.
            myLocationEnabled: true,
            mapType: _currentMapType,
            // onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(43.604411, 66.596639),
              zoom: 3.63,
            ),
            markers: _markers.values.toSet(),
            polylines: clickKoridor ? _polylines : {},
            // polylines: {},
          ),
          // Padding(
          //   padding: EdgeInsets.all(5.0),
          //   child: Align(
          //     alignment: Alignment.topCenter,
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: <Widget>[
          //         ElevatedButton(
          //           onPressed: () {
          //             NaviSettings(context);
          //           },
          //           child: Icon(Icons.settings),
          //         ),
          //         SizedBox(width: 55),
          //       ],
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: (pm.sysUserType == '3' || pm.sysUserType == '4')
                ? DriverBat(context)
                : (pm.sysUserType == '1' || pm.sysUserType == '2')
                    ? ClientBar(context)
                    : pm.sysUserType == '0'
                        ? GuestBar(context)
                        : SizedBox(),
          ),
        ],
      ),
    );
  }

  Column GuestBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Card(
          child: ListTile(
            leading: Icon(Icons.search),
            title: Text(AppLocalizations.of(context)!.poiskGruza),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CurrentView()));
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.published_with_changes_outlined),
            title: Text(AppLocalizations.of(context)!.poputPerevozki),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PoputkaView()));
            },
          ),
        ),
      ],
    );
  }

  Column DriverBat(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Card(
          elevation: 5,
          child: ListTile(
            leading: Image.asset("images/10searchPoputki.png",
                width: 24,
                height: 24,
                color: provider.selectedThemeMode == ThemeMode.dark
                    ? Colors.white
                    : Color.fromARGB(255, 18, 25, 56)),
            title: Text(AppLocalizations.of(context)!.poiskGruza),
            trailing: Icon(
              Icons.arrow_forward,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : Color.fromARGB(255, 18, 25, 56),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CurrentView()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Card(
            elevation: 5,
            color: Color.fromRGBO(46, 107, 198, 1),
            child: ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              leading: Icon(Icons.add_circle_outline),
              title: Text(AppLocalizations.of(context)!.zayavitTransport),
              // trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ZayavitTransport()));
              },
            ),
          ),
        ),
      ],
    );
  }

  Column ClientBar(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Card(
          elevation: 5,
          child: ListTile(
            leading: Image.asset("images/10searchPoputki.png",
                width: 24,
                height: 24,
                color: provider.selectedThemeMode == ThemeMode.dark
                    ? Colors.white
                    : Color.fromARGB(255, 18, 25, 56)),
            title: Text(
              AppLocalizations.of(context)!.poputPerevozki,
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : Color.fromARGB(255, 18, 25, 56),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PoputkaView()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Card(
            elevation: 5,
            color: Color.fromRGBO(46, 107, 198, 1),
            child: ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              leading: Icon(Icons.add_circle_outline),
              title: Text(AppLocalizations.of(context)!.createOrder),
              // trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SelectOrderType()));
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget getBottomSheet(dynamic office, int catId) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          // margin: EdgeInsets.only(top: 16),
          child: Column(
            children: <Widget>[
              Container(
                // color: AppColors.mainDarkBlue,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Image.asset(
                            catId == 1
                                ? 'images/Map_svh.png'
                                : 'images/Map_tlc.png',
                            width: 25,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "${catId == 1 ? 'СВХ ' : 'ТЛЦ '} ${office['wareHouseNameRu']}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(color: Colors.white),
                      Text(
                        "Классность: ${office['className']}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Адрес: ${office['addressRu']}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "График работы: ${office['workTime']}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Мощность: ${office['wareHouseSize']}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 5),
                      office['services'] == null
                          ? SizedBox()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Предоставляемые услуги: ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                Wrap(
                                  spacing: 3.0, // gap between adjacent chips
                                  runSpacing: 2.0, // gap between lines
                                  direction: Axis
                                      .vertical, // main axis (rows or columns)
                                  children: <Widget>[
                                    ...office['services'].map(
                                      (val) {
                                        return Container(
                                          margin: EdgeInsets.all(0),
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF8DAA0),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            val['serviceNameRu'],
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ClipOval(
                            child: Material(
                              color: Colors.green, // Button color
                              child: InkWell(
                                splashColor: Colors.red, // Splash color
                                onTap: () {
                                  _launchURL(office['phoneNumber']);
                                },
                                child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Icon(
                                      Icons.call,
                                      color: Colors.white,
                                      size: 20,
                                    )),
                              ),
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
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
                mini: true,
                child: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        )
      ],
    );
  }

  Widget getBottomSheetPP(dynamic office) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          // margin: EdgeInsets.only(top: 16),
          child: Column(
            children: <Widget>[
              Container(
                // color: AppColors.mainDarkBlue,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "ПП " + "${office['nameRu']}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Divider(color: Colors.white),
                      Text(
                        "Граница: ${office['countryNameRu']}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Область: ${office['locationName']}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Движение: ${RoadPP[office['roadType']]}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Режим работы: ${TimePP[office['workTime']]}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
                mini: true,
                child: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        )
      ],
    );
  }

  TextStyle labelStyle() {
    return TextStyle(
        fontSize: 15, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic);
  }

  void NaviSettings2(BuildContext context) {
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

          var ltSt = TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            // color: AppColors.primaryColors[0],
          );
          var fSt = TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            // color: AppColors.primaryColors[0],
          );
          var fDec = provider.selectedThemeMode == ThemeMode.dark
              ? InputDecoration(
                  isDense: true,
                  fillColor: Color.fromRGBO(53, 54, 61, 1),
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(228, 232, 250, 1))),
                )
              : InputDecoration(
                  isDense: true,
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(228, 232, 250, 1))),
                );

          return FractionallySizedBox(
            heightFactor: 0.90,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.navigateSettings,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.vidimostNaKarte,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                // color: AppColors.primaryColors[0],
                              ),
                            ),
                          ],
                        ),
                        ListTileSwitch(
                          value: clickSVH,
                          onChanged: (value) {
                            clickSVH = value;
                            state(() {});
                            setState(() {});
                          },
                          switchActiveColor: AppColors.primaryColors[2],
                          switchType: SwitchType.cupertino,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            AppLocalizations.of(context)!.svh,
                            style: ltSt,
                          ),
                        ),
                        ListTileSwitch(
                          value: clickTLC,
                          onChanged: (value) {
                            clickTLC = value;
                            state(() {});
                            setState(() {});
                          },
                          switchActiveColor: AppColors.primaryColors[2],
                          switchType: SwitchType.cupertino,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            AppLocalizations.of(context)!.tlc,
                            style: ltSt,
                          ),
                        ),
                        ListTileSwitch(
                          value: clickKoridor,
                          onChanged: (value) {
                            clickKoridor = value;
                            state(() {});
                            setState(() {});
                          },
                          switchActiveColor: AppColors.primaryColors[2],
                          switchType: SwitchType.cupertino,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            AppLocalizations.of(context)!.mezhdynarTranzitKor,
                            style: ltSt,
                          ),
                        ),
                        ListTileSwitch(
                          value: clickPP,
                          onChanged: (value) {
                            clickPP = value;
                            state(() {});
                            setState(() {});
                          },
                          switchActiveColor: AppColors.primaryColors[2],
                          switchType: SwitchType.cupertino,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            AppLocalizations.of(context)!.punktyPropuska,
                            style: ltSt,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Color.fromARGB(255, 172, 166, 166)),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.svh} ${AppLocalizations.of(context)!.and} ${AppLocalizations.of(context)!.tlc}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                // color: AppColors.primaryColors[0],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.selectCity,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                // color: AppColors.primaryColors[0],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        InkWell(
                          child: TextField(
                            enabled: false,
                            controller: filtering.CityCvh,
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
                                      var country = result.addressComponents!
                                          .where((e) =>
                                              e.types.first == 'locality')
                                          .first
                                          .longName;

                                      filtering.CityCvh.text = country;

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
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.selectClas,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                // color: AppColors.primaryColors[0],
                              ),
                            ),
                          ],
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
                          mode: Mode.BOTTOM_SHEET,
                          showSearchBox: true,
                          showSelectedItem: true,
                          items: Classes,
                          selectedItem: filtering.ClassesCvh.text.isEmpty
                              ? AppLocalizations.of(context)!.select
                              : filtering.ClassesCvh.text,
                          onChanged: (newValue) {
                            print(newValue);
                            filtering.ClassesCvh.text = newValue!;
                            state(() {});
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Color.fromARGB(255, 172, 166, 166)),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.mezhdynarTranzitKor,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                // color: AppColors.primaryColors[0],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromRGBO(80, 155, 213, 1)
                                .withOpacity(0.1),
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
                                  controller: filtering.beginCountryKoridor,
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
                                            var country = result
                                                .addressComponents!
                                                .where((e) =>
                                                    e.types.first == 'country')
                                                .first
                                                .longName;

                                            filtering.beginCountryKoridor.text =
                                                country;

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
                                  controller: filtering.endCountryKoridor,
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
                                            var country = result
                                                .addressComponents!
                                                .where((e) =>
                                                    e.types.first == 'country')
                                                .first
                                                .longName;

                                            filtering.endCountryKoridor.text =
                                                country;

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
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.vidTransporta,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                // color: AppColors.primaryColors[0],
                              ),
                            ),
                          ],
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
                          mode: Mode.BOTTOM_SHEET,
                          showSearchBox: true,
                          showSelectedItem: true,
                          items: CarTypes,
                          selectedItem: filtering.carTypeCoridor == 0
                              ? AppLocalizations.of(context)!.select
                              : CarTypes[filtering.carTypeCoridor - 1],
                          onChanged: (newValue) {
                            print(newValue);

                            var idd = CarTypes.indexWhere(
                                (element) => element == newValue);
                            filtering.carTypeCoridor = idd + 1;

                            state(() {});
                            // setState(() {});

                            drowHalls();
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Color.fromARGB(255, 172, 166, 166)),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.punktyPropuska,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                // color: AppColors.primaryColors[0],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.naKakoiGranice,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                // color: AppColors.primaryColors[0],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        InkWell(
                          child: TextField(
                            enabled: false,
                            controller: filtering.CountryPP,
                            style: fSt,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.flag_circle_outlined,
                                  size: 20, color: AppColors.primaryColors[0]),
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
                                      var country = result.addressComponents!
                                          .where(
                                              (e) => e.types.first == 'country')
                                          .first
                                          .longName;

                                      filtering.CountryPP.text = country;

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
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.dvizhenie,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                // color: AppColors.primaryColors[0],
                              ),
                            ),
                          ],
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
                          mode: Mode.BOTTOM_SHEET,
                          showSearchBox: true,
                          showSelectedItem: true,
                          items: CarTypesPP,
                          selectedItem: filtering.RoadPP == -1
                              ? AppLocalizations.of(context)!.select
                              : CarTypesPP[filtering.RoadPP],
                          onChanged: (newValue) {
                            print(newValue);

                            var idd = CarTypesPP.indexWhere(
                                (element) => element == newValue);
                            filtering.RoadPP = idd;
                            state(() {});
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.rezhimRaboty,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                // color: AppColors.primaryColors[0],
                              ),
                            ),
                          ],
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
                          mode: Mode.BOTTOM_SHEET,
                          showSearchBox: true,
                          showSelectedItem: true,
                          items: TimePP,
                          selectedItem: filtering.TimePP == -1
                              ? AppLocalizations.of(context)!.select
                              : TimePP[filtering.TimePP],
                          onChanged: (newValue) {
                            print(newValue);

                            var idd = TimePP.indexWhere(
                                (element) => element == newValue);
                            filtering.TimePP = idd;
                            state(() {});
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Color.fromARGB(255, 172, 166, 166)),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            state(() {});
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                          label: Text(AppLocalizations.of(context)!.primenit),
                          icon: Image.asset("images/11check.png",
                              width: 16, height: 16, color: Colors.white),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            filtering.resetFilter();
                            state(() {});
                            setState(() {});
                          },
                          label: Text(AppLocalizations.of(context)!.sbrosit),
                          icon: Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  drowSvhTlC() async {}

  drowHalls() async {
    _polylines.clear();
    _markersKoridor.clear();
    List<LatLng> polylineCoordinates = [];

    print('drowHalls drowHallsdrowHallsdrowHallsdrowHallsdrowHallsdrowHalls');
    for (final title in DataCoridors) {
      Color c = Color.fromARGB(255, 40, 122, 198);

      if (title['fromPointNameRu'] != filtering.beginCountryKoridor.text &&
          filtering.beginCountryKoridor.text.isNotEmpty) {
        continue;
      }

      if (title['toPointNameRu'] != filtering.endCountryKoridor.text &&
          filtering.endCountryKoridor.text.isNotEmpty) {
        continue;
      }

      polylineCoordinates = [];

      for (var item in title['halls']) {
        if (item['hallType'] != filtering.carTypeCoridor &&
            filtering.carTypeCoridor != 0) {
          continue;
        }

        final marker = Marker(
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          markerId: MarkerId(
              item['fromAddress'] + item['hallId'].toString() + "Koridor"),
          position: LatLng(
              double.parse(item['fromLat']), double.parse(item['fromLan'])),
          infoWindow: InfoWindow(
            title:
                "${title['fromPointNameRu']} - ${title['toPointNameRu']} (${item['fromAddress']})",
            snippet:
                "Международные ${item['hallType'] == 1 ? "АВТО" : "ЖД"}  транзитные коридоры",
            onTap: () {
              // scaffoldKey.currentState!.showBottomSheet((context) => Container(
              //       child: getBottomSheetPP(item),
              //       height: 150,
              //       color: Colors.transparent,
              //     ));
            },
          ),
        );
        if (clickKoridor)
          _markersKoridor[item['fromAddress'] + item['hallId'].toString()] =
              marker;

        final marker2 = Marker(
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          markerId: MarkerId(
              item['toAddress'] + item['hallId'].toString() + "Koridor"),
          position:
              LatLng(double.parse(item['toLat']), double.parse(item['toLan'])),
          infoWindow: InfoWindow(
            title:
                "${title['fromPointNameRu']} - ${title['toPointNameRu']} (${item['toAddress']})",
            snippet:
                "Международные ${item['hallType'] == 1 ? "АВТО" : "ЖД"} транзитные коридоры",
            onTap: () {
              // scaffoldKey.currentState!.showBottomSheet((context) => Container(
              //       child: getBottomSheetPP(item),
              //       height: 150,
              //       color: Colors.transparent,
              //     ));
            },
          ),
        );
        if (clickKoridor)
          _markersKoridor[item['toAddress'] + item['hallId'].toString()] =
              marker2;

        c = item['hallType'] == 1
            ? Color.fromARGB(255, 40, 122, 198)
            : Color.fromARGB(255, 230, 114, 7);

        // polylineCoordinates.add(LatLng(double.parse(item['fromLat']), double.parse(item['fromLan'])));
        // polylineCoordinates.add(LatLng(double.parse(item['toLat']), double.parse(item['toLan'])));

        for (var val in item['wayPoints']) {
          polylineCoordinates.add(LatLng(val['lat'], val['lan']));
        }

        // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        //   googleAPiKey,
        //   PointLatLng(
        //       double.parse(item['fromLat']), double.parse(item['fromLan'])),
        //   PointLatLng(double.parse(item['toLat']), double.parse(item['toLan'])),
        //   travelMode: TravelMode.walking,
        // );
        // if (result.points.isNotEmpty) {
        //   result.points.forEach((PointLatLng point) {
        //     polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        //   });
        // }
      }

      var number = DateTime.now().microsecondsSinceEpoch;
      // print(number);

      var polyline = Polyline(
        polylineId: PolylineId(number.toString()),
        color: c,
        points: polylineCoordinates,
        patterns: [PatternItem.dash(30), PatternItem.gap(10)],
        width: 3,
      );

      _polylines.add(polyline);
    }
    setState(() {});
  }

  drowCP() async {}

  void setCustomMapPin() async {
    pinLocationIconSVH = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'images/Map_svh.png');
    pinLocationIconTLC = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'images/Map_tlc.png');
  }
}

_launchURL(String phoneNumber) async {
  var url = 'tel:$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class NaviFiltering {
  TextEditingController CityCvh = TextEditingController();
  TextEditingController ClassesCvh = TextEditingController();

  TextEditingController beginCountryKoridor = TextEditingController();
  TextEditingController endCountryKoridor = TextEditingController();
  int carTypeCoridor = 0;

  TextEditingController CountryPP = TextEditingController();
  int RoadPP = 0;
  int TimePP = 0;

  NaviFiltering({
    required this.CityCvh,
    required this.ClassesCvh,
    required this.beginCountryKoridor,
    required this.endCountryKoridor,
    required this.carTypeCoridor,
    required this.CountryPP,
    required this.RoadPP,
    required this.TimePP,
  });

  void resetFilter() async {
    CityCvh.text = '';
    ClassesCvh.text = '';

    beginCountryKoridor.text = '';
    endCountryKoridor.text = '';
    carTypeCoridor = 0;
    CountryPP.text = '';
    RoadPP = -1;
    TimePP = -1;
  }
}

List<String> Classes = ['A', 'B', 'C', 'D', 'E'];
List<String> CarTypes = ['Авто', 'ЖД'];
List<String> CarTypesPP = ['Авто двухсторонние', 'Авто многосторонние', 'ЖД'];
List<String> TimePP = ['Круглосуточно', 'Светлое время суток'];
List<String> RoadPP = ['многостороннего', 'двустороннего'];
