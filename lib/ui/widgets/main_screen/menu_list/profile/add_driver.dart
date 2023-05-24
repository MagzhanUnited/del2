import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../app/my_app.dart';
import 'my_drivers.dart';
import 'profile_model.dart';

class AddDriver extends StatefulWidget {
  const AddDriver({Key? key}) : super(key: key);

  @override
  _AddDriverState createState() => _AddDriverState();
}

TextEditingController pathImg = TextEditingController();
TextEditingController base64img = TextEditingController(text: '');

final ImagePicker _imagePicker = ImagePicker();
List<XFile> _imageList = [];
// ignore: unused_element
Uint8List? _image;
String isEmpWidget = '';

TextEditingController fname = TextEditingController(text: '');
TextEditingController lname = TextEditingController(text: '');
TextEditingController pname = TextEditingController(text: '');
TextEditingController iin = TextEditingController(text: '');
TextEditingController email = TextEditingController(text: '');

final pm = ProfileModel();

class _AddDriverState extends State<AddDriver> {
  @override
  void initState() {
    isEmpWidget = '';
    fname.text = '';
    lname.text = '';
    pname.text = '';
    iin.text = '';
    email.text = '';
    base64img.text = '';
    _image = null;

    pm.setupLocale(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      letterSpacing: 0.3,
      color: AppColors.primaryColors[0],
    );

    var inputDecoration = InputDecoration(
      contentPadding: EdgeInsets.only(left: 8),
      // isDense: true,
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(228, 232, 250, 1))),
    );
    var DropTxtStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 15,
      letterSpacing: 0.3,
      color: AppColors.primaryColors[0],
    );

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              if (fname.text.isEmpty ||
                  lname.text.isEmpty ||
                  // pname.text.isEmpty ||
                  iin.text.isEmpty) {
                isEmpWidget = 'Должны быть заполнены все поля';
                print(isEmpWidget);
              } else {
                print(fname.text);
                print(lname.text);
                print(pname.text);
                print(email.text);
                print(iin.text);
                print(fname.text);

                AddCompanyDriver(
                  fName: fname.text,
                  lName: lname.text,
                  pName: pname.text,
                  email: email.text,
                  iin: iin.text,
                  token: pm.token.toString(),
                  base64Img: base64img.text.length > 100 ? base64img.text : "",
                ).Add().then(
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
              }
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.dobavitVoditel,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Center(
              //   child: _image == null
              //       ? CircleAvatar(
              //           radius: 60,
              //           backgroundImage: Image.asset(
              //                   'images/Portrait_Placeholder.png',
              //                   fit: BoxFit.cover)
              //               .image,
              //         )
              //       : CircleAvatar(
              //           radius: 60,
              //           backgroundColor: Colors.deepOrange,
              //           child: CircleAvatar(
              //             radius: 60 - 2,
              //             backgroundImage:
              //                 Image.memory(_image!, fit: BoxFit.cover).image,
              //           ),
              //         ),
              // ),
              // SizedBox(
              //   height: 4,
              // ),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       showAdaptiveActionSheet(
              //         context: context,
              //         actions: <BottomSheetAction>[
              //           // BottomSheetAction(
              //           //   title: const Text(
              //           //     'Смотреть фото',
              //           //     style: TextStyle(
              //           //       fontSize: 18,
              //           //       fontWeight: FontWeight.w500,
              //           //     ),
              //           //   ),
              //           //   onPressed: () {
              //           //     viewPhoto(
              //           //       base64img.text,
              //           //       'Изображение профиля',
              //           //     );
              //           //     // Navigator.pop(context);
              //           //   },
              //           //   // leading: const Icon(Icons.open_in_full, size: 25),
              //           // ),
              //           BottomSheetAction(
              //             title: const Text(
              //               'Сделать снимок',
              //               style: TextStyle(
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.w500,
              //               ),
              //             ),
              //             onPressed: () {
              //               takePhoto();
              //               Navigator.pop(context);
              //             },
              //             // leading: const Icon(Icons.circle_outlined, size: 25),
              //           ),
              //           BottomSheetAction(
              //             title: const Text(
              //               'Выбрать фото',
              //               style: TextStyle(
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.w500,
              //               ),
              //             ),
              //             onPressed: () {
              //               selectImage();
              //               Navigator.pop(context);
              //             },
              //             // leading: const Icon(Icons.circle_outlined, size: 25),
              //           ),
              //         ],
              //         cancelAction: CancelAction(
              //             title: const Text(
              //           'Закрыть',
              //           style: TextStyle(color: Colors.blueAccent),
              //         )),
              //       );
              //     },
              //     child: Text("Изменить"),
              //   ),
              // ),
              // SizedBox(height: 10),
              Text(
                isEmpWidget,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.red,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(AppLocalizations.of(context)!.familiya,
                    style: textStyle),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: lname,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child:
                    Text(AppLocalizations.of(context)!.imya, style: textStyle),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: fname,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(AppLocalizations.of(context)!.otchest,
                    style: textStyle),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: pname,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child:
                    Text(AppLocalizations.of(context)!.iin, style: textStyle),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: iin,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child:
                    Text(AppLocalizations.of(context)!.email, style: textStyle),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
              ),
            ],
          ),
        ),
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

      final bytes = File(selected.path).readAsBytesSync();
      _image = bytes;

      base64img.text = base64Encode(bytes);
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
      desc: AppLocalizations.of(context)!.zapisUspeshnoDobavlena,
      buttons: [
        DialogButton(
          onPressed: () async {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyDrivers()),
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
      desc: AppLocalizations.of(context)!.dannuiPolzovatelUsheVSisteme,
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
    desc: AppLocalizations.of(context)!.prodolzhit,
    // buttons: [
    //   DialogButton(
    //     onPressed: () => Navigator.pop(context),
    //     child: Text(
    //       "Продолжить",
    //       style: TextStyle(fontSize: 20),
    //     ),
    //   )
    // ]
  ).show();
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
