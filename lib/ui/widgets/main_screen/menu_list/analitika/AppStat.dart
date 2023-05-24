import 'dart:convert';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/app/my_app.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dynamicMap.dart';

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class AppStats extends StatefulWidget {
  const AppStats({Key? key}) : super(key: key);

  @override
  State<AppStats> createState() => _AppStatsState();
}

class _AppStatsState extends State<AppStats> {
  int UserType = 0;
  int DataTime = 0;
  var dateTimeString = ['today', 'month', 'all'];
  var dateTimeStringValue = 'today';

  final pm = ProfileModel();
  dynamic appData = [];
  bool appDataload = false;
  bool appDataLoadError = false;

  @override
  void initState() {
    appData = [];
    appDataload = true;
    appDataLoadError = false;

    pm.setupLocale(context).then(
      (value) {
        AppStatData(token: pm.token.toString()).getList().then(
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
              appData = docs;
              appDataload = false;
              appDataLoadError = false;
              print('Sucsess AppStatData ');
            } else {
              appDataload = false;
              appDataLoadError = true;
              print('Не удалось получить список AppStatData');
            }
            setState(() {});
          },
        );
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    pm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryColors[1],
      appBar: CustomAppBar(),
      body: appDataload && !appDataLoadError
          ? LoadingData(context)
          : !appDataload && appDataLoadError
              ? ErorLoadingData(context)
              : Container(
                  color: provider.selectedThemeMode == ThemeMode.dark
                      ? Color.fromRGBO(53, 54, 61, 1)
                      : Colors.white,
                  child: CustomScrollView(
                    physics: ClampingScrollPhysics(),
                    slivers: <Widget>[
                      _buildHeader(),
                      _buildUserTabBar(),
                      _buildStatsTabBar(),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        sliver: SliverToBoxAdapter(
                          child: UserType == 0
                              ? gridClient(context)
                              : gridDriver(context),
                        ),
                      ),
                      // SliverPadding(
                      //   padding: const EdgeInsets.only(top: 20.0),
                      //   sliver: SliverToBoxAdapter(
                      //       // child: CovidBarChart(),
                      //       ),
                      // ),
                    ],
                  ),
                ),
    );
  }

  Container gridClient(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard(
                  Image.asset(
                    "images/Anal.client.person.png",
                    height: 16,
                    color: provider.selectedThemeMode == ThemeMode.dark
                        ? Colors.white
                        : Color.fromRGBO(27, 28, 34, 1),
                  ),
                  AppLocalizations.of(context)!.polzovateli,
                  '${appData["appClientReport"][dateTimeStringValue]["regCount"]}',
                ),
                _buildStatCard(
                  Image.asset(
                    "images/Anal.client.zakaz.png",
                    height: 16,
                    color: provider.selectedThemeMode == ThemeMode.dark
                        ? Colors.white
                        : Color.fromRGBO(27, 28, 34, 1),
                  ),
                  AppLocalizations.of(context)!.zakazy,
                  '${appData["appClientReport"][dateTimeStringValue]["orderCount"]}',
                ),
              ],
            ),
          ),
          appData["appClientReport"][dateTimeStringValue]["appPrice"] == null
              ? SizedBox()
              : Flexible(
                  child: Row(
                    children: <Widget>[
                      ...appData["appClientReport"][dateTimeStringValue]
                              ["appPrice"]
                          .asMap()
                          .entries
                          .map(
                        (e) {
                          var val = e.value;

                          return _buildStatCard(
                            Image.asset(
                              "images/Anal.client.sum.png",
                              height: 16,
                              color:
                                  provider.selectedThemeMode == ThemeMode.dark
                                      ? Colors.white
                                      : Color.fromRGBO(27, 28, 34, 1),
                            ),
                            AppLocalizations.of(context)!.prise,
                            '${val["totalPrice"]} ${val["appCurrency"]["currencyIcon"]}',
                          );
                        },
                      ),
                    ],
                  ),
                ),
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard(
                  Image.asset(
                    "images/Anal.client.tonna.png",
                    height: 16,
                    color: provider.selectedThemeMode == ThemeMode.dark
                        ? Colors.white
                        : Color.fromRGBO(27, 28, 34, 1),
                  ),
                  AppLocalizations.of(context)!.tonna,
                  '${appData["appClientReport"][dateTimeStringValue]["totalWeight"]}',
                ),
                _buildStatCard(
                  Image.asset(
                    "images/Anal.client.obem.png",
                    height: 16,
                    color: provider.selectedThemeMode == ThemeMode.dark
                        ? Colors.white
                        : Color.fromRGBO(27, 28, 34, 1),
                  ),
                  AppLocalizations.of(context)!.obem,
                  '${appData["appClientReport"][dateTimeStringValue]["totalSize"]}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container gridDriver(BuildContext context) {
    var topRoutes =
        appData["appDriverReport"][dateTimeStringValue]["topRoutes"];

    var topCars = appData["appDriverReport"][dateTimeStringValue]["topCars"];

    var topDrivers =
        appData["appDriverReport"][dateTimeStringValue]["topDrivers"];
    final provider = Provider.of<LocaleProvider>(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard(
                  Image.asset(
                    "images/Anal.client.person.png",
                    height: 16,
                    color: provider.selectedThemeMode == ThemeMode.dark
                        ? Colors.white
                        : Color.fromRGBO(27, 28, 34, 1),
                  ),
                  AppLocalizations.of(context)!.polzovateli,
                  '${appData["appDriverReport"][dateTimeStringValue]["regCount"]}',
                ),
                _buildStatCard(
                  Image.asset(
                    "images/Anal.driver.obavlenie.png",
                    height: 16,
                    color: provider.selectedThemeMode == ThemeMode.dark
                        ? Colors.white
                        : Color.fromRGBO(27, 28, 34, 1),
                  ),
                  AppLocalizations.of(context)!.obavleniya,
                  '${appData["appDriverReport"][dateTimeStringValue]["orderCount"]}',
                ),
              ],
            ),
          ),
          topRoutes == null
              ? SizedBox()
              : Flexible(
                  child: GestureDetector(
                    onTap: () {
                      topRoute(
                          context,
                          AppLocalizations.of(context)!.popularNaprav,
                          topRoutes);
                    },
                    child: Row(
                      children: <Widget>[
                        _buildStatCard(
                          Image.asset(
                            "images/Anal.driver.map.png",
                            height: 16,
                            color: provider.selectedThemeMode == ThemeMode.dark
                                ? Colors.white
                                : Color.fromRGBO(27, 28, 34, 1),
                          ),
                          AppLocalizations.of(context)!.popularNaprav,
                          "${topRoutes[0]["beginCityName"]} >> ${topRoutes[0]["endCityName"]} ${topRoutes[0]["transportCount"]}",
                        ),
                      ],
                    ),
                  ),
                ),
          topCars == null
              ? SizedBox()
              : Flexible(
                  child: GestureDetector(
                    onTap: () {
                      topCar(context, AppLocalizations.of(context)!.popularAvto,
                          topCars);
                    },
                    child: Row(
                      children: <Widget>[
                        _buildStatCard(
                          Image.asset(
                            "images/mycars.png",
                            height: 16,
                            color: provider.selectedThemeMode == ThemeMode.dark
                                ? Colors.white
                                : Color.fromRGBO(27, 28, 34, 1),
                          ),
                          AppLocalizations.of(context)!.popularAvto,
                          "${topCars[0]["brandNameRu"]} ${topCars[0]["modelNameRu"]} ${topCars[0]["transportCount"]}",
                        ),
                      ],
                    ),
                  ),
                ),
          topDrivers == null
              ? SizedBox()
              : Flexible(
                  child: GestureDetector(
                    onTap: () {
                      topPerson(context,
                          AppLocalizations.of(context)!.topPerevoz, topDrivers);
                    },
                    child: Row(
                      children: <Widget>[
                        _buildStatCard(
                          Image.asset(
                            "images/Anal.contact.png",
                            height: 16,
                            color: provider.selectedThemeMode == ThemeMode.dark
                                ? Colors.white
                                : Color.fromRGBO(27, 28, 34, 1),
                          ),
                          AppLocalizations.of(context)!.topPerevoz,
                          "${topDrivers[0]["driverInfo"]} ${topDrivers[0]["transportCount"]}",
                        ),
                      ],
                    ),
                  ),
                ),
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard(
                  Image.asset(
                    "images/Anal.driver.box.png",
                    height: 16,
                    color: provider.selectedThemeMode == ThemeMode.dark
                        ? Colors.white
                        : Color.fromRGBO(27, 28, 34, 1),
                  ),
                  AppLocalizations.of(context)!.samyeDostGruz,
                  'Металл, Зерновые грузы',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverPadding _buildHeader() {
    return SliverPadding(
      padding: const EdgeInsets.all(10.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '',
          style: const TextStyle(
            // color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildUserTabBar() {
    return SliverToBoxAdapter(
      child: DefaultTabController(
        length: 2,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TabBar(
            indicator: BubbleTabIndicator(
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
                indicatorHeight: 40.0,
                indicatorColor: Colors.white,
                indicatorRadius: 5),
            labelStyle: Styles.tabTextStyle,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(AppLocalizations.of(context)!.gruzOtpraviteli),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(AppLocalizations.of(context)!.gruzPerevozchiki),
              ),
            ],
            onTap: (index) {
              UserType = index;
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  SliverPadding _buildStatsTabBar() {
    final provider = Provider.of<LocaleProvider>(context);

    return SliverPadding(
      padding: EdgeInsets.only(top: 10),
      sliver: SliverToBoxAdapter(
        child: DefaultTabController(
          length: 3,
          child: TabBar(
            indicatorColor: Colors.transparent,
            labelStyle: Styles.tabTextStyle,
            labelColor: provider.selectedThemeMode == ThemeMode.dark
                ? Colors.white
                : AppColors.primaryColors[0],
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(AppLocalizations.of(context)!.zaSegod),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(AppLocalizations.of(context)!.zaMesace),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(AppLocalizations.of(context)!.vsego),
              ),
            ],
            onTap: (index) {
              DataTime = index;
              dateTimeStringValue = dateTimeString[index];
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  _buildStatCard(Widget icn, String title, String count) {
    final provider = Provider.of<LocaleProvider>(context);

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: provider.selectedThemeMode != ThemeMode.dark
              ? Colors.white
              : Color.fromRGBO(27, 28, 34, 1),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            icn,
            Text(
              title,
              style: TextStyle(
                // color: AppColors.primaryColors[0],
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              count,
              style: TextStyle(
                // color: AppColors.primaryColors[0],
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void topPerson(BuildContext context, String Name, data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Name),
          content: Container(
            // height: 400,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ...data.asMap().entries.map(
                    (e) {
                      var val = e.value;
                      var indexes = e.key;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          Text(
                            "${indexes + 1}. ${val["driverInfo"]} (${val["transportCount"]})",
                            style: TextStyle(fontSize: 13),
                          ),
                          Divider(),
                        ],
                      );
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
                'Закрыть',
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

  void topRoute(BuildContext context, String Name, data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Name),
          content: Container(
            // height: 400,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ...data.asMap().entries.map(
                    (e) {
                      var val = e.value;
                      var indexes = e.key;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          Text(
                            "${indexes + 1}. ${val["beginCityName"]}-${val["endCityName"]} (${val["transportCount"]})",
                            style: TextStyle(fontSize: 13),
                          ),
                          Divider(),
                        ],
                      );
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
            TextButton.icon(
              label: Text(
                'Показать на карте',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DynamicMap(
                            dataNew: data,
                          )),
                );
              },
              icon: Icon(Icons.map),
            ),
            TextButton(
              child: Text(
                'Закрыть',
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

  void topCar(BuildContext context, String Name, data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Name),
          content: Container(
            // height: 400,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ...data.asMap().entries.map(
                    (e) {
                      var val = e.value;
                      var indexes = e.key;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          Text(
                            //"${topCars[0]["brandNameRu"]} ${topCars[0]["modelNameRu"]} (${topCars[0]["transportCount"]})"
                            "${indexes + 1}. ${val["brandNameRu"].toString().toUpperCase()} ${val["modelNameRu"].toString().toUpperCase()} (${val["transportCount"]})",
                            style: TextStyle(fontSize: 13),
                          ),
                          Divider(),
                        ],
                      );
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
                'Закрыть',
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
}

class Palette {
  static const Color primaryColor = Color(0xFF473F97);
}

class Styles {
  static const buttonTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );

  static const chartLabelsTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );

  static const tabTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // backgroundColor: Palette.primaryColor,
      title: Text(AppLocalizations.of(context)!.statPrilozh),
      elevation: 0.0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

Stack LoadingData(BuildContext context) {
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
                ),
              ),
              SizedBox(height: 10),
              CircularProgressIndicator(
                // color: Colors.black,
                strokeWidth: 2,
              ),
            ],
          ),
        ],
      )
    ],
  );
}

Stack ErorLoadingData(BuildContext context) {
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
                  // color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      )
    ],
  );
}
