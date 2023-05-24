import 'dart:convert';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'post_screen.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyCreaetedPostsPage extends StatefulWidget {
  const MyCreaetedPostsPage({Key? key}) : super(key: key);

  @override
  _MyCreaetedPostsPageState createState() => _MyCreaetedPostsPageState();
}

final pm = ProfileModel();
List myPosts = [];
bool myPostsLoad = false;
bool myPostsLoadError = false;

class _MyCreaetedPostsPageState extends State<MyCreaetedPostsPage> {
  @override
  void initState() {
    super.initState();
    myPostsLoad = true;
    myPostsLoadError = false;
    pm.setupLocale(context).then(
      (value) {
        ForumLoadMyCreatedPosts(
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
                print('ForumCategoryLoad Sucsess');
                myPosts = docs;
                myPostsLoad = false;
                myPostsLoadError = false;
              });
            } else {
              myPostsLoad = false;
              myPostsLoadError = true;
              print('Не удалось получить список ForumCategoryLoad');
            }
          },
        );
      },
    );
  }

  void loadMyPosts() {
    myPostsLoad = true;
    myPostsLoadError = false;
    pm.setupLocale(context).then(
      (value) {
        ForumLoadMyCreatedPosts(
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
                print('ForumCategoryLoad Sucsess');
                myPosts = docs;
                myPostsLoad = false;
                myPostsLoadError = false;
              });
            } else {
              myPostsLoad = false;
              myPostsLoadError = true;
              print('Не удалось получить список ForumCategoryLoad');
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return myPostsLoad && !myPostsLoadError
        ? LoadingData()
        : !myPostsLoad && myPostsLoadError
            ? ErorLoadingData()
            : Scaffold(
                body: Stack(
                  children: [
                    ListView.builder(
                      padding: EdgeInsets.only(top: 18),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: myPosts.length,
                      itemBuilder: (BuildContext context, int index) {
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
                                    builder: (_) => PostScreen(
                                      question: myPosts[index],
                                    ),
                                  ),
                                );
                              }),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                decoration:
                                    BoxDecoration(color: Colors.transparent),
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: [
                                    Container(
                                      height: 60,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              CircleAvatar(
                                                backgroundImage: Image.asset(
                                                        provider.selectedThemeMode ==
                                                                ThemeMode.dark
                                                            ? 'images/Portrait_Placeholder2.png'
                                                            : 'images/Portrait_Placeholder.png',
                                                        fit: BoxFit.cover)
                                                    .image,
                                                radius: 22,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(
                                                        myPosts[index]
                                                            ['creatorName'],
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 4.0),
                                                    Text(
                                                      DateFormat(
                                                              'dd.MM.yyyy, hh:mm')
                                                          .format(DateTime
                                                              .parse(myPosts[
                                                                      index][
                                                                  'createdDate']))
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 14),
                                    Text(
                                      myPosts[index]['title'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.3),
                                    ),
                                    SizedBox(height: 25),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.thumb_up_outlined,
                                              // color: Colors.grey.withOpacity(0.5),
                                              size: 22,
                                            ),
                                            SizedBox(width: 4.0),
                                            Text(
                                              "${myPosts[index]['likeCount'] == 0 ? '' : myPosts[index]['likeCount']}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                // color: Colors.grey.withOpacity(0.5),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(width: 16.0),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.remove_red_eye_outlined,
                                              // color: Colors.grey.withOpacity(0.5),
                                              size: 18,
                                            ),
                                            SizedBox(width: 4.0),
                                            Text(
                                              "${myPosts[index]['viewCount'] == 0 ? '' : myPosts[index]['viewCount']}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                // color: Colors.grey.withOpacity(0.5),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(width: 16.0),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.messenger_outline_rounded,
                                              // color: Colors.grey.withOpacity(0.5),
                                              size: 18,
                                            ),
                                            SizedBox(width: 4.0),
                                            Text(
                                              "${myPosts[index]['commentCount'] == 0 ? '' : myPosts[index]['commentCount']}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                // color: Colors.grey.withOpacity(0.5),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 21),
                                    Divider(
                                        color:
                                            Color.fromARGB(255, 172, 166, 166)),
                                    SizedBox(height: 12),
                                    TextButton.icon(
                                        onPressed: () {
                                          uvereny(myPosts[index])
                                              .then((value) => loadMyPosts());
                                        },
                                        icon: Image.asset("images/delete.png",
                                            width: 20, color: Colors.red),
                                        label: Text(
                                          AppLocalizations.of(context)!
                                              .deletePost,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.3),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
  }

  Container posts() => Container(
        child: myPosts.length == 0
            ? Column(
                children: [
                  SizedBox(height: 50),
                  Center(child: Text(AppLocalizations.of(context)!.netDannyh)),
                ],
              )
            : Column(
                children: myPosts
                    .map(
                      (question) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => PostScreen(
                                        question: question,
                                      )));
                        },
                        child: Container(
                          // height: 180,
                          // padding: EdgeInsets.only(top: 18),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(10.0),
                            // boxShadow: [
                            //   BoxShadow(
                            //       color: Colors.black26.withOpacity(0.05),
                            //       offset: Offset(0.0, 6.0),
                            //       blurRadius: 10.0,
                            //       spreadRadius: 0.10)
                            // ]
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  height: 70,
                                  child: Row(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          SizedBox(width: 5),
                                          CircleAvatar(
                                            backgroundImage: Image.asset(
                                                    'images/Portrait_Placeholder.png',
                                                    fit: BoxFit.cover)
                                                .image,
                                            radius: 22,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.6,
                                                      child: Text(
                                                        question['title'],
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    GestureDetector(
                                                      onTap: () {
                                                        uvereny(question);
                                                      },
                                                      child: Icon(Icons.cancel,
                                                          // color: Colors.black87,
                                                          size: 26),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 2.0),
                                                Column(
                                                  children: <Widget>[
                                                    Text(
                                                      question['creatorName'],
                                                      // style: TextStyle(
                                                      //     color: Colors.grey
                                                      //         .withOpacity(
                                                      //             0.6)),
                                                    ),
                                                    Text(
                                                      DateFormat(
                                                              'hh:mm, dd.MM.yyyy')
                                                          .format(DateTime
                                                              .parse(question[
                                                                  'createdDate']))
                                                          .toString(),
                                                      // style: TextStyle(
                                                      //     color: Colors.grey
                                                      //         .withOpacity(
                                                      //             0.6)),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Icon(
                                      //   Icons.bookmark,
                                      //   color: Colors.grey.withOpacity(0.6),
                                      //   size: 26,
                                      // )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "${question['description']}",
                                      style: TextStyle(
                                        // color: Colors.grey.withOpacity(0.8),
                                        fontSize: 14,
                                        letterSpacing: .3,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.thumb_up_alt_outlined,
                                          // color: Colors.grey.withOpacity(0.6),
                                          size: 13,
                                        ),
                                        SizedBox(width: 4.0),
                                        Text(
                                          "${question['likeCount']} голос",
                                          style: TextStyle(
                                              fontSize: 14,
                                              // color:
                                              //     Colors.grey.withOpacity(0.6),
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.email,
                                          // color: Colors.grey.withOpacity(0.6),
                                          size: 13,
                                        ),
                                        SizedBox(width: 4.0),
                                        Text(
                                          "${question['commentCount']} коммент",
                                          style: TextStyle(
                                            fontSize: 14,
                                            // color:
                                            //     Colors.grey.withOpacity(0.6)
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.remove_red_eye_outlined,
                                          // color: Colors.grey.withOpacity(0.6),
                                          size: 13,
                                        ),
                                        SizedBox(width: 4.0),
                                        Text(
                                          "${question['viewCount']} просмотр",
                                          style: TextStyle(
                                            fontSize: 14,
                                            // color:
                                            //     Colors.grey.withOpacity(0.6)
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
      );

  Future<dynamic> uvereny(question) {
    return showAdaptiveActionSheet(
      context: context,
      title: Text(AppLocalizations.of(context)!.vyUverenyUdalitPost),
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: Text(
            AppLocalizations.of(context)!.yes,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          onPressed: (context) {
            Navigator.of(context).pop();

            GetForumDeleteTems(
              token: pm.token.toString(),
              PostId: question['titleId'],
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
                  // Navigator.of(context).pop();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => MyCreaetedPostsPage(),
                  //   ),
                  // );
                  print('ok GetForumDeleteTems');
                } else {
                  print('Не удалось получить список GetForumDeleteTems');
                }
              },
            );

            print('yes');
          },
          // leading: const Icon(Icons.circle_outlined, size: 25),
        ),
      ],
      cancelAction: CancelAction(
          title: Text(
        AppLocalizations.of(context)!.no,
        style: TextStyle(color: Colors.blueAccent),
      )),
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
                    color: Colors.black54,
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

Future<dynamic> SheetBar(BuildContext context, String token, int titleId) {
  return showAdaptiveActionSheet(
    context: context,
    title: Text(AppLocalizations.of(context)!.vyUverenyUdalitPost),
    actions: <BottomSheetAction>[
      BottomSheetAction(
        title: Text(
          AppLocalizations.of(context)!.yes,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        onPressed: (context) {
          Navigator.of(context).pop();
          print('yes');
        },
        // leading: const Icon(Icons.circle_outlined, size: 25),
      ),
    ],
    cancelAction: CancelAction(
        title: Text(
      AppLocalizations.of(context)!.no,
      style: TextStyle(color: Colors.blueAccent),
    )),
  );
}
