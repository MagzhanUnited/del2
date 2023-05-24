import 'package:flutter/material.dart';
import 'package:themoviedb/ui/widgets/app/my_app.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/About_page.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';
// import '../../../ui/widgets/main_screen/menu_list/Railway_create_order_Development.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectOrderType extends StatefulWidget {
  SelectOrderType({Key? key}) : super(key: key);

  @override
  _SelectOrderTypeState createState() => _SelectOrderTypeState();
}

class _SelectOrderTypeState extends State<SelectOrderType> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.vuberiteTypDostavli)),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AutoCO()),
                );
              },
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 32),
                        Image.asset(
                          'images/mycars.png',
                          width: 80,
                          color: provider.selectedThemeMode == ThemeMode.dark
                              ? Colors.white
                              : AppColors.primaryColors[0],
                        ),
                        SizedBox(height: 22),
                        Text(
                          AppLocalizations.of(context)!.avto,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // color: AppColors.primaryColors[0],
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 32),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //   // height: 120,
            //   // width: 130,
            //   decoration: BoxDecoration(
            //     color: Colors.grey,
            //     borderRadius: BorderRadius.circular(5),
            //     // boxShadow: [
            //     //   BoxShadow(
            //     //       color: Colors.black.withOpacity(0.1),
            //     //       spreadRadius: 6,
            //     //       blurRadius: 2)
            //     // ],
            //   ),
            //   // ignore: deprecated_member_use
            //   child: new RaisedButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => AutoCO()),
            //       );
            //     },
            //     color: Colors.white,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(5.0),
            //       // side: BorderSide(
            //       //   color: AppColors.mainOrange,
            //       //   width: 1,
            //       // ),
            //     ),
            //     padding: const EdgeInsets.all(5.0),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: <Widget>[
            //         Image.asset(
            //           'images/truck.png',
            //           width: 80,
            //         ),
            //         // Icon(Icons.monetization_on,
            //         //     color: Colors.grey, size: 35),
            //         Spacer(),
            //         Text(
            //           'АВТО',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             color: Colors.grey,
            //             fontSize: 13,
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   height: 120,
            //   width: 130,
            //   decoration: BoxDecoration(
            //       color: Colors.grey,
            //       borderRadius: BorderRadius.circular(8),
            //       boxShadow: [
            //         BoxShadow(
            //             color: Colors.black.withOpacity(0.1),
            //             spreadRadius: 6,
            //             blurRadius: 2)
            //       ]),
            //   // ignore: deprecated_member_use
            //   child: new RaisedButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => RWCreateOrderView()),
            //       );
            //     },
            //     color: Colors.white,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //       side: BorderSide(
            //         color: AppColors.mainOrange,
            //         width: 1,
            //       ),
            //     ),
            //     padding: const EdgeInsets.all(5.0),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: <Widget>[
            //         Image.asset(
            //           'images/train.png',
            //           width: 80,
            //         ),
            //         // Icon(Icons.document_scanner,
            //         //     color: Colors.grey, size: 35),
            //         Spacer(),
            //         Text(
            //           'ЖД',
            //           style: TextStyle(
            //             color: Colors.grey,
            //             fontSize: 13,
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
