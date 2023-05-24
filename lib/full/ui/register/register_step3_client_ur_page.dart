import 'dart:convert';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';

import '../../../ui/widgets/main_screen/menu_list/profile/profile_page.dart';

import 'package:provider/provider.dart' as pv;
import 'package:themoviedb/providers/locale_provider.dart';

class RegisterStep3ClientUrView extends StatefulWidget {
  final bool edit;
  final bool swapeRole;
  final dynamic jdata;
  RegisterStep3ClientUrView({
    Key? key,
    required this.edit,
    required this.jdata,
    required this.swapeRole,
  }) : super(key: key);

  @override
  _RegisterStep3ClientUrViewState createState() =>
      _RegisterStep3ClientUrViewState();
}

class _RegisterStep3ClientUrViewState extends State<RegisterStep3ClientUrView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.edit
              ? AppLocalizations.of(context)!.redaktirovanieDannyh
              : AppLocalizations.of(context)!.register,
          style: TextStyle(
            // color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: MyStatefulWidget(
          edit: widget.edit,
          swapeRole: widget.swapeRole,
          jdata: widget.jdata,
        ),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  final bool edit;
  final bool swapeRole;
  final dynamic jdata;
  const MyStatefulWidget(
      {Key? key,
      required this.edit,
      required this.jdata,
      required this.swapeRole})
      : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

// bool isChecked1 = true;
// bool isChecked2 = false;
String isEmpWidget = '';

final nameComp = TextEditingController();
final biin = TextEditingController();
final adressComp = TextEditingController();
final emailComp = TextEditingController();
final base64img = TextEditingController(text: '');
final pathImg = TextEditingController();

final ImagePicker _imagePicker = ImagePicker();
List<XFile> _imageList = [];
Uint8List? _image;

