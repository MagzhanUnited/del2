import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import '../main_screen/bottom_screens/menu_page.dart';
import '../main_screen/menu_list/profile/profile_model.dart';
import 'news_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class NewsListWidget extends StatefulWidget {
  NewsListWidget({Key? key}) : super(key: key);

  @override
  State<NewsListWidget> createState() => _NewsListWidgetState();
}

class _NewsListWidgetState extends State<NewsListWidget> {
  List data = [];
  final pm = ProfileModel();

  List news = [];
  bool newsLoad = true;
  bool newsLoadError = false;

  @override
  void initState() {
    super.initState();

    newsLoad = false;
    newsLoadError = false;

    pm.setupLocale(context).then(
      (value) async {
        NewsLoad(
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
              setState(() {
                print('NewsLoad Sucsess');
                news = docs;
                newsLoad = false;
                newsLoadError = false;
              });
            } else {
              print('NewsLoad Error');
              newsLoadError = true;
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return newsLoad && !newsLoadError
        ? LoadingData()
        : newsLoad && newsLoadError
            ? ErorLoadingData()
            : Scaffold(
                drawer: Drawer(child: MenuView()),
                appBar: AppBar(title: Text(AppLocalizations.of(context)!.news)),
                body: Stack(children: [
                  ListView.builder(
                    padding: EdgeInsets.only(top: 18),
                    // padding: EdgeInsets.only(top: 200),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: news.length,
                    // itemExtent: 140,
                    itemBuilder: (BuildContext context, int index) {
                      final posterPath = news[index]['imagePath'];

                      var formatted = "";
                      try {
                        DateTime parseDate =
                            new DateFormat("yyyy-MM-dd HH:mm:ss")
                                .parse(news[index]['createdDate']);
                        var inputDate = DateTime.parse(parseDate.toString());
                        var outputFormat = DateFormat('dd.MM.yyyy, HH:mm');
                        var outputDate = outputFormat.format(inputDate);
                        // print(outputDate);
                        formatted = outputDate;
                      } catch (e) {
                        print('date parse error');
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Material(
                          borderRadius: BorderRadius.circular(5),
                          color: provider.selectedThemeMode != ThemeMode.dark
                              ? Colors.white
                              : Color.fromRGBO(27, 28, 34, 1),
                          child: InkWell(
                            onTap: (() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsDetail(
                                    newsId: news[index]['newsId'],
                                    token: pm.token,
                                    sysUserType: pm.sysUserType,
                                  ),
                                ),
                              );
                            }),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              decoration:
                                  BoxDecoration(color: Colors.transparent),
                              child: Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  posterPath.toString().length == 0
                                      ? SizedBox()
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 19),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Container(
                                              width: double.maxFinite,
                                              child: Image.network(
                                                'http://185.116.193.86:8082/newsimage/${news[index]['newsId']}',
                                                height: 140,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.calendar_today_outlined,
                                              size: 16),
                                          SizedBox(width: 4.0),
                                          Text(
                                            "$formatted",
                                            style: TextStyle(
                                                // color: AppColors.primaryColors[0],
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                      SizedBox(width: 22),
                                      Row(
                                        children: <Widget>[
                                          Icon(Icons.remove_red_eye_outlined,
                                              size: 16),
                                          SizedBox(width: 4.0),
                                          Text(
                                            "${news[index]['viewCount']}",
                                            style: TextStyle(
                                                // color: AppColors.primaryColors[0],
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                      SizedBox(width: 22),
                                      Row(
                                        children: <Widget>[
                                          Icon(Icons.messenger_outline_outlined,
                                              size: 16),
                                          SizedBox(width: 4.0),
                                          Text(
                                            "${news[index]['commentCount']}",
                                            style: TextStyle(
                                                // color: AppColors.primaryColors[0],
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 25),
                                  Text(
                                    news[index]['newsNameRu'],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      height: 1.27,
                                      fontWeight: FontWeight.w500,
                                      // color: AppColors.primaryColors[0],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );

                      // return Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       vertical: 3, horizontal: 16),
                      //   child: Stack(children: [
                      //     Container(
                      //       decoration: BoxDecoration(
                      //         border: Border.all(
                      //             color: Theme.of(context).primaryColor),
                      //         borderRadius:
                      //             BorderRadius.all(Radius.circular(10)),
                      //       ),
                      //       clipBehavior: Clip.hardEdge,
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(3.0),
                      //         child: Column(
                      //           children: [
                      //             Row(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 img,
                      //                 SizedBox(width: 5),
                      //                 Expanded(
                      //                   child: Column(
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.start,
                      //                     children: [
                      //                       SizedBox(height: 5),
                      //                       Text(
                      //                         news[index]['newsNameRu'],
                      //                         style: TextStyle(
                      //                             fontWeight: FontWeight.bold),
                      //                         maxLines: 2,
                      //                         overflow: TextOverflow.ellipsis,
                      //                         textAlign: TextAlign.justify,
                      //                       ),
                      //                       SizedBox(height: 5),
                      //                       Text(
                      //                         formatted,
                      //                         overflow: TextOverflow.ellipsis,
                      //                         style: TextStyle(fontSize: 10),
                      //                       ),
                      //                       SizedBox(height: 5),
                      //                       Text(
                      //                         news[index]['newsDescRu'],
                      //                         style: TextStyle(
                      //                             color: Colors.grey,
                      //                             fontSize: 12),
                      //                         maxLines: 3,
                      //                         overflow: TextOverflow.ellipsis,
                      //                         textAlign: TextAlign.justify,
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //                 SizedBox(width: 5)
                      //               ],
                      //             ),
                      //             SizedBox(height: 10),
                      //             Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               children: <Widget>[
                      //                 Row(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.center,
                      //                   children: <Widget>[
                      //                     Icon(Icons.thumb_up_alt_outlined, size: 13),
                      //                     SizedBox(width: 4.0),
                      //                     Text(
                      //                       "${news[index]['likeCount']} голос",
                      //                       style: TextStyle(
                      //                           color: Colors.grey,
                      //                           fontSize: 12),
                      //                     )
                      //                   ],
                      //                 ),
                      //                 Row(
                      //                   children: <Widget>[
                      //                     Icon(Icons.email, size: 13),
                      //                     SizedBox(width: 4.0),
                      //                     Text(
                      //                       "${news[index]['commentCount']} коммент",
                      //                       style: TextStyle(
                      //                           color: Colors.grey,
                      //                           fontSize: 12),
                      //                     )
                      //                   ],
                      //                 ),
                      //                 Row(
                      //                   children: <Widget>[
                      //                     Icon(Icons.remove_red_eye_outlined, size: 13),
                      //                     SizedBox(width: 4.0),
                      //                     Text(
                      //                       "${news[index]['viewCount']} просмотр",
                      //                       style: TextStyle(
                      //                           color: Colors.grey,
                      //                           fontSize: 12),
                      //                     )
                      //                   ],
                      //                 )
                      //               ],
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     Material(
                      //       color: Colors.transparent,
                      //       child: InkWell(
                      //         borderRadius: BorderRadius.circular(10),
                      //         onTap: () {
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) => NewsDetail(
                      //                 newsId: news[index]['newsId'],
                      //                 token: pm.token,
                      //                 sysUserType: pm.sysUserType,
                      //               ),
                      //             ),
                      //           );
                      //         },
                      //       ),
                      //     )
                      //   ]),
                      // );
                    },
                  ),
                ]),
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
