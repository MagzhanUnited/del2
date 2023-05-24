import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'posts.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllPost extends StatefulWidget {
  AllPost({Key? key}) : super(key: key);

  @override
  State<AllPost> createState() => _AllPostState();
}

final pm1 = ProfileModel();
List category = [];
bool categoryLoad = true;
bool categoryLoadError = false;

List categoryTems = [];
bool categoryTemsLoad = false;
bool categoryTemsError = false;
int selectedIndex = 0;

class _AllPostState extends State<AllPost> {
  void loadPosts(int index) {
    setState(() {
      categoryTemsLoad = true;
      categoryTemsError = false;
      _selectedIndex = index;
    });
    print(category[index]['catId'].toString());

    GetForumCatTems(
      token: pm1.token.toString(),
      catId: category[index]['catId'],
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
          var docs = json.decode(value);

          print('GetForumCatTems Sucsess');
          categoryTems.clear();
          categoryTems = docs;
          categoryTemsLoad = false;

          setState(() {});
        } else {
          categoryTemsError = true;
          print('Не удалось получить список GetForumCatTems');
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    categoryTemsLoad = false;
    categoryTemsError = false;
    pm1.setupLocale(context).then(
      (value) {
        ForumCategoryLoad(
          token: pm1.token.toString(),
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

              print('ForumCategoryLoad Sucsess');
              category = docs;
              categoryLoad = false;
              categoryLoadError = false;

              if (category.length > 0) {
                selectedIndex = 0;
                loadPosts(selectedIndex);
              }
              setState(() {});
            } else {
              categoryLoad = false;
              categoryLoadError = true;
              print('Не удалось получить список ForumCategoryLoad');
            }
          },
        );
      },
    );
  }

  List<String> contents1 = ["Дороги", "Карты", "Водители", "Машины"];
  String Cat1 = '';

  @override
  Widget build(BuildContext context) {
    contents1.clear();

    for (var item in category) {
      contents1.add(item['catNameRu']);
    }

    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, bottom: 8),
                    child: Text(
                      AppLocalizations.of(context)!.categoty,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        // color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
                      searchBoxStyle: TextStyle(color: Colors.black54),
                      popupBarrierColor: Colors.black54, //меню усты цветы
                      onSaved: (value) => Cat1 = value!,
                      mode: Mode.BOTTOM_SHEET,
                      showSearchBox: true,
                      showSelectedItem: true,
                      items: contents1,
                      selectedItem: contents1.length == 0
                          ? AppLocalizations.of(context)!.select
                          : contents1.first,
                      onChanged: (newValue) {
                        Cat1 = newValue!;
                        int index = contents1.indexOf(Cat1);
                        loadPosts(index);
                      },
                    ),
                  ),
                  // categoryContainer(),

                  categoryTemsLoad && !categoryTemsError
                      ? LoadingData()
                      : categoryTemsLoad && categoryTemsError
                          ? ErorLoadingData()
                          : Posts(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  int _selectedIndex = 0;
  Container categoryContainer() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: category.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              loadPosts(index);
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(left: 20.0),
              height: 100,
              width: 170,
              decoration: BoxDecoration(
                color: _selectedIndex == index
                    ? Theme.of(context).primaryColor.withOpacity(0.8)
                    : Colors.grey.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      category[index]['catNameRu'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.message,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          category[index]['titleCount'].toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
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
                  // color: AppColors.primaryColors[0],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Stack ErorLoadingData() {
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
}
