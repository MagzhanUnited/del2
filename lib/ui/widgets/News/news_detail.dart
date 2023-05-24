import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class NewsDetail extends StatefulWidget {
  final int newsId;
  final String token;
  final String sysUserType;

  const NewsDetail({
    required this.newsId,
    required this.token,
    required this.sysUserType,
    Key? key,
  }) : super(key: key);

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  dynamic news = [];
  List commentNews = [];
  bool newsLoad = true;
  bool newsLoadError = false;

  bool commentsLoad = false;
  bool commentsLoadError = false;

  var msgController = TextEditingController();

  @override
  void initState() {
    super.initState();

    msgController.text = '';

    newsLoad = true;
    newsLoadError = false;

    commentsLoad = false;
    commentsLoadError = false;

    NewsLoadMore(
      token: widget.token,
      newsId: widget.newsId,
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
          setState(() {
            newsLoadError = true;
          });
        }
      },
    );
  }

  void initLike() {
    LikeNews(
      token: widget.token,
      newsId: widget.newsId,
    ).get().then(
      (value) {
        if (value.toString() == '401') {
          final provider = SessionDataProvider();
          provider.setSessionId(null);
          Navigator.of(context).pushNamedAndRemoveUntil(
              MainNavigationRouteNames.changeLang,
              (Route<dynamic> route) => false);
        }

        try {
          print('like news');
          setState(() {
            news['likeCount'] = int.tryParse(value);
          });
        } catch (e) {
          print('Не удалось поставить лайк');
        }
      },
    );
  }

  void loadComment() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    setState(() {
      msgController.text = '';
      commentsLoad = true;
      commentsLoadError = false;
    });

    Viewnewscomment(
      token: widget.token,
      newsId: widget.newsId,
    ).get().then(
      (value) {
        if (value.toString() == '401') {
          final provider = SessionDataProvider();
          provider.setSessionId(null);
          Navigator.of(context).pushNamedAndRemoveUntil(
              MainNavigationRouteNames.changeLang,
              (Route<dynamic> route) => false);
        }

        try {
          var docs = json.decode(value);

          print('loadComment news');

          setState(() {
            commentNews = docs;
            commentsLoad = false;
            commentsLoadError = false;
          });
        } catch (e) {
          print('Не удалось Загрузить комменты');
          setState(() {
            commentsLoad = false;
            commentsLoadError = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    var posterPath = "";
    var formatted = "";

    if (news.length > 0) {
      posterPath = news['imagePath'];

      try {
        DateTime parseDate =
            new DateFormat("yyyy-MM-dd HH:mm:ss").parse(news['createdDate']);
        var inputDate = DateTime.parse(parseDate.toString());
        var outputFormat = DateFormat('dd.MM.yyyy, HH:mm');
        var outputDate = outputFormat.format(inputDate);
        // print(outputDate);
        formatted = outputDate;
      } catch (e) {
        print('date parse error');
      }
    }

    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //   "Новости",
        // ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: newsLoad && !newsLoadError
          ? LoadingData()
          : newsLoad && newsLoadError
              ? ErorLoadingData()
              : SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.only(top: 18),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: provider.selectedThemeMode != ThemeMode.dark
                            ? Colors.white
                            : Color.fromRGBO(27, 28, 34, 1),
                      ),
                      child: new Column(
                        children: <Widget>[
                          posterPath.toString().length == 0
                              ? SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 19),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      width: double.maxFinite,
                                      child: Image.network(
                                        'http://185.116.193.86:8082/newsimage/${news['newsId']}',
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.calendar_today_outlined, size: 16),
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
                                  Icon(Icons.remove_red_eye_outlined, size: 16),
                                  SizedBox(width: 4.0),
                                  Text(
                                    "${news['viewCount']}",
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
                                    "${news['commentCount']}",
                                    style: TextStyle(
                                        // color: AppColors.primaryColors[0],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 13),
                          Text(
                            news['newsNameRu'],
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              // color: AppColors.primaryColors[0],
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                          ),
                          new Padding(
                            padding: new EdgeInsets.symmetric(vertical: 24.0),
                            child: new Divider(
                              height: 1.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          new Text(
                            news['newsMoreRu'],
                            style: new TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.3,
                              height: 1.6,
                              // color: AppColors.primaryColors[0],
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    print('object 309');
                                    initLike();
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.thumb_up_alt_outlined,
                                        // color: Colors.grey.withOpacity(0.5),
                                        size: 22,
                                      ),
                                      SizedBox(width: 4.0),
                                      Text(
                                        "${news['likeCount']} голос",
                                        style: TextStyle(
                                          fontSize: 14,
                                          // color: Colors.grey.withOpacity(0.5),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20.0),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.remove_red_eye_outlined,
                                      // color: Colors.grey.withOpacity(0.5),
                                      size: 18,
                                    ),
                                    SizedBox(width: 4.0),
                                    Text(
                                      "${news['viewCount']} просмотр",
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
                          ),
                          TextButton(
                              onPressed: () {
                                loadComment();
                              },
                              child: Row(
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context)!.comments} (${news['commentCount']})',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey,
                                  )
                                ],
                              )),
                          commentsLoad && !commentsLoadError
                              ? LoadingData()
                              : !commentsLoad && commentsLoadError
                                  ? ErorLoadingData()
                                  : Column(
                                      children: commentNews
                                          .map((reply) =>
                                              newMethod(reply, context))
                                          .toList(),
                                    ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 24),
                                Divider(
                                    color: Color.fromARGB(255, 172, 166, 166)),
                                SizedBox(height: 24),
                                Text(
                                  AppLocalizations.of(context)!.ostavitComment,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    // color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  AppLocalizations.of(context)!.comment,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    // color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  // padding: EdgeInsets.all(5),
                                  // height: 50,
                                  width: double.infinity,
                                  // color: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: TextField(
                                          controller: msgController,
                                          decoration: provider
                                                      .selectedThemeMode ==
                                                  ThemeMode.dark
                                              ? InputDecoration(
                                                  isDense: true,
                                                  fillColor: Color.fromRGBO(
                                                      53, 54, 61, 1),
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromRGBO(
                                                              228,
                                                              232,
                                                              250,
                                                              1))),
                                                )
                                              : InputDecoration(
                                                  isDense: true,
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromRGBO(
                                                              228,
                                                              232,
                                                              250,
                                                              1))),
                                                ),
                                          minLines: 3,
                                          maxLines: 3,
                                          keyboardType: TextInputType.text,
                                          // maxLength: 250,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    if (msgController.text != '') {
                                      NewsAddComments(
                                        token: widget.token,
                                        description: msgController.text,
                                        newsId: widget.newsId,
                                      ).get().then(
                                        (value) {
                                          if (value.toString() == '401') {
                                            final provider =
                                                SessionDataProvider();
                                            provider.setSessionId(null);
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    MainNavigationRouteNames
                                                        .changeLang,
                                                    (Route<dynamic> route) =>
                                                        false);
                                          }

                                          if (value != 'error') {
                                            print('NewsAddComments Ok!');
                                            loadComment();
                                          } else {
                                            print('NewsAddComments Error');
                                          }
                                        },
                                      );
                                    }
                                  },
                                  label: Text(
                                      AppLocalizations.of(context)!.otpravit),
                                  icon: Image.asset("images/11check.png",
                                      width: 16,
                                      height: 16,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Container newMethod(reply, BuildContext context) {
    String formatted = reply['createdDate'].toString();
    try {
      DateTime parseDate =
          new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(formatted);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('dd.MM.yyyy, HH:mm');
      var outputDate = outputFormat.format(inputDate);
      // print(outputDate);
      formatted = outputDate;
    } catch (e) {
      print('date parse error');
    }
    return Container(
        // margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
        // decoration: BoxDecoration(
        //   // color: Colors.white,
        //   border: Border.all(color: Theme.of(context).primaryColor),
        //   borderRadius: BorderRadius.circular(10.0),
        // ),
        child: Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 60,
            // color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: Image.asset(
                              'images/Portrait_Placeholder.png',
                              fit: BoxFit.cover)
                          .image,
                      radius: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              reply['sysUserType'] == "1" ||
                                      reply['sysUserType'] == "3"
                                  ? "${reply['lastName']} ${reply['firstName']} ${reply['thirdName']}"
                                  : "${reply['lastName']}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Text("${formatted}")
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              reply['description'],
              style: TextStyle(
                // color: Colors.black
                //     .withOpacity(0.25),
                fontSize: 14,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              print("${reply['commentId']}");
              NewsLikeComment(
                token: widget.token.toString(),
                commentId: reply['commentId'],
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
                    loadComment();
                    print('ok nEWSLikeComment');
                  } else {
                    print('Error nEWSLikeComment');
                  }
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.thumb_up_alt_outlined, size: 20),
                SizedBox(width: 5.0),
                Text(
                  "${reply['likeCount']}",
                )
              ],
            ),
          )
        ],
      ),
    ));
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
