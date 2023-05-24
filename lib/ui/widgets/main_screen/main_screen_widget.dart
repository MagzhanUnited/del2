import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/order/Select_order_type_page.dart';
import 'package:themoviedb/full/ui/register/register_step1_page.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/bottom_screens/forum/forum_page.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_list/Current/Poputka_page.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_list/Current/current_page.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:themoviedb/ui/widgets/News/news_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'bottom_screens/sevice_page.dart';
import 'main_list/Current/Order_history.dart';
import 'main_list/Current/newCurrentOrder.dart';
import 'main_list/Current/notify_order.dart';
import 'menu_list/ZayavitTransport.dart';
import 'menu_list/analitika/analitycNewPage.dart';
import 'menu_list/navigate/navigation_page.dart';
import 'menu_list/profile/profile_model.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  MainScreenWidgetState createState() => MainScreenWidgetState();
}

ProfileModel pm = ProfileModel();

class MainScreenWidgetState extends State<MainScreenWidget> {
  int bottomSelectedIndex = 0;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: false,
  );

  String appBarTitle = '';
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('ws://185.116.193.86:8081/ws'),
  );

  @override
  void initState() {
    pm.setupLocale(context).then((value) {
      _channel.sink.add("${pm.phoneNumber}");
      _channel.stream.listen(
        (data) {
          print(data);

          var temp = json.decode(data);

          if (temp['notifyType'] == 'client_offer_to_driver' ||
              temp['notifyType'] == 'driver_offer_to_client') {
            //уведомление
            _showNotification(temp);
          }
          if (temp['notifyType'] == 'client_accept_for_driver' ||
              temp['notifyType'] == 'driver_accept_for_client') {
            //мои заказы
            _showNotificationMyOrder(temp);
          }
          if (temp['notifyType'] == 'driver_completed_order') {
            //тек хисторига
            _showNotificationHistory(temp);
          }
        },
        onError: (error) => print(error),
      );
      debugPrint("WebSocketChannel INIT");
      setState(() {});
    });

    super.initState();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/ic_flutternotification');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin?.initialize(
      initializationSettings, //onSelectNotification: onSelectNotification
    );
  }

  Future<dynamic> onSelectNotification(String? payload) async {
    if (payload == "notify") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotifyCurrentOrders()),
      );
    } else if (payload == "History") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderHistory()),
      );
    } else if (payload == "MyOrder") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewCurrentOrders()),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Your Notification Detail"),
            content: Text("Payload : $payload"),
          );
        },
      );
    }
  }

  Future _showNotification([data]) async {
    // Уведомления
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high);
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(threadIdentifier: 'thread_id');
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin?.show(
      0,
      '${data['beginPointName']} - ${data['endPointName']} ${data['notifyDate']}',
      '${data['notifyInfo']} предлагает ${data['notifyPrice']}',
      platformChannelSpecifics,
      payload: 'notify',
    );
  }

  Future _showNotificationMyOrder([data]) async {
    // Мои заказы
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high);

    var iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails(threadIdentifier: 'thread_id');
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin?.show(
      0,
      'Принятие',
      'Ваше предложение успешно принято!',
      platformChannelSpecifics,
      payload: 'MyOrder',
    );
  }

  Future _showNotificationHistory([data]) async {
    // История
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails(threadIdentifier: 'thread_id');
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    // iOS: iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin?.show(
      0,
      'Завершение',
      AppLocalizations.of(context)!.zakazZavershen,
      platformChannelSpecifics,
      payload: 'History',
    );
  }

  // void _sendMessage() {
  //   _channel.sink.add("87071686899");
  //   debugPrint('_sendMessage');
  // }
  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    var clr = provider.selectedThemeMode == ThemeMode.dark
        ? Colors.white
        : Color.fromARGB(255, 18, 25, 56);

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _sendMessage,
      //   tooltip: 'Send message',
      //   child: const Icon(Icons.send),
      // ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            bottomSelectedIndex = index;
          });
        },
        children: <Widget>[
          NavigationMiniView(),
          pm.sysUserType == '0' ? ForumAsGust(context) : TestPage(),
          pm.sysUserType == '0' ? ForumAsGust(context) : NewsListWidget(),
          ServiceView(),
          AnaliticList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // elevation: 15,
        currentIndex: bottomSelectedIndex,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          if (bottomSelectedIndex == index) return;
          bottomSelectedIndex = index;
          pageController.jumpToPage(index);

          if (bottomSelectedIndex == 0)
            appBarTitle = AppLocalizations.of(context)!.navigate;
          else if (bottomSelectedIndex == 1)
            appBarTitle = AppLocalizations.of(context)!.forum;
          else if (bottomSelectedIndex == 2)
            appBarTitle = AppLocalizations.of(context)!.news;
          else if (bottomSelectedIndex == 3)
            appBarTitle = AppLocalizations.of(context)!.services;
          else if (bottomSelectedIndex == 4)
            appBarTitle = AppLocalizations.of(context)!.analityc;

          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Image.asset("images/1map.png",
                    width: 22, height: 22, color: clr),
              ),
              icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Image.asset("images/1map.png",
                    width: 22,
                    height: 22,
                    color: Color.fromRGBO(143, 147, 165, 1)),
              ),
              label: AppLocalizations.of(context)!.navigate),
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Image.asset("images/2forum.png",
                    width: 22, height: 22, color: clr),
              ),
              icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Image.asset("images/2forum.png",
                    width: 22,
                    height: 22,
                    color: Color.fromRGBO(143, 147, 165, 1)),
              ),
              label: AppLocalizations.of(context)!.forum),
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Image.asset("images/3news.png",
                    width: 22, height: 22, color: clr),
              ),
              icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Image.asset("images/3news.png",
                    width: 22,
                    height: 22,
                    color: Color.fromRGBO(143, 147, 165, 1)),
              ),
              label: AppLocalizations.of(context)!.news),
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Image.asset("images/4services.png",
                    width: 22, height: 22, color: clr),
              ),
              icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Image.asset("images/4services.png",
                    width: 22,
                    height: 22,
                    color: Color.fromRGBO(143, 147, 165, 1)),
              ),
              label: AppLocalizations.of(context)!.services),
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Image.asset("images/5analit.png",
                    width: 22, height: 22, color: clr),
              ),
              icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Image.asset("images/5analit.png",
                    width: 22,
                    height: 22,
                    color: Color.fromRGBO(143, 147, 165, 1)),
              ),
              label: AppLocalizations.of(context)!.analityc)
        ],

        unselectedLabelStyle:
            TextStyle(fontSize: 10, fontWeight: FontWeight.w500),

        selectedLabelStyle:
            TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        selectedItemColor: provider.selectedThemeMode == ThemeMode.dark
            ? Colors.white
            : Color.fromARGB(255, 18, 25, 56),
        unselectedItemColor: Color.fromRGBO(143, 147, 165, 1),
      ),
    );
  }

  Center ForumAsGust(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.nuzhnaRegistDlyaProsmotra,
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterStep1View()),
                );
              },
              child: Text(AppLocalizations.of(context)!.register),
            )
          ]),
    );
  }

  Future<dynamic> SheetBarQuest(BuildContext context, String token) {
    return showAdaptiveActionSheet(
      context: context,
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: const Text(
            'Поиск груза',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: (context) {
            Navigator.of(context).pop();

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CurrentView()),
            );
          },
          // leading: const Icon(Icons.circle_outlined, size: 25),
        ),
        BottomSheetAction(
          title: const Text(
            'Все перевозки',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: (context) {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PoputkaView()),
            );
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

  Future<dynamic> SheetBarDriver(BuildContext context, String token) {
    return showAdaptiveActionSheet(
      context: context,
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: const Text(
            'Поиск груза',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: (context) {
            Navigator.of(context).pop();

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CurrentView()),
            );
          },
          // leading: const Icon(Icons.circle_outlined, size: 25),
        ),
        BottomSheetAction(
          title: const Text(
            'Заявить транспорт',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: (context) {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ZayavitTransport()),
            );
          },
          // leading: const Icon(Icons.circle_outlined, size: 25),
        ),
        BottomSheetAction(
          title: const Text(
            'Все перевозки',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: (context) {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PoputkaView()),
            );
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

  Future<dynamic> SheetBarClient(BuildContext context, String token) {
    return showAdaptiveActionSheet(
      context: context,
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: const Text(
            'Создать заказ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: (context) {
            Navigator.of(context).pop();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SelectOrderType();
                },
              ),
            );
          },
          // leading: const Icon(Icons.circle_outlined, size: 25),
        ),
        BottomSheetAction(
          title: const Text(
            'Попутные перевозки',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: (context) {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PoputkaView()),
            );
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
}

class SerialsListWidget extends StatelessWidget {
  const SerialsListWidget({
    Key? key,
  }) : super(key: key);

  void logOut(BuildContext context) {
    final provider = SessionDataProvider();
    provider.setSessionId(null);
    Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.auth);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      child: Text('log out'),
      onPressed: () => logOut(context),
    ));
  }
}
