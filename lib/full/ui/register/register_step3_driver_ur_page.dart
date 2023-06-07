import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';

import '../../../ui/widgets/main_screen/menu_list/profile/profile_page.dart';

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class RegisterStep3DriverUrView extends StatefulWidget {
  final bool edit;
  final dynamic jdata;
  final bool swapeRole;

  RegisterStep3DriverUrView({
    Key? key,
    required this.edit,
    required this.swapeRole,
    required this.jdata,
  }) : super(key: key);

  @override
  _RegisterStep3DriverUrViewState createState() =>
      _RegisterStep3DriverUrViewState();
}

class _RegisterStep3DriverUrViewState extends State<RegisterStep3DriverUrView> {
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
  const MyStatefulWidget({
    Key? key,
    required this.edit,
    required this.swapeRole,
    required this.jdata,
  }) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

String isEmpWidget = '';
bool _isPressed = false;

var companiName = TextEditingController();
var bin = TextEditingController();
var adress = TextEditingController();
var eMail = TextEditingController();
var token = TextEditingController();
var base64img = TextEditingController(text: '');
var pathImg = TextEditingController();

final ImagePicker _imagePicker = ImagePicker();
List<XFile> _imageList = [];
Uint8List? _image;

final pm = ProfileModel();

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  void initState() {
    _isPressed = false;
    isEmpWidget = '';
    pm.setupLocale(context);
    if (widget.edit) {
      var data = widget.jdata['clientCompany'];

      companiName.text = data['companyName'].toString();
      bin.text = data['companyIIN'].toString();
      adress.text = data['companyAddress'].toString();
      eMail.text = data['email'].toString();
      if (data['photo'] != "") {
        base64img.text = data['photo'].toString();

        base64ToImgFile(base64img.text);
      }
    } else {
      companiName.text = '';
      bin.text = '';
      adress.text = '';
      eMail.text = '';
      base64img.text = '';
    }
    super.initState();
  }

  void _myCallback() {
    setState(() {
      _isPressed = true;
    });

    final cn = companiName.text;
    final binX = bin.text;
    final adr = adress.text;
    final em = eMail.text;
    if (cn.isEmpty || binX.isEmpty || adr.isEmpty || em.isEmpty) {
      setState(() {
        isEmpWidget = 'Должны быть заполнены все поля';
        _isPressed = false;
      });
    } else if (em.isNotEmpty && !em.contains("@")) {
      setState(() {
        isEmpWidget = 'не правильный email';
        _isPressed = false;
      });
    } else if (binX.isNotEmpty && binX.length <= 11) {
      setState(() {
        isEmpWidget = 'не правильный БИН/ИИН';
        _isPressed = false;
      });
    } else {
      print(pm.token);
      print(companiName.text);
      print(bin.text);
      print(adress.text);
      print(eMail.text);

      if (widget.edit) {
        widget.jdata['clientCompany']['photo'] =
            base64img.text.length > 100 ? base64img.text : "";
        widget.jdata['clientIndivisual']['photo'] =
            base64img.text.length > 100 ? base64img.text : "";
        widget.jdata['clientCompany']['companyName'] = companiName.text;
        widget.jdata['clientCompany']['companyIIN'] = bin.text;
        widget.jdata['clientCompany']['companyAddress'] = adress.text;
        widget.jdata['clientCompany']['companyAddressru'] = adress.text;
        widget.jdata['clientCompany']['companyAddressen'] = adress.text;
        widget.jdata['clientCompany']['email'] = eMail.text;

        RegisterDbDriverComp(
          name: companiName.text,
          iin: bin.text,
          adress: adress.text,
          email: eMail.text,
          token: pm.token.toString(),
          base64: base64img.text.length > 100 ? base64img.text : "",
          jdata: widget.jdata,
        ).update().then(
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
                  sysUserType: 4,
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
                      _onBasicAlertPressedUpd(context);
                    } else if (value
                        .contains('there are some orders are active now')) {
                      _onBasicAlertPressedUpdateNot(context);
                    }
                  },
                );
              } else {
                _onBasicAlertPressedUpd(context);
              }
            } else if (value.contains('уже зарегистрирован')) {
              _onBasicAlertPressed2(context);
            } else {
              _onBasicAlertPressed3(context);
            }

            setState(() {
              _isPressed = false;
              isEmpWidget = isEmpWidget;
            });
          },
        );
      } else {
        RegisterDbDriverComp(
          name: companiName.text,
          iin: bin.text,
          adress: adress.text,
          email: eMail.text,
          token: pm.token.toString(),
          base64: base64img.text.length > 100 ? base64img.text : "",
          jdata: null,
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

            setState(() {
              _isPressed = false;
              isEmpWidget = isEmpWidget;
            });
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

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
          // Text(
          //   'Заполните данные',
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 20,
          //     color: Colors.grey[700],
          //   ),
          // ),
          SizedBox(height: 24),

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
                  // backgroundColor: Colors.deepOrange,
                  child: CircleAvatar(
                    radius: 60 - 1,
                    backgroundImage: base64img.text.length > 100
                        ? Image.memory(_image!, fit: BoxFit.cover).image
                        : Image.network(
                                "http://185.116.193.86:8081/profileimage?imagename=${base64img.text}",
                                fit: BoxFit.cover)
                            .image,
                  ),
                ),

          SizedBox(
            height: 4,
          ),

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
                  //       'base64img.text',
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
          SizedBox(height: 10),
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
                SizedBox(height: 10),
                Text(AppLocalizations.of(context)!.nazvanieKom,
                    style: textStyle),
                SizedBox(height: 8),
                TextFormField(
                  controller: companiName,
                  keyboardType: TextInputType.name,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                  controller: bin,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(12)
                  ],
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                  maxLength: 12, // Limit the input to 12 digits
                  validator: (value) {
                    if (value!.isEmpty || value.length != 12) {
                      return 'Введите 12 цифр';
                    }
                    return null; // Возвращаем null, если ввод корректен
                  },
                ),
                SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.adres, style: textStyle),
                SizedBox(height: 8),
                TextFormField(
                  controller: adress,
                  keyboardType: TextInputType.streetAddress,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  // ],
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
                SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.email, style: textStyle),
                SizedBox(height: 8),
                TextFormField(
                  controller: eMail,
                  keyboardType: TextInputType.text,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  // ],
                  textInputAction: TextInputAction.done,
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
      desc: AppLocalizations.of(context)!.uspeshnoSohran,
      buttons: [
        DialogButton(
          onPressed: () async {
            final _sessionDataProvider = SessionDataProvider();
            await _sessionDataProvider.setRoleType("4");

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
            style: TextStyle(fontSize: 13),
          ),
        )
      ]).show();
}

_onBasicAlertPressedUpd(context) {
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
            await _sessionDataProvider.setRoleType("4");

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
            style: TextStyle(fontSize: 13),
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
