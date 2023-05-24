import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/ui/widgets/main_screen/bottom_screens/forum/post_screen.dart';
import 'all_post.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class Posts extends StatefulWidget {
  Posts();

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return categoryTems.length == 0
        ? Column(
            children: [
              SizedBox(height: 50),
              Center(
                  child: Text(
                AppLocalizations.of(context)!.netDannyh,
                textAlign: TextAlign.center,
              )),
            ],
          )
        : Column(
            children: categoryTems
                .map(
                  (question) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      color: provider.selectedThemeMode != ThemeMode.dark
                          ? Colors.white
                          : Color.fromRGBO(27, 28, 34, 1),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PostScreen(
                                question: question,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            color: Colors.transparent,
                          ),
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              Container(
                                // height: 70,
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
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  question['creatorName'],
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
                                                        question[
                                                            'createdDate']))
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 14),
                              Text(
                                question['title'],
                                style: TextStyle(
                                  fontSize: 18.0,
                                  letterSpacing: 0.3,
                                  height: 1.27,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 25),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                        "${question['likeCount'] == 0 ? '' : question['likeCount']}",
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
                                        "${question['viewCount'] == 0 ? '' : question['viewCount']}",
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
                                        "${question['commentCount'] == 0 ? '' : question['commentCount']}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          // color: Colors.grey.withOpacity(0.5),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 42),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
  }
}