bool _isPressed = false;
final pm = ProfileModel();

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  // @override
  // void dispose() {
  //   nameComp.dispose();
  //   biin.dispose();
  //   adressComp.dispose();
  //   emailComp.dispose();
  //   base64img.dispose();
  //   base64img.dispose();
  //   pathImg.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    _isPressed = false;
    pm.setupLocale(context);
    isEmpWidget = '';

    if (widget.edit) {
      nameComp.text = widget.jdata['clientCompany']['companyName'].toString();
      biin.text = widget.jdata['clientCompany']['companyIIN'].toString();
      adressComp.text =
          widget.jdata['clientCompany']['companyAddress'].toString();
      emailComp.text = widget.jdata['clientCompany']['email'].toString();

      if (widget.jdata["clientIndivisual"]['photo'] != "") {
        base64img.text = widget.jdata['clientCompany']['photo'].toString();

        base64ToImgFile(base64img.text);
      }
    } else {
      nameComp.text = "";
      biin.text = "";
      adressComp.text = "";
      emailComp.text = "";
      base64img.text = "";
    }
    super.initState();
  }

  void _myCallback() {
    setState(() {
      _isPressed = true;
    });

    if (widget.edit) {
      if (nameComp.text.isNotEmpty &&
          biin.text.isNotEmpty &&
          adressComp.text.isNotEmpty &&
          emailComp.text.isNotEmpty) {
        RegisterDbClienComp(
          id: widget.jdata['clientCompany']['clientId'],
          img: base64img.text.length > 100 ? base64img.text : "",
          name: nameComp.text,
          iin: biin.text,
          adress: adressComp.text,
          email: emailComp.text,
          token: pm.token.toString(),
        ).register().then(
          (value) {
            print('Response: $value');

            if (value.toString() == '401') {
              final provider = SessionDataProvider();
              provider.setSessionId(null);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MainNavigationRouteNames.changeLang,
                  (Route<dynamic> route) => false);
            }

            if (value.contains('Успешная регистрация!')) {
              if (widget.swapeRole) {
                SwapeRoleSysType(
                  token: pm.token.toString(),
                  sysUserType: 2,
                  TargetSysUserType: pm.sysUserType,
                ).rolechange().then(
                  (value) {
                    print('Response: $value');

                    if (value.toString() == '401') {
                      final provider = SessionDataProvider();
                      provider.setSessionId(null);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          MainNavigationRouteNames.changeLang,
                          (Route<dynamic> route) => false);
                    }

                    if (value.contains('success')) {
                      _onBasicAlertPressedSucsess(context);
                    } else if (value
                        .contains('there are some orders are active now')) {
                      _onBasicAlertPressedUpdateNot(context);
                    }
                  },
                );
              } else {
                _onBasicAlertPressedSucsess(context);
              }
              _onBasicAlertPressedSucsess(context);
            } else {
              _onBasicAlertPressed3(context);
            }
          },
        );
        setState(() {
          isEmpWidget = '';
          _isPressed = false;
        });
      } else {
        setState(() {
          isEmpWidget = 'Не все поля заполнены';
          _isPressed = false;
        });
      }
    } else {
      if (nameComp.text.isNotEmpty &&
          biin.text.isNotEmpty &&
          adressComp.text.isNotEmpty &&
          emailComp.text.isNotEmpty) {
        RegisterDbClienComp(
          id: 0,
          img: base64img.text.length > 100 ? base64img.text : "",
          name: nameComp.text,
          iin: biin.text,
          adress: adressComp.text,
          email: emailComp.text,
          token: pm.token.toString(),
        ).register().then(
          (value) {
            print('Response: $value');

            if (value.toString() == '401') {
              final provider = SessionDataProvider();
              provider.setSessionId(null);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MainNavigationRouteNames.changeLang,
                  (Route<dynamic> route) => false);
            }

            if (value.contains('Успешная регистрация!')) {
              _onBasicAlertPressed(context);
            } else if (value.contains('уже зарегистрирован')) {
              _onBasicAlertPressed2(context);
            } else {
              _onBasicAlertPressed3(context);
            }
          },
        );
        setState(() {
          isEmpWidget = '';
          _isPressed = false;
        });
      } else {
        setState(() {
          isEmpWidget = 'Не все поля заполнены';
          _isPressed = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = pv.Provider.of<LocaleProvider>(context);

    final textStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      letterSpacing: 0.3,
      // color: AppColors.primaryColors[0],
    );

    var inputDecoration = InputDecoration(
      contentPadding: EdgeInsets.only(left: 8),
      // isDense: true,
      fillColor: provider.selectedThemeMode == ThemeMode.dark
          ? Color.fromRGBO(53, 54, 61, 1)
          : Colors.white,
      filled: true,
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(228, 232, 250, 1))),
    );
    var DropTxtStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 15,
      letterSpacing: 0.3,
      // color: AppColors.primaryColors[0],
    );

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        children: [
          // Row(),
          // // SizedBox(height: 10),
          // Text(
          //   'Заполните данные',
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 20,
          //     color: Colors.grey[700],
          //   ),
          // ),
          // SizedBox(height: 5),
          // Text(
          //   'Шаг 3',
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 20,
          //     color: Colors.grey[700],
          //   ),
          // ),
          SizedBox(height: 10),
          base64img.text.isEmpty
              ? CircleAvatar(
                  radius: 60,
                  backgroundImage: Image.asset(
                          'images/Portrait_Placeholder.png',
                          fit: BoxFit.cover)
                      .image,
                )
              : CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.deepOrange,
                  child: CircleAvatar(
                    radius: 60 - 2,
                    backgroundImage: base64img.text.length > 100
                        ? Image.memory(_image!, fit: BoxFit.cover).image
                        : Image.network(
                                "http://185.116.193.86:8081/profileimage?imagename=${base64img.text}",
                                fit: BoxFit.cover)
                            .image,
                  ),
                ),

          SizedBox(height: 4),
          ElevatedButton(
            onPressed: () {
              showAdaptiveActionSheet(
                context: context,
                actions: <BottomSheetAction>[
                  // BottomSheetAction(
                  //   title: const Text(
                  //     'Смотреть фото',
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     viewPhoto(
                  //       base64img.text,
                  //       'Изображение профиля',
                  //     );
                  //     // Navigator.pop(context);
                  //   },
                  //   // leading: const Icon(Icons.open_in_full, size: 25),
                  // ),
                  BottomSheetAction(
                    title: Text(
                      AppLocalizations.of(context)!.sdelatPhoto,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: (context) {
                      takePhoto();
                      Navigator.pop(context);
                    },
                    // leading: const Icon(Icons.circle_outlined, size: 25),
                  ),
                  BottomSheetAction(
                    title: Text(
                      AppLocalizations.of(context)!.vybratPhoto,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: (context) {
                      selectImage();
                      Navigator.pop(context);
                    },
                    // leading: const Icon(Icons.circle_outlined, size: 25),
                  ),
                ],
                cancelAction: CancelAction(
                    title: Text(
                  AppLocalizations.of(context)!.zakrit,
                  style: TextStyle(color: Colors.blueAccent),
                )),
              );
            },
            child: Text(AppLocalizations.of(context)!.zagruzitPhoto),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isEmpWidget,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 5),
                Text(AppLocalizations.of(context)!.nazvanieKom,
                    style: textStyle),
                SizedBox(height: 8),
                TextFormField(
                  controller: nameComp,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  // ],
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
                SizedBox(height: 20),
                Text(
                    '${AppLocalizations.of(context)!.biin}/${AppLocalizations.of(context)!.iin}',
                    style: textStyle),
                SizedBox(height: 8),
                TextFormField(
                  controller: biin,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                  maxLength: 12, // Limit the input to 12 digits
                  validator: (value) {
                    if (value!.isEmpty || value.length != 12) {
                      return 'Please enter 12 digits';
                    }
                    return null; // Return null if the input is valid
                  },
                ),
                SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.adres, style: textStyle),
                SizedBox(height: 8),
                TextFormField(
                  controller: adressComp,
                  keyboardType: TextInputType.streetAddress,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  // ],
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
                SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.email, style: textStyle),
                SizedBox(height: 8),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailComp,
                  textInputAction: TextInputAction.done,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  // ],
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 20)),
                  onPressed: _isPressed == false ? _myCallback : null,
                  child: _isPressed == false
                      ? Row(
                          children: [
                            Image.asset("images/11check.png",
                                width: 16, height: 16, color: Colors.white),
                            SizedBox(width: 10),
                            Text(AppLocalizations.of(context)!.sohranit),
                          ],
                        )
                      : CircularProgressIndicator(),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  void selectImage() async {
    final XFile? selected =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (selected!.path.isEmpty) {
      print(selected.path.toString());
      _imageList.add(selected);
    }
    _imageList.add(selected);
    setState(() {
      pathImg.text = selected.path;
      var formatImg = selected.name.split('.').last;

      final bytes = File(selected.path).readAsBytesSync();
      _image = bytes;

      base64img.text = "data:image/$formatImg;base64,${base64Encode(bytes)}";
    });
  }

  void takePhoto() async {
    final XFile? selected =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (selected!.path.isEmpty) {
      print(selected.path.toString());
      _imageList.add(selected);
    }
    _imageList.add(selected);
    setState(() {
      pathImg.text = selected.path;

      var formatImg = selected.name.split('.').last;

      final bytes = File(selected.path).readAsBytesSync();
      _image = bytes;

      base64img.text = "data:image/$formatImg;base64,${base64Encode(bytes)}";
    });
  }

  void viewPhoto(Object? doc, String name) {
    try {
      var replaced = doc.toString();
      dynamic contentBytes;

      var chekcer = Uri.parse(replaced);
      if (chekcer.data != null) {
        contentBytes = chekcer.data!.contentAsBytes();
      } else {
        contentBytes = base64Decode(replaced);
      }

      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImgView(
                  docName: name,
                  bytes: contentBytes,
                )),
      );
    } catch (e) {
      Navigator.pop(context);

      print('viewPhoto ===> $e');
    }
  }

  void base64ToImgFile(Object? doc) {
    try {
      var replaced = doc.toString();
      dynamic contentBytes;

      var chekcer = Uri.parse(replaced);
      if (chekcer.data != null) {
        contentBytes = chekcer.data!.contentAsBytes();
      } else {
        contentBytes = base64Decode(replaced);
      }
      _image = contentBytes;
    } catch (e) {
      print('viewPhoto ===> $e');
    }
  }

  _onBasicAlertPressedUpdateNot(context) {
    var alertStyle = AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: true,
        isOverlayTapDismiss: true,
        descStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
        animationDuration: Duration(milliseconds: 250),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(
          color: Colors.red,
        ));
    Alert(
        context: context,
        style: alertStyle,
        // title: "RFLUTTER ALERT",
        desc: AppLocalizations.of(context)!.yVasEsheEstNezZak,
        buttons: []).show();
  }
}

