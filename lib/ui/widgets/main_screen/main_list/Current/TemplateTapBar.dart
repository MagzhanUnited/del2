import 'package:flutter/material.dart';

import '../../../app/my_app.dart';

class TabBarTemplate extends StatefulWidget {
  const TabBarTemplate({Key? key}) : super(key: key);

  @override
  State<TabBarTemplate> createState() => _TabBarTemplateState();
}

class _TabBarTemplateState extends State<TabBarTemplate> {
  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: false,
  );
  int bottomSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
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
      color: AppColors.primaryColors[0],
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Текущие заказы",
            style: TextStyle(
                color: AppColors.primaryColors[0],
                fontWeight: FontWeight.w400,
                fontSize: 20)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            buttonPadding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                decoration: bottomSelectedIndex == 0 ? cDec : cDecTrans,
                child: TextButton(
                  onPressed: () {
                    _pageController.jumpToPage(0);
                    setState(() {});
                  },
                  child: Text("Выполняющиеся", style: textStyle),
                ),
              ),
              Container(
                decoration: bottomSelectedIndex == 1 ? cDec : cDecTrans,
                child: TextButton(
                  onPressed: () {
                    _pageController.jumpToPage(1);
                    setState(() {});
                  },
                  child: Text("Новые", style: textStyle),
                ),
              ),
              Container(
                decoration: bottomSelectedIndex == 2 ? cDec : cDecTrans,
                child: TextButton(
                  onPressed: () {
                    _pageController.jumpToPage(2);
                    setState(() {});
                  },
                  child: Text("Мои заявки", style: textStyle),
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
        children: [
          Text("Page One"),
          Text("Page Two"),
          Text("Page Three"),
        ],
      ),
    );
  }
}
