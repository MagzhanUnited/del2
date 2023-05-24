import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';

class RegisterStep4DriverFizView extends StatefulWidget {
  final dynamic regData;
  final bool edit;

  RegisterStep4DriverFizView({
    Key? key,
    required this.regData,
    required this.edit,
  }) : super(key: key);

  @override
  _RegisterStep4DriverFizViewState createState() =>
      _RegisterStep4DriverFizViewState();
}

final base64img = TextEditingController(text: '');
final pathImg = TextEditingController();

final ImagePicker _imagePicker = ImagePicker();
List<XFile> _imageList = [];
// ignore: unused_element
File? _image;
String? _id;

final List<Map<String, Object>> photos = [];

class _RegisterStep4DriverFizViewState
    extends State<RegisterStep4DriverFizView> {
  @override
  Widget build(BuildContext context) {
    final pm = ProfileModel();
    pm.setupLocale(context);

    dynamic doc = [];

    if (widget.edit) {
      var baseData = widget.regData['clientIndivisual'];

      var car = baseData['car'];
      doc = car['carDocs'];
    } else {
      var baseData = widget.regData['clientIndivisual'];

      doc = baseData['docs'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Загрузите фото',
          style: TextStyle(
            // color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.black,
            ),
            onPressed: () {
              bool st = false;
              String isEmpWidget = 'done!';

              for (var item in doc) {
                if (item['image'].toString() == '') {
                  isEmpWidget = 'Выберите изображение ${item['docNameRu']}';
                  st = true;
                  break;
                }
              }

              if (st == true) {
                print(isEmpWidget);
              } else {
                print(isEmpWidget);
                print(pm.token);

                for (var item in doc) {
                  if (item['image'].toString().contains('data:image')) {
                    try {
                      var replaced = item['image'].toString();
                      dynamic contentText;

                      var chekcer = Uri.parse(replaced);
                      if (chekcer.data != null) {
                        contentText = chekcer.data!.contentText;
                      } else {
                        contentText = replaced;
                      }
                      item['image'] = contentText;
                    } catch (e) {
                      print('viewPhoto ===> $e');
                    }
                  }
                }

                RegisterDbDriverIndi(
                        docs: doc,
                        regData: widget.regData,
                        token: pm.token.toString())
                    .register()
                    .then(
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
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(
          doc.length,
          (index) {
            if (_id != null) {
              if (_id == doc[index]['docTypeId'].toString()) {
                doc[index]['image'] = base64img.text;
              }
            }

            return Center(
              child: Column(
                children: [
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      showAdaptiveActionSheet(
                        context: context,
                        actions: <BottomSheetAction>[
                          BottomSheetAction(
                            title: const Text(
                              'Смотреть фото',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: (context) {
                              viewPhoto(
                                doc[index]['image'],
                                doc[index]['docNameRu'].toString(),
                              );
                              // Navigator.of(context).pop();
                            },
                            // leading: const Icon(Icons.open_in_full, size: 25),
                          ),
                          BottomSheetAction(
                            title: const Text(
                              'Сделать снимок',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: (context) {
                              takePhoto(doc[index]['docTypeId']);
                              Navigator.of(context).pop();
                            },
                            // leading: const Icon(Icons.photo_camera, size: 25),
                          ),
                          BottomSheetAction(
                            title: const Text(
                              'Выбрать фото',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: (context) {
                              selectImage(doc[index]['docTypeId']);
                              Navigator.of(context).pop();
                            },
                            // leading: const Icon(Icons.image_sharp, size: 25),
                          ),
                        ],
                        cancelAction: CancelAction(
                          title: const Text(
                            'Закрыть',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      );
                      print(index);
                      // print(doc[index]['image'].toString().substring(0,100));
                    },
                    child:
                        // final _AnimatedMovies = photos.where((i) => i.isAnimated).toList();

                        doc[index]['image'].toString() == ''
                            ? CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.deepOrange,
                                child: CircleAvatar(
                                  radius: 40 - 2,
                                  backgroundColor: Colors.white,
                                  // backgroundImage: NetworkImage(
                                  //   'https://images-na.ssl-images-amazon.com/images/I/31CnKKUBzWL.png',
                                  // ),
                                ),
                              )
                            : CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.deepOrange,
                                child: CircleAvatar(
                                  radius: 40 - 2,
                                  backgroundColor: Colors.grey,
                                  // backgroundImage: NetworkImage(
                                  //   'https://www.pikpng.com/pngl/m/320-3203375_checked-icon-clipart.png',
                                  // ),
                                ),
                              ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    doc[index]['docNameRu'].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void selectImage(Object? doc) async {
    final XFile? selected =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (selected!.path.isEmpty) {
      print(selected.path.toString());
      _imageList.add(selected);
    }
    _imageList.add(selected);
    setState(() {
      _image = File(selected.path);

      pathImg.text = selected.path;

      final bytes = File(selected.path).readAsBytesSync();
      base64img.text = base64Encode(bytes);
      // print(base64img.text);
      _id = doc.toString();
      // ob['image'] = base64img.text;
    });
  }

  void takePhoto(Object? doc) async {
    final XFile? selected =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (selected!.path.isEmpty) {
      print(selected.path.toString());
      _imageList.add(selected);
    }
    _imageList.add(selected);
    setState(() {
      _image = File(selected.path);

      pathImg.text = selected.path;

      final bytes = File(selected.path).readAsBytesSync();
      base64img.text = base64Encode(bytes);
      _id = doc.toString();
    });
  }

  void viewPhoto(Object? doc, String name) async {
    try {
      var replaced = doc.toString();
      dynamic contentBytes;

      var chekcer = Uri.parse(replaced);
      if (chekcer.data != null) {
        contentBytes = chekcer.data!.contentAsBytes();
      } else {
        contentBytes = base64Decode(replaced);
      }

      Navigator.of(context).pop();

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImgView(
                  docName: name,
                  bytes: contentBytes,
                )),
      );
    } catch (e) {
      Navigator.of(context).pop();

      print('viewPhoto ===> $e');
    }
  }
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
      desc: "Успешно сохранено!",
      buttons: [
        DialogButton(
          onPressed: () async {
            final _sessionDataProvider = SessionDataProvider();
            await _sessionDataProvider.setRoleType('3');

            Navigator.of(context).pushReplacementNamed(
              MainNavigationRouteNames.mainScreen,
            );
          },
          child: Text(
            "Продолжить",
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
      desc: "Данный пользователь уже зарегистрирован в системе",
      buttons: [
        DialogButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Продолжить",
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
      desc: "Повторите запрос",
      buttons: [
        DialogButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Продолжить",
            style: TextStyle(fontSize: 20),
          ),
        )
      ]).show();
}
