import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/order/order_datail_card.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_list/Current/Current_data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../menu_list/profile/profile_page.dart';
import 'notify_order.dart';

class DriverNot extends StatefulWidget {
  final String token;
  final dynamic jdata;
  DriverNot({
    Key? key,
    required this.token,
    required this.jdata,
  }) : super(key: key);

  @override
  _DriverNotState createState() => _DriverNotState();
}

class _DriverNotState extends State<DriverNot> {
  List<CurrrentData> data = <CurrrentData>[];
  List<CurrrentData> filteredData = <CurrrentData>[];

  @override
  void initState() {
    super.initState();
    // Services.getCurrentData().then((dataFromServer) {
    //   setState(() {
    //     data = dataFromServer;
    //     filteredData = data;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.predlozheniyaOtKlientov)),
      body: Stack(children: [
        ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          itemCount: widget.jdata['notifications'].length,
          // itemExtent: 190,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.jdata['notifications'][index]
                                          ['creator']['firstName'] +
                                      " " +
                                      widget.jdata['notifications'][index]
                                          ['creator']['lastName'],
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      size: 15,
                                      color: Colors.orange,
                                    ),
                                    Text('5.0'),
                                  ],
                                ),
                              ],
                            ),
                            ClipOval(
                              child: Material(
                                color: Colors.green, // Button color
                                child: InkWell(
                                  splashColor: Colors.red, // Splash color
                                  onTap: () {
                                    var num = widget.jdata['notifications']
                                            [index]['creator']
                                        ['orderInChargePhone'];
                                    _launchURL(num);
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
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderDatailCardView(
                                      jdata: widget.jdata['notifications']
                                          [index],
                                      myCars: null,
                                      myDrivers: null,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.description_outlined),
                              label:
                                  Text(AppLocalizations.of(context)!.podrobnoe),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          // formatted,
                          widget.jdata['notifications'][index]
                              ['beginPointName'],
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.jdata['notifications'][index]['endPointName'],
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.jdata['notifications'][index]['orderName']
                              .toString(),
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${AppLocalizations.of(context)!.vashaCena} ${NumberFormat("#,##0", "pt_BR").format(widget.jdata['notifications'][index]['driverOfferPrice'])} ${widget.jdata['notifications'][index]['currencyIcon']}",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 5),
                        Center(
                          child: Text(
                            "${AppLocalizations.of(context)!.predlogaet} ${NumberFormat("#,##0", "pt_BR").format(widget.jdata['notifications'][index]['offerPrice'])} ${widget.jdata['notifications'][index]['currencyIcon']}",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              onPressed: () {
                                AcseptOrderDriver(
                                  token: widget.token.toString(),
                                  offerId: widget.jdata['notifications'][index]
                                      ['offerId'],
                                  orderId: widget.jdata['notifications'][index]
                                      ['orderId'],
                                  tandau: 1,
                                ).UpdateData().then(
                                  (value) {
                                    print('Response: $value');

                                    if (value.toString() == '401') {
                                      final provider = SessionDataProvider();
                                      provider.setSessionId(null);

                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              MainNavigationRouteNames
                                                  .changeLang,
                                              (Route<dynamic> route) => false);
                                    }

                                    if (value != 'Error') {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileView(),
                                        ),
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotifyCurrentOrders()),
                                      );
                                    } else {
                                      _onBasicAlertPressed3(context);
                                    }
                                  },
                                );
                              },
                              icon: Icon(Icons.check),
                              label: Text(
                                AppLocalizations.of(context)!.prinyat,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                              ),
                              onPressed: () {
                                AcseptOrderDriver(
                                  token: widget.token.toString(),
                                  offerId: widget.jdata['notifications'][index]
                                      ['offerId'],
                                  orderId: widget.jdata['notifications'][index]
                                      ['orderId'],
                                  tandau: 0,
                                ).UpdateData().then(
                                  (value) {
                                    print('Response: $value');

                                    if (value != 'Error') {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileView(),
                                        ),
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotifyCurrentOrders()),
                                      );
                                    } else {
                                      _onBasicAlertPressed3(context);
                                    }
                                  },
                                );
                              },
                              icon: Icon(Icons.close),
                              label: Text(
                                AppLocalizations.of(context)!.otklonit,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ]),
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
}

_onBasicAlertPressed3(context) {
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
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppLocalizations.of(context)!.prodolzhit,
            style: TextStyle(fontSize: 20),
          ),
        )
      ]).show();
}
