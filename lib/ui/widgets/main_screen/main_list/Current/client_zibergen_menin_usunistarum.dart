import 'package:flutter/material.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_list/Current/Current_data.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/my_app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Usunus extends StatefulWidget {
  final String token;
  final dynamic jdata;
  Usunus({
    Key? key,
    required this.token,
    required this.jdata,
  }) : super(key: key);

  @override
  _UsunusState createState() => _UsunusState();
}

class _UsunusState extends State<Usunus> {
  List<CurrrentData> data = <CurrrentData>[];
  List<CurrrentData> filteredData = <CurrrentData>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.otpravlennyeZayavki)),
      body: Stack(children: [
        ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 5),
          itemCount: widget.jdata['notifications'].length,
          // itemExtent: 190,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                        ['creator']['orderInChargeName'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      // color: Colors.black87,
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
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                                AppLocalizations.of(context)!.from,
                                                style: TextStyle(
                                                    color: AppColors
                                                        .primaryColors[3],
                                                    fontSize: 12,
                                                    letterSpacing: 0.3,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '${widget.jdata['notifications'][index]['beginPointName']}',
                                                style: TextStyle(
                                                    // color: AppColors
                                                    //     .primaryColors[0],
                                                    fontSize: 15,
                                                    letterSpacing: 0.3,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                AppLocalizations.of(context)!.to,
                                                style: TextStyle(
                                                    color: AppColors
                                                        .primaryColors[3],
                                                    fontSize: 12,
                                                    letterSpacing: 0.3,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '${widget.jdata['notifications'][index]['endPointName']}',
                                                style: TextStyle(
                                                    // color: AppColors
                                                    //     .primaryColors[0],
                                                    fontSize: 15,
                                                    letterSpacing: 0.3,
                                                    fontWeight: FontWeight.w400),
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
                          SizedBox(height: 20),
                          Text(
                            // formatted,
                            widget.jdata['notifications'][index]['car']
                                        ['carTypeNameRu']
                                    .toString()
                                    .toUpperCase() +
                                " " +
                                widget.jdata['notifications'][index]['car']
                                        ['carWeight']
                                    .toString() +
                                "T",
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.normal,
                              // color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.jdata['notifications'][index]['car']
                                        ['brandNameRu']
                                    .toString()
                                    .toUpperCase() +
                                " " +
                                widget.jdata['notifications'][index]['car']
                                        ['modelNameRu']
                                    .toString()
                                    .toUpperCase(),
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.normal,
                              // color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.jdata['notifications'][index]['car']
                                        ['carNumber']
                                    .toString()
                                    .toUpperCase() +
                                " " +
                                widget.jdata['notifications'][index]['car']
                                        ['modelYear']
                                    .toString(),
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.normal,
                              // color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${AppLocalizations.of(context)!.vashePredlozhenie} ${widget.jdata['notifications'][index]['offerPrice']}  ${widget.jdata['notifications'][index]['currencyIcon']}',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                ),
                                onPressed: () {},
                                icon: Icon(Icons.close),
                                label: Text(
                                  AppLocalizations.of(context)!.otmenitZayavku,
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
