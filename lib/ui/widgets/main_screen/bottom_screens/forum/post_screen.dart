import 'dart:convert';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:themoviedb/Theme/app_colors.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostScreen extends StatefulWidget {
  final dynamic question;
  PostScreen({required this.question});
  _PostScreenState createState() => _PostScreenState();
}

final pm = ProfileModel();
List comments = [];
bool commentsLoad = false;
bool commentsLoadError = false;

var msgController = TextEditingController();

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();

    msgController.text = '';

    commentsLoad = true;
    commentsLoadError = false;

    pm.setupLocale(context).then(
      (value) {
        LoadForumCatPostComments(
          token: pm.token.toString(),
          postId: widget.question['titleId'],
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
              setState(() {
                print('LoadForumCatPostComments Sucsess');
                comments = docs;
                commentsLoad = false;
              });
            } else {
              commentsLoad = false;
              commentsLoadError = true;
              print('Не удалось получить список LoadForumCatPostComments');
            }
          },
        );
      },
    );
  }

  void initComment() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    msgController.text = '';

    commentsLoad = true;
    commentsLoadError = false;

    pm.setupLocale(context).then(
      (value) {
        LoadForumCatPostComments(
          token: pm.token.toString(),
          postId: widget.question['titleId'],
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
              setState(() {
                print('LoadForumCatPostComments Sucsess');
                comments = docs;
                commentsLoad = false;
              });
            } else {
              commentsLoad = false;
              commentsLoadError = true;
              print('Не удалось получить список LoadForumCatPostComments');
            }
          },
        );
      },
    );
  }

  void initLike() {
    ForumTitleLikePost(
      token: pm.token.toString(),
      postId: widget.question['titleId'],
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
          setState(() {
            widget.question['likeCount'] = docs.toString();
            print('ForumTitleLikePost Sucsess ' + docs.toString());
          });
        } else {
          print('Не удалось получить список ForumTitleLikePost');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(top: 18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: provider.selectedThemeMode != ThemeMode.dark
                    ? Colors.white
                    : Color.fromRGBO(27, 28, 34, 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                      provider.selectedThemeMode ==
                                              ThemeMode.dark
                                          ? 'images/Portrait_Placeholder2.png'
                                          : 'images/Portrait_Placeholder.png',
                                      fit: BoxFit.cover)
                                  .image,
                              radius: 22,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      widget.question['creatorName'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    DateFormat('dd.MM.yyyy, hh:mm')
                                        .format(DateTime.parse(
                                            widget.question['createdDate']))
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            )
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
                  SizedBox(height: 14),
                  Text(
                    widget.question['title'],
                    style: TextStyle(
                      fontSize: 18.0,
                      letterSpacing: 0.3,
                      height: 1.27,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          initLike();
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.thumb_up_outlined,
                              // color: Colors.grey.withOpacity(0.5),
                              size: 22,
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              "${widget.question['likeCount']}",
                              style: TextStyle(
                                fontSize: 14,
                                // color: Colors.grey.withOpacity(0.5),
                              ),
                            )
                          ],
                        ),
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
                            "${widget.question['viewCount']}",
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
                  SizedBox(height: 24),
                  Divider(color: Color.fromARGB(255, 172, 166, 166)),
                  SizedBox(height: 24),
                  widget.question['image'] == ''
                      ? SizedBox()
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewNetworkImg(
                                  NetImgLink:
                                      'http://185.116.193.86:8081/images?imagename=${widget.question['image']}',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(5)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: SizedBox.fromSize(
                                // size:
                                //     Size.fromRadius(200),
                                child: Image.network(
                                    'http://185.116.193.86:8081/images?imagename=${widget.question['image']}',
                                    fit: BoxFit.fill),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 15),
                  Text(
                    widget.question['description'],
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 24),
                  Divider(color: Color.fromARGB(255, 172, 166, 166)),
                  SizedBox(height: 24),
                  Text(
                    "${AppLocalizations.of(context)!.comments} (${widget.question['commentCount']})",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      // color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 18),
                  commentsLoad && !commentsLoadError
                      ? LoadingData()
                      : !commentsLoad && commentsLoadError
                          ? ErorLoadingData()
                          : Column(
                              children: comments
                                  .map(
                                    (reply) => Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            // height: 60,
                                            // color: Colors.white,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                        backgroundImage:
                                                            Image.asset(
                                                                    'images/Portrait_Placeholder.png',
                                                                    fit: BoxFit
                                                                        .cover)
                                                                .image,
                                                        radius: 18),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Container(
                                                            child: Text(
                                                              reply[
                                                                  'creatorName'],
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ),
                                                          SizedBox(height: 4.0),
                                                          Text(
                                                            DateFormat(
                                                                    'dd.MM.yyyy, hh:mm')
                                                                .format(
                                                                  DateTime
                                                                      .parse(
                                                                    reply['createdData']
                                                                        .toString(),
                                                                  ),
                                                                )
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // reply['creatorId'] !=
                                                //         reply['loginedId']
                                                //     ? SizedBox()
                                                //     : GestureDetector(
                                                //         onTap: () {
                                                //           uvereny(reply);
                                                //         },
                                                //         child: Icon(
                                                //             Icons.cancel,
                                                //             size: 23),
                                                //       ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 14),
                                          Text(
                                            reply['description'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          GestureDetector(
                                            onTap: () {
                                              print("${reply['commentId']}");
                                              ForumLikeComment(
                                                token: pm.token.toString(),
                                                commentId: reply['commentId'],
                                              ).get().then(
                                                (value) {
                                                  if (value.toString() ==
                                                      '401') {
                                                    final provider =
                                                        SessionDataProvider();
                                                    provider.setSessionId(null);
                                                    Navigator.of(context)
                                                        .pushNamedAndRemoveUntil(
                                                            MainNavigationRouteNames
                                                                .changeLang,
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                  }

                                                  if (value != 'error') {
                                                    initComment();
                                                    print(
                                                        'ok ForumLikeComment');
                                                  } else {
                                                    print(
                                                        'Error ForumLikeComment');
                                                  }
                                                },
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.thumb_up_alt_outlined,
                                                  // color: Colors.grey
                                                  //     .withOpacity(0.5),
                                                  size: 20,
                                                ),
                                                SizedBox(width: 5.0),
                                                Text(
                                                  "${reply['likeCount'] == 0 ? '' : reply['likeCount']}",
                                                  // style: TextStyle(
                                                  //     color: Colors.grey
                                                  //         .withOpacity(0.5)),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 24),
                                          Divider(
                                              color: Color.fromARGB(
                                                  255, 172, 166, 166)),
                                          SizedBox(height: 24),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                  decoration: provider.selectedThemeMode ==
                                          ThemeMode.dark
                                      ? InputDecoration(
                                          isDense: true,
                                          fillColor:
                                              Color.fromRGBO(53, 54, 61, 1),
                                          filled: true,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      228, 232, 250, 1))),
                                        )
                                      : InputDecoration(
                                          isDense: true,
                                          fillColor: Colors.white,
                                          filled: true,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      228, 232, 250, 1))),
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
                              ForumAddComments(
                                token: pm.token.toString(),
                                description: msgController.text,
                                titleId: widget.question['titleId'],
                              ).get().then(
                                (value) {
                                  if (value.toString() == '401') {
                                    final provider = SessionDataProvider();
                                    provider.setSessionId(null);
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            MainNavigationRouteNames.changeLang,
                                            (Route<dynamic> route) => false);
                                  }

                                  if (value != 'error') {
                                    print('ForumAddComments Ok!');
                                    initComment();
                                  } else {
                                    print('ForumAddComments Error');
                                  }
                                },
                              );
                            }
                          },
                          label: Text(AppLocalizations.of(context)!.otpravit),
                          icon: Image.asset(
                            "images/11check.png",
                            width: 16,
                            height: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        // body: Stack(
        //   children: <Widget>[
        //     SafeArea(
        //       child: ListView(
        //         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        //         children: <Widget>[
        //           Container(
        //             margin: EdgeInsets.symmetric(horizontal: 15.0),
        //             decoration: BoxDecoration(
        //               // color: Colors.white,
        //               borderRadius: BorderRadius.circular(10.0),
        //               border: Border.all(color: Theme.of(context).primaryColor),
        //               // boxShadow: [
        //               //   BoxShadow(
        //               //       // color: Colors.black26.withOpacity(0.05),
        //               //       offset: Offset(0.0, 6.0),
        //               //       blurRadius: 10.0,
        //               //       spreadRadius: 0.10)
        //               // ]
        //             ),
        //             child: Padding(
        //               padding: const EdgeInsets.all(15.0),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: <Widget>[
        //                   Container(
        //                     height: 60,
        //                     // color: Colors.white,
        //                     child: Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: <Widget>[
        //                         Row(
        //                           children: <Widget>[
        //                             CircleAvatar(
        //                               backgroundImage: Image.asset(
        //                                       'images/Portrait_Placeholder.png',
        //                                       fit: BoxFit.cover)
        //                                   .image,
        //                               radius: 22,
        //                             ),
        //                             Padding(
        //                               padding: const EdgeInsets.only(left: 8.0),
        //                               child: Column(
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.start,
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.center,
        //                                 children: <Widget>[
        //                                   Container(
        //                                     child: Text(
        //                                       widget.question['creatorName'],
        //                                       style: TextStyle(
        //                                         fontSize: 15,
        //                                         fontWeight: FontWeight.bold,
        //                                       ),
        //                                     ),
        //                                   ),
        //                                   SizedBox(height: 2.0),
        //                                   Text(
        //                                     DateFormat('hh:mm, dd.MM.yyyy')
        //                                         .format(DateTime.parse(widget
        //                                             .question['createdDate']))
        //                                         .toString(),
        //                                     // style: TextStyle(color: Colors.grey),
        //                                   )
        //                                 ],
        //                               ),
        //                             )
        //                           ],
        //                         ),
        //                         // Icon(
        //                         //   Icons.bookmark,
        //                         //   color: Colors.grey.withOpacity(0.6),
        //                         //   size: 26,
        //                         // )
        //                       ],
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: EdgeInsets.symmetric(vertical: 15.0),
        //                     child: Text(
        //                       widget.question['title'],
        //                       style: TextStyle(
        //                         fontSize: 16,
        //                         // color: Colors.black.withOpacity(0.8),
        //                         fontWeight: FontWeight.bold,
        //                       ),
        //                     ),
        //                   ),
        //                   Text(
        //                     widget.question['description'],
        //                     style: TextStyle(
        //                       // color: Colors.black.withOpacity(0.4),
        //                       fontSize: 15,
        //                     ),
        //                   ),
        //                   SizedBox(height: 5.0),
        //                   widget.question['image'] == ''
        //                       ? Container()
        //                       : GestureDetector(
        //                           onTap: () {
        //                             Navigator.push(
        //                               context,
        //                               MaterialPageRoute(
        //                                 builder: (context) => ViewNetworkImg(
        //                                   NetImgLink:
        //                                       'http://185.116.193.86.kz:8081/images?imagename=${widget.question['image']}',
        //                                 ),
        //                               ),
        //                             );
        //                           },
        //                           child: Container(
        //                             padding: EdgeInsets.all(1),
        //                             decoration: BoxDecoration(
        //                                 color: Colors.black54,
        //                                 borderRadius: BorderRadius.circular(5)),
        //                             child: ClipRRect(
        //                               borderRadius: BorderRadius.circular(5),
        //                               child: SizedBox.fromSize(
        //                                 // size:
        //                                 //     Size.fromRadius(200),
        //                                 child: Image.network(
        //                                     'http://185.116.193.86.kz:8081/images?imagename=${widget.question['image']}',
        //                                     fit: BoxFit.fill),
        //                               ),
        //                             ),
        //                           ),
        //                         ),
        //                   SizedBox(height: 15),
        //                   Padding(
        //                     padding: EdgeInsets.symmetric(vertical: 5.0),
        //                     child: Row(
        //                       mainAxisAlignment: MainAxisAlignment.start,
        //                       children: <Widget>[
        //                         GestureDetector(
        //                           onTap: () {
        //                             print('object');
        //                             initLike();
        //                             // Navigator.push(
        //                             //   context,
        //                             //   MaterialPageRoute(
        //                             //     builder: (context) => ViewNetworkImg(
        //                             //       NetImgLink:
        //                             //           'http://185.116.193.86.kz:8081/images?imagename=${widget.question['image']}',
        //                             //     ),
        //                             //   ),
        //                             // );
        //                           },
        //                           child: Row(
        //                             crossAxisAlignment: CrossAxisAlignment.center,
        //                             children: <Widget>[
        //                               Icon(
        //                                 Icons.thumb_up,
        //                                 // color: Colors.grey.withOpacity(0.5),
        //                                 size: 22,
        //                               ),
        //                               SizedBox(width: 4.0),
        //                               Text(
        //                                 "${widget.question['likeCount']} голос",
        //                                 style: TextStyle(
        //                                   fontSize: 14,
        //                                   // color: Colors.grey.withOpacity(0.5),
        //                                 ),
        //                               )
        //                             ],
        //                           ),
        //                         ),
        //                         SizedBox(width: 15.0),
        //                         Row(
        //                           children: <Widget>[
        //                             Icon(
        //                               Icons.remove_red_eye,
        //                               // color: Colors.grey.withOpacity(0.5),
        //                               size: 18,
        //                             ),
        //                             SizedBox(width: 4.0),
        //                             Text(
        //                               "${widget.question['viewCount']} просмотр",
        //                               style: TextStyle(
        //                                 fontSize: 14,
        //                                 // color: Colors.grey.withOpacity(0.5),
        //                                 fontWeight: FontWeight.w600,
        //                               ),
        //                             )
        //                           ],
        //                         )
        //                       ],
        //                     ),
        //                   )
        //                 ],
        //               ),
        //             ),
        //           ),
        //           Padding(
        //             padding: EdgeInsets.only(left: 15.0, top: 20.0, bottom: 10.0),
        //             child: Text(
        //               "Комментарии (${widget.question['commentCount']})",
        //               style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 // color: Colors.black,
        //               ),
        //             ),
        //           ),
        //           commentsLoad && !commentsLoadError
        //               ? LoadingData()
        //               : !commentsLoad && commentsLoadError
        //                   ? ErorLoadingData()
        //                   : Column(
        //                       children: comments
        //                           .map((reply) => Container(
        //                               margin: EdgeInsets.only(
        //                                   left: 15.0, right: 15.0, top: 10.0),
        //                               decoration: BoxDecoration(
        //                                 // color: Colors.white,
        //                                 border: Border.all(
        //                                     color:
        //                                         Theme.of(context).primaryColor),
        //                                 borderRadius: BorderRadius.circular(10.0),
        //                                 // boxShadow: [
        //                                 //   BoxShadow(
        //                                 //       color: Colors.black26
        //                                 //           .withOpacity(0.03),
        //                                 //       offset: Offset(0.0, 6.0),
        //                                 //       blurRadius: 10.0,
        //                                 //       spreadRadius: 0.10)
        //                                 // ],
        //                               ),
        //                               child: Padding(
        //                                 padding: EdgeInsets.all(10.0),
        //                                 child: Column(
        //                                   crossAxisAlignment:
        //                                       CrossAxisAlignment.start,
        //                                   children: <Widget>[
        //                                     Container(
        //                                       height: 60,
        //                                       // color: Colors.white,
        //                                       child: Row(
        //                                         mainAxisAlignment:
        //                                             MainAxisAlignment
        //                                                 .spaceBetween,
        //                                         children: <Widget>[
        //                                           Row(
        //                                             children: <Widget>[
        //                                               CircleAvatar(
        //                                                 backgroundImage: Image.asset(
        //                                                         'images/Portrait_Placeholder.png',
        //                                                         fit: BoxFit.cover)
        //                                                     .image,
        //                                                 radius: 18,
        //                                               ),
        //                                               Padding(
        //                                                 padding:
        //                                                     const EdgeInsets.only(
        //                                                         left: 8.0),
        //                                                 child: Column(
        //                                                   crossAxisAlignment:
        //                                                       CrossAxisAlignment
        //                                                           .start,
        //                                                   mainAxisAlignment:
        //                                                       MainAxisAlignment
        //                                                           .center,
        //                                                   children: <Widget>[
        //                                                     Container(
        //                                                       child: Text(
        //                                                         reply[
        //                                                             'creatorName'],
        //                                                         style: TextStyle(
        //                                                           fontSize: 15,
        //                                                           fontWeight:
        //                                                               FontWeight
        //                                                                   .w600,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                     SizedBox(height: 2.0),
        //                                                     Text(
        //                                                       DateFormat(
        //                                                               'hh:mm, dd.MM.yyyy')
        //                                                           .format(
        //                                                             DateTime
        //                                                                 .parse(
        //                                                               reply['createdData']
        //                                                                   .toString(),
        //                                                             ),
        //                                                           )
        //                                                           .toString(),
        //                                                       // style: TextStyle(
        //                                                       //     color: Colors
        //                                                       //         .grey
        //                                                       //         .withOpacity(
        //                                                       //             0.4)),
        //                                                     )
        //                                                   ],
        //                                                 ),
        //                                               ),
        //                                             ],
        //                                           ),
        //                                           reply['creatorId'] !=
        //                                                   reply['loginedId']
        //                                               ? SizedBox()
        //                                               : GestureDetector(
        //                                                   onTap: () {
        //                                                     uvereny(reply);
        //                                                   },
        //                                                   child: Icon(
        //                                                       Icons.cancel,
        //                                                       // color:
        //                                                       //     Colors.black87,
        //                                                       size: 23),
        //                                                 ),
        //                                         ],
        //                                       ),
        //                                     ),
        //                                     Padding(
        //                                       padding: const EdgeInsets.symmetric(
        //                                           vertical: 10.0),
        //                                       child: Text(
        //                                         reply['description'],
        //                                         style: TextStyle(
        //                                           // color: Colors.black
        //                                           //     .withOpacity(0.25),
        //                                           fontSize: 14,
        //                                         ),
        //                                       ),
        //                                     ),
        //                                     GestureDetector(
        //                                       onTap: () {
        //                                         print("${reply['commentId']}");
        //                                         ForumLikeComment(
        //                                           token: pm.token.toString(),
        //                                           commentId: reply['commentId'],
        //                                         ).get().then(
        //                                           (value) {
        //                                             if (value.toString() ==
        //                                                 '401') {
        //                                               final provider =
        //                                                   SessionDataProvider();
        //                                               provider.setSessionId(null);
        //                                               Navigator.of(context)
        //                                                   .pushNamedAndRemoveUntil(
        //                                                       MainNavigationRouteNames
        //                                                           .changeLang,
        //                                                       (Route<dynamic>
        //                                                               route) =>
        //                                                           false);
        //                                             }

        //                                             if (value != 'error') {
        //                                               initComment();
        //                                               print(
        //                                                   'ok ForumLikeComment');
        //                                             } else {
        //                                               print(
        //                                                   'Error ForumLikeComment');
        //                                             }
        //                                           },
        //                                         );
        //                                       },
        //                                       child: Row(
        //                                         mainAxisAlignment:
        //                                             MainAxisAlignment.start,
        //                                         children: <Widget>[
        //                                           Icon(
        //                                             Icons.thumb_up,
        //                                             // color: Colors.grey
        //                                             //     .withOpacity(0.5),
        //                                             size: 20,
        //                                           ),
        //                                           SizedBox(width: 5.0),
        //                                           Text(
        //                                             "${reply['likeCount']}",
        //                                             // style: TextStyle(
        //                                             //     color: Colors.grey
        //                                             //         .withOpacity(0.5)),
        //                                           )
        //                                         ],
        //                                       ),
        //                                     )
        //                                   ],
        //                                 ),
        //                               )))
        //                           .toList(),
        //                     ),
        //           SizedBox(height: 90),
        //         ],
        //       ),
        //     ),
        //     Align(
        //       alignment: Alignment.bottomLeft,
        //       child: Container(
        //         padding: EdgeInsets.all(5),
        //         // height: 50,
        //         width: double.infinity,
        //         // color: Colors.white,
        //         child: Row(
        //           children: <Widget>[
        //             Expanded(
        //               child: TextField(
        //                 controller: msgController,
        //                 decoration: InputDecoration(
        //                   hintText: "Напишите комментарии ...",
        //                   // hintStyle: TextStyle(color: Colors.black54),
        //                   border: OutlineInputBorder(),
        //                   contentPadding:
        //                       EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        //                   isDense: true,
        //                 ),
        //                 minLines: 1,
        //                 maxLines: 3,
        //                 keyboardType: TextInputType.text,
        //                 maxLength: 250,
        //               ),
        //             ),
        //             SizedBox(
        //               width: 10,
        //             ),
        //             FloatingActionButton(
        //               mini: true,
        //               onPressed: () {
        //                 if (msgController.text != '') {
        //                   ForumAddComments(
        //                     token: pm.token.toString(),
        //                     description: msgController.text,
        //                     titleId: widget.question['titleId'],
        //                   ).get().then(
        //                     (value) {
        //                       if (value.toString() == '401') {
        //                         final provider = SessionDataProvider();
        //                         provider.setSessionId(null);
        //                         Navigator.of(context).pushNamedAndRemoveUntil(
        //                             MainNavigationRouteNames.changeLang,
        //                             (Route<dynamic> route) => false);
        //                       }

        //                       if (value != 'error') {
        //                         print('ForumAddComments Ok!');
        //                         initComment();
        //                       } else {
        //                         print('ForumAddComments Error');
        //                       }
        //                     },
        //                   );
        //                 }
        //               },
        //               child: Icon(
        //                 Icons.send,
        //                 color: Colors.white,
        //                 size: 22,
        //               ),
        //               backgroundColor: Colors.blue,
        //               elevation: 0,
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
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

  Future<dynamic> uvereny(question) {
    return showAdaptiveActionSheet(
      context: context,
      title: Text(AppLocalizations.of(context)!.udalitKomment),
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: Text(
            AppLocalizations.of(context)!.yes,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.mainOrange,
            ),
          ),
          onPressed: (context) {
            Navigator.of(context).pop();

            GetForumDeleteComment(
              token: pm.token.toString(),
              commentId: question['commentId'],
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
                  initComment();
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
        AppLocalizations.of(context)!.povtoritePopitku2,
        style: TextStyle(color: Colors.blueAccent),
      )),
    );
  }
}

class ViewNetworkImg extends StatelessWidget {
  final String NetImgLink;
  const ViewNetworkImg({
    Key? key,
    required this.NetImgLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Просмотр',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: Image.network(NetImgLink, fit: BoxFit.cover).image,
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 3.5,
          initialScale: PhotoViewComputedScale.contained,
          basePosition: Alignment.center,
        ),
      ),
    );
  }
}
