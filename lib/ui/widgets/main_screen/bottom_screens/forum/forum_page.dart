import 'package:flutter/material.dart';
import 'package:themoviedb/ui/widgets/main_screen/bottom_screens/forum/all_post.dart';
import 'package:themoviedb/ui/widgets/main_screen/bottom_screens/forum/my_created_posts.dart';
import 'package:themoviedb/ui/widgets/main_screen/bottom_screens/menu_page.dart';
import '../../../app/my_app.dart';
import 'add_post.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

PageController _pageController = PageController(
  initialPage: 0,
  keepPage: false,
);
int bottomSelectedIndex = 0;

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
    bottomSelectedIndex = 0;
    _pageController = PageController(
      initialPage: 0,
      keepPage: false,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
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
        // color: AppColors.primaryColors[0],
        fontWeight: FontWeight.w600,
        fontSize: 14,
        letterSpacing: 0.3);

    return Scaffold(
      drawer: Drawer(child: MenuView()),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.forum),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPostPage()),
              );
            },
            icon: Icon(
              Icons.add_box_outlined,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
              // color: Color.fromARGB(255, 18, 25, 56),
            ),
            label: Text(AppLocalizations.of(context)!.newPost,
                style: TextStyle(
                    color: provider.selectedThemeMode == ThemeMode.dark
                        ? Colors.white
                        : AppColors.primaryColors[0],
                    // color: AppColors.primaryColors[0],
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 0.3)),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: ButtonBar(
            alignment: MainAxisAlignment.start,
            buttonPadding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 16, right: 24),
                decoration: bottomSelectedIndex == 0 ? cDec : cDecTrans,
                child: TextButton(
                  onPressed: () {
                    _pageController.jumpToPage(0);
                    setState(() {});
                  },
                  child: Text(AppLocalizations.of(context)!.vsePosty, style: textStyle),
                ),
              ),
              Container(
                decoration: bottomSelectedIndex == 1 ? cDec : cDecTrans,
                child: TextButton(
                  onPressed: () {
                    _pageController.jumpToPage(1);
                    setState(() {});
                  },
                  child: Text(AppLocalizations.of(context)!.moiPosty, style: textStyle),
                ),
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          bottomSelectedIndex = index;
          setState(() {});
        },
        children: [
          AllPost(),
          MyCreaetedPostsPage(),
        ],
      ),
    );
  }
}