_onBasicAlertPressed(context) {
  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
      animationDuration: Duration(milliseconds: 250),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
      ));
  Alert(
      context: context,
      style: alertStyle,
      // title: "RFLUTTER ALERT",
      desc: AppLocalizations.of(context)!.uspeshnayaRegistr,
      buttons: [
        DialogButton(
          onPressed: () async {
            final _sessionDataProvider = SessionDataProvider();
            await _sessionDataProvider.setRoleType("2");

            Navigator.of(context).pushNamedAndRemoveUntil(
                MainNavigationRouteNames.mainScreen,
                (Route<dynamic> route) => false);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileView(),
              ),
            );
          },
          child: Text(
            AppLocalizations.of(context)!.prodolzhit,
            style: TextStyle(fontSize: 20),
          ),
        )
      ]).show();
}

_onBasicAlertPressedSucsess(context) {
  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
      animationDuration: Duration(milliseconds: 250),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
      ));
  Alert(
      context: context,
      style: alertStyle,
      // title: "RFLUTTER ALERT",
      desc: AppLocalizations.of(context)!.uspeshnoSohran,
      buttons: [
        DialogButton(
          onPressed: () async {
            final _sessionDataProvider = SessionDataProvider();
            await _sessionDataProvider.setRoleType("2");

            Navigator.of(context).pushNamedAndRemoveUntil(
                MainNavigationRouteNames.mainScreen,
                (Route<dynamic> route) => false);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileView(),
              ),
            );
          },
          child: Text(
            AppLocalizations.of(context)!.prodolzhit,
            style: TextStyle(fontSize: 20),
          ),
        )
      ]).show();
}

_onBasicAlertPressed2(context) {
  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
      animationDuration: Duration(milliseconds: 250),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
      ));
  Alert(
      context: context,
      style: alertStyle,
      // title: "RFLUTTER ALERT",
      desc: AppLocalizations.of(context)!.kompaniyaUsheZaregVSistem,
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppLocalizations.of(context)!.prodolzhit,
            style: TextStyle(fontSize: 20),
          ),
        )
      ]).show();
}

_onBasicAlertPressed3(context) {
  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
      animationDuration: Duration(milliseconds: 250),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
      ));
  Alert(
      context: context,
      style: alertStyle,
      // title: "RFLUTTER ALERT",
      desc: AppLocalizations.of(context)!.povtoritePopitku2,
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppLocalizations.of(context)!.prodolzhit,
            style: TextStyle(fontSize: 20),
          ),
        )
      ]).show();
}

class ImgView extends StatelessWidget {
  final String docName;
  final Uint8List bytes;
  const ImgView({Key? key, required this.docName, required this.bytes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          docName,
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: Image.memory(bytes, fit: BoxFit.cover).image,
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 3.5,
          initialScale: PhotoViewComputedScale.contained,
          basePosition: Alignment.center,
        ),
      ),
    );
  }
}
