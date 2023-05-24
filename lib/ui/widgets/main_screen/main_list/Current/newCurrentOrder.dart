import 'package:flutter/material.dart';
import 'package:themoviedb/ui/widgets/app/my_app.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_list/Current/order1%20vypol.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_list/Current/order2%20new.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_list/Current/order3.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';


import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class NewCurrentOrders extends StatefulWidget {
  const NewCurrentOrders({Key? key}) : super(key: key);

  @override
  State<NewCurrentOrders> createState() => _NewCurrentOrdersState();
}

class _NewCurrentOrdersState extends State<NewCurrentOrders> {
  final pm = ProfileModel();
  bool pmLoad = true;
  bool pmLoadError = false;

  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: false,
  );
  int bottomSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    pmLoad = true;
    pmLoadError = false;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    var cDec = BoxDecoration(
        border: Border(
            bottom: BorderSide(
      width: 2,
      color: AppColors.primaryColors[2],
    )));
    var cDecTrans = BoxDecoration(
        border: Border(
            bottom: BorderSide(
      width: 2,
      color: Colors.transparent,
    )));
    var textStyle = TextStyle(
      color: provider.selectedThemeMode == ThemeMode.dark
          ? Colors.white
          : AppColors.primaryColors[0],
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tecushZakaz,
            style: TextStyle(
                color: provider.selectedThemeMode == ThemeMode.dark
                    ? Colors.white
                    : AppColors.primaryColors[0],
                fontWeight: FontWeight.w400,
                fontSize: 20)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            buttonPadding: EdgeInsets.zero,
            children: pm.sysUserType == "5"
                ? <Widget>[
                    Container(
                      decoration: bottomSelectedIndex == 0 ? cDec : cDecTrans,
                      child: TextButton(
                        onPressed: () {
                          _pageController.jumpToPage(0);
                          setState(() {});
                        },
                        child: Text(AppLocalizations.of(context)!.vipolnayisheca, style: textStyle),
                      ),
                    ),
                  ]
                : <Widget>[
                    Container(
                      decoration: bottomSelectedIndex == 0 ? cDec : cDecTrans,
                      child: TextButton(
                        onPressed: () {
                          _pageController.jumpToPage(0);
                          setState(() {});
                        },
                        child: Text(AppLocalizations.of(context)!.vipolnayisheca, style: textStyle),
                      ),
                    ),
                    Container(
                      decoration: bottomSelectedIndex == 1 ? cDec : cDecTrans,
                      child: TextButton(
                        onPressed: () {
                          _pageController.jumpToPage(1);
                          setState(() {});
                        },
                        child: Text(AppLocalizations.of(context)!.novye, style: textStyle),
                      ),
                    ),
                    Container(
                      decoration: bottomSelectedIndex == 2 ? cDec : cDecTrans,
                      child: TextButton(
                        onPressed: () {
                          _pageController.jumpToPage(2);
                          setState(() {});
                        },
                        child: Text(AppLocalizations.of(context)!.moiZayavki, style: textStyle),
                      ),
                    )
                  ],
          ),
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            bottomSelectedIndex = index;
          });
        },
        children: pm.sysUserType == "5"
            ? [MyAppOrder1()]
            : [
                MyAppOrder1(),
                MyAppOrder2(),
                MyAppOrder3(),
              ],
      ),
    );
  }
}
