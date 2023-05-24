import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/app/my_app.dart';
import 'profile_model.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileDetails extends StatefulWidget {
  final ProfileModel pm;
  final dynamic jData;
  final Function onClickAction;

  ProfileDetails({
    Key? key,
    required this.pm,
    required this.jData,
    required this.onClickAction,
  }) : super(key: key);

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  dynamic comments = [];

  @override
  void initState() {
    ProfileInfo(
      token: widget.pm.token,
    ).getList().then(
      (value) {
        if (value.toString() == '401') {
          final provider = SessionDataProvider();
          provider.setSessionId(null);
          Navigator.of(context).pushNamedAndRemoveUntil(
              MainNavigationRouteNames.changeLang,
              (Route<dynamic> route) => false);
        }

        if (value.contains('Error')) {
        } else {
          print(value);
          comments = json.decode(value);
          setState(() {});
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String img = widget.jData["clientIndivisual"]['photo'];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              widget.onClickAction();
            },
            icon: Icon(Icons.edit),
          ),
        ],
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: comments.length == 0
            ? SizedBox()
            : Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.deepOrange,
                      child: CircleAvatar(
                        radius: 60 - 1,
                        backgroundImage: img.length == 0
                            ? Image.asset('images/Portrait_Placeholder.png',
                                    fit: BoxFit.cover)
                                .image
                            // : Image.memory(_image!, fit: BoxFit.cover).image,
                            : Image.network(
                                    "http://185.116.193.86:8081/profileimage?imagename=$img",
                                    fit: BoxFit.cover)
                                .image,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '${widget.pm.FullName}',
                      style: TextStyle(
                          // color: Colors.black,
                          fontFamily: "Roboto",
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${widget.pm.sysUserTypeName}',
                      style: TextStyle(
                        // color: Colors.grey[500],
                        fontFamily: "Roboto",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Flexible(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            AppColors.primaryColors[1],
                                        child: Icon(
                                          Icons.star_rounded,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '${comments['mainStarCount']}',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            AppColors.primaryColors[1],
                                        child: Icon(
                                          Icons.comment,
                                          color: Colors.red,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '${comments['mainDescCount']}',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.primaryColors[1],
                              child: Icon(
                                Icons.phone_outlined,
                                color: AppColors.primaryColors[0],
                              ),
                            ),

                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.pm.phoneNumber.toString(),
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            // const SerialsListWidget(), //logout
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        ...comments['ranks'].map(
                          (val) {
                            final provider =
                                Provider.of<LocaleProvider>(context);

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 4),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: provider.selectedThemeMode ==
                                          ThemeMode.dark
                                      ? Color.fromRGBO(53, 54, 61, 1)
                                      : Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          val['info'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.justify,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star_rounded,
                                              color: Colors.orange,
                                              size: 15,
                                            ),
                                            Text(
                                              val['rankPoint'].toString(),
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.justify,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          val['rankDate'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.justify,
                                        ),
                                        val['description'].toString().isEmpty
                                            ? SizedBox()
                                            : Text(
                                                val['description'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.justify,
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );

                            // return Text(
                            //   val['info'],
                            //   style: TextStyle(fontSize: 10),
                            // );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

// Container(
//       padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           CircleAvatar(
//             radius: 60,
//             backgroundColor: Colors.deepOrange,
//             child: CircleAvatar(
//               radius: 60 - 1,
//               backgroundImage: _image == null || _image?.length == 0
//                   ? Image.asset(
                      //     'images/Portrait_Placeholder.png',
                      //     fit: BoxFit.cover)
                      // .image
//                   : Image.memory(_image!, fit: BoxFit.cover).image,
//             ),
//           ),
//           SizedBox(height: 16),
//           Text(
//             '${model?.lastName} ${model?.firstName}',
//             style: TextStyle(
//                 // color: Colors.black,
//                 fontFamily: "Roboto",
//                 fontSize: 23,
//                 fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 5),
//           Text(
//             'Грузоотправитель (Физ. лицо)',
//             style: TextStyle(
//               // color: Colors.grey[500],
//               fontFamily: "Roboto",
//               fontSize: 12,
//               fontWeight: FontWeight.w400,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           SizedBox(height: 24),
