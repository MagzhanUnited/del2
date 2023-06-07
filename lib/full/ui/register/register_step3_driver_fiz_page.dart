import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/register_step4_driver_fiz_page.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/Settings_page.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/my_cars.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';

class RegisterStep3DriverFizView extends StatefulWidget {
  final Car CarBrands;
  final String token;
  final bool edit;
  final bool swapeRole;
  final dynamic jdata;
  RegisterStep3DriverFizView({
    Key? key,
    required this.CarBrands,
    required this.token,
    required this.edit,
    required this.swapeRole,
    required this.jdata,
  }) : super(key: key);

  @override
  _RegisterStep3DriverFizViewState createState() =>
      _RegisterStep3DriverFizViewState();
}

bool _isPressed = false;
String validationMessage = "";
String validationMessageIIN = "";

class _RegisterStep3DriverFizViewState
    extends State<RegisterStep3DriverFizView> {
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
          CarBrands: widget.CarBrands,
          token: widget.token,
          edit: widget.edit,
          swapeRole: widget.swapeRole,
          jdata: widget.jdata,
        ),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
// ignore: must_be_immutable
class MyStatefulWidget extends StatefulWidget {
  final Car CarBrands;
  final String token;
  final bool edit;
  final bool swapeRole;
  dynamic jdata;
  MyStatefulWidget({
    Key? key,
    required this.CarBrands,
    required this.token,
    required this.edit,
    required this.swapeRole,
    required this.jdata,
  }) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

String isEmpWidget = '';

final fName = TextEditingController();
final lName = TextEditingController();
final pName = TextEditingController();
final iin = TextEditingController();
final eMail = TextEditingController();
final carNum = TextEditingController();
final carType = TextEditingController();
final carWeigth = TextEditingController();
final carBrand = TextEditingController();
final carModel = TextEditingController();
final carYear = TextEditingController();

final token = TextEditingController();
final base64img = TextEditingController(text: '');
final pathImg = TextEditingController();

final ImagePicker _imagePicker = ImagePicker();
List<XFile> _imageList = [];
Uint8List? _image;

List<String> CarModels = [];
List<String> CarTypes = [];

late CarModelDetail CarModelsDet;
late CarTypeDetail CarTypeDet;

final pm = ProfileModel();

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  void initState() {
    pm.setupLocale(context);
    _isPressed = false;
    isEmpWidget = '';

    super.initState();

    if (widget.edit == false) {
      fName.text = '';
      lName.text = '';
      pName.text = '';
      iin.text = '';
      eMail.text = '';
      carNum.text = '';
      carType.text = '';
      carWeigth.text = '';
      carBrand.text = '';
      carModel.text = '';
      carYear.text = '';

      token.text = '';
      base64img.text = '';
      pathImg.text = '';
      _image = null;
    }

    if (widget.edit) {
      var baseData = widget.jdata['clientIndivisual'];
      var carData = baseData['car'];

      // Map<String,Object> baseData = jsonMap["clientIndivisual"] as Map<String,Object>;
      // Map<String,Object> carData = baseData["car"] as Map<String,Object>;

      fName.text = baseData['firstName'].toString();
      lName.text = baseData['lastName'].toString();
      pName.text = baseData['thirdName'].toString();
      iin.text = baseData['iin'].toString();
      eMail.text = baseData['email'].toString();

      carNum.text = carData['carNumber'].toString();
      carType.text = carData['carTypeId'].toString();
      carWeigth.text = carData['carWeight'].toString();
      carBrand.text = carData['brandId'].toString();
      carModel.text = carData['modelId'].toString();
      carYear.text = carData['modelYear'].toString();

      if (baseData['photo'] != "") {
        base64img.text = baseData['photo'].toString();

        base64ToImgFile(base64img.text);
      }
    }

    // if (CarTypes.length == 0) {
    GetCarType(
      token: widget.token,
    ).get().then(
      (value) {
        // hideOpenDialog(context);
        print('Response: $value');

        if (value.toString() == '401') {
          final provider = SessionDataProvider();
          provider.setSessionId(null);
          Navigator.of(context).pushNamedAndRemoveUntil(
              MainNavigationRouteNames.changeLang,
              (Route<dynamic> route) => false);
        }

        if (value.contains('Error')) {
          showErrorIndicator(context);
        } else {
          final parsedJson = jsonDecode(value);
          CarTypeDet = CarTypeDetail.fromJson(parsedJson);
          List<String> aaa = [];
          for (var item in CarTypeDet.carTypes) {
            aaa.add(item.nameRu);
          }

          setState(() {
            CarTypes = aaa;
          });
        }
      },
    );

    // GetCarModels(
    //   token: widget.token,
    //   brandId: widget.CarBrands.carBrands.first.brandId,
    // ).get().then(
    //   (value) {
    //     print('Response: $value');

    //     if (value.toString() == '401') {
    //       final provider = SessionDataProvider();
    //       provider.setSessionId(null);
    //       Navigator.of(context).pushNamedAndRemoveUntil(
    //           MainNavigationRouteNames.changeLang,
    //           (Route<dynamic> route) => false);
    //     }

    //     if (value.contains('Error')) {
    //       showErrorIndicator(context);
    //     } else {
    //       final parsedJson = jsonDecode(value);
    //       CarModelsDet = CarModelDetail.fromJson(parsedJson);
    //       List<String> aaa = [];
    //       for (var item in CarModelsDet.carModels!) {
    //         aaa.add(item.modelNameRu);
    //       }
    //       setState(() {
    //         CarModels = aaa;
    //       });
    //     }
    //   },
    // );
  }

  bool _validatePlateNumber(String plateNumber) {
    // Pattern 1: 111aa01
    RegExp pattern1 = RegExp(r'^\d{3}[A-Za-z]{2}\d{2}$');

    // Pattern 2: 111aaa01
    RegExp pattern2 = RegExp(r'^\d{3}[A-Za-z]{3}\d{2}$');

    // Pattern 3: 01aa02
    RegExp pattern3 = RegExp(r'^\d{2}[A-Za-z]{2}\d{2}$');

    if (pattern1.hasMatch(plateNumber) ||
        pattern2.hasMatch(plateNumber) ||
        pattern3.hasMatch(plateNumber)) {
      return true;
    }

    return false;
  }

  bool validateIIN(String iin) {
    if (iin.length != 12) {
      return false;
    }

    List<int> weights = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
    int sum = 0;

    for (int i = 0; i < 11; i++) {
      sum += int.parse(iin[i]) * weights[i];
    }

    int remainder = sum % 11;
    int controlDigit = int.parse(iin[11]);

    if (remainder == 10 && controlDigit == 0) {
      return true;
    } else if (remainder == controlDigit) {
      return true;
    }

    return false;
  }

  void _myCallback() {
    String plateNumber = carNum.text;
    bool isValid = _validatePlateNumber(plateNumber);
    validationMessage = isValid ? '' : 'Неверный номерной знак';
    setState(() {});
    if (!isValid) {
      return;
    }

    // String num = iin.text;
    // bool isValidIIN = validateIIN(num);
    // validationMessageIIN = isValidIIN ? '' : 'Неверный ИИН';
    // setState(() {});
    // if (!isValidIIN) {
    //   return;
    // }

    String value = iin.text;
    if (value.isEmpty) {
      setState(() {
        validationMessageIIN = 'Введите ИИН';
      });
      return;
    } else if (value.length != 12) {
      setState(() {
        validationMessageIIN = 'ИИН должен содержать 12 цифр';
      });
      return;
    }
    // else {
    //   // Выполните проверку ФЛК на ИИН
    //   int sum = 0;
    //   for (int i = 0; i < 11; i++) {
    //     sum += int.parse(value[i]) * (i + 1);
    //   }
    //   int controlNumber = (sum % 11);
    //   if (controlNumber != int.parse(value[11])) {
    //     setState(() {
    //       validationMessageIIN = 'Неверный ИИН';
    //     });
    //     return;
    //   }
    // }

    _isPressed = true;
    setState(() {});

    dynamic baseData;

    if (widget.edit) {
      if (fName.text.isNotEmpty &&
          lName.text.isNotEmpty &&
          iin.text.isNotEmpty &&
          eMail.text.isNotEmpty) {
        baseData = widget.jdata['clientIndivisual'];

        baseData['photo'] = base64img.text.length > 100 ? base64img.text : "";
        baseData['firstName'] = fName.text;
        baseData['lastName'] = lName.text;
        baseData['thirdName'] = pName.text;
        baseData['iin'] = iin.text;
        baseData['email'] = eMail.text;

        baseData['car']['carNumber'] = carNum.text;
        baseData['car']['carTypeId'] = int.parse(carType.text);
        baseData['car']['carWeight'] = double.parse(carWeigth.text);
        baseData['car']['brandId'] = int.parse(carBrand.text);
        baseData['car']['modelId'] = int.parse(carModel.text);
        baseData['car']['modelYear'] = int.parse(carYear.text);

        widget.jdata['clientIndivisual'] = baseData;

        RegisterDbDriverIndi(
          docs: [],
          regData: baseData,
          token: pm.token.toString(),
        ).register().then(
          (value) {
            if (value.toString() == '401') {
              final provider = SessionDataProvider();
              provider.setSessionId(null);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MainNavigationRouteNames.changeLang,
                  (Route<dynamic> route) => false);
            }

            if (value.contains('Успешная регистрация!') ||
                value.contains('Error the car must have its documents')) {
              if (widget.swapeRole) {
                SwapeRoleSysType(
                  token: pm.token.toString(),
                  sysUserType: 3,
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
                      final _sessionDataProvider = SessionDataProvider();
                      _sessionDataProvider.setRoleType("3");

                      Navigator.of(context).pushNamedAndRemoveUntil(
                          MainNavigationRouteNames.mainScreen,
                          (Route<dynamic> route) => false);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileView(),
                        ),
                      );
                    } else if (value
                        .contains('there are some orders are active now')) {
                      _onBasicAlertPressedUpdateNot(context);
                      setState(() {
                        _isPressed = false;
                      });
                    }
                  },
                );
              } else {
                _onBasicAlertPressedSucsess(context);
                setState(() {
                  _isPressed = false;
                });
              }
            } else if (value.contains('уже зарегистрирован')) {
              _onBasicAlertPressed2(context);
              setState(() {
                _isPressed = false;
              });
            } else {
              _onBasicAlertPressed3(context);
              setState(() {
                _isPressed = false;
              });
            }
          },
        );
      } else {
        setState(() {
          isEmpWidget = 'Не все поля заполнены';
          _isPressed = false;
        });
      }
    } else {
      if (fName.text.isNotEmpty &&
          lName.text.isNotEmpty &&
          iin.text.isNotEmpty &&
          eMail.text.isNotEmpty) {
        dynamic docs = [];
        GetDocs(token: widget.token).getDocs().then(
          (value) {
            print('Response: $value');

            if (value.toString() == '401') {
              final provider = SessionDataProvider();
              provider.setSessionId(null);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MainNavigationRouteNames.changeLang,
                  (Route<dynamic> route) => false);
            }

            if (value != 'error') {
              docs = json.decode(value);

              var res = {
                "clientIndivisual": {
                  "clientId": 0,
                  "photo": "",
                  "firstName": "",
                  "lastName": "",
                  "thirdName": "",
                  "email": "",
                  "iin": "",
                  "docs": docs,
                  "orgId": 0,
                  "car": {
                    "carId": 0,
                    "carWeight": 0,
                    "modelYear": 0,
                    "brandId": 1,
                    "modelId": 1,
                    "userId": 0,
                    "carNumber": "",
                    "carTypeId": 1,
                    "carDocs": []
                  }
                },
                "guestId": 0,
                "sysUserType": 3
              };

              baseData = res['clientIndivisual'];

              baseData['photo'] =
                  base64img.text.length > 100 ? base64img.text : "";

              baseData['firstName'] = fName.text;
              baseData['lastName'] = lName.text;
              baseData['thirdName'] = pName.text;
              baseData['iin'] = iin.text;
              baseData['email'] = eMail.text;

              baseData['car']['carNumber'] = carNum.text;
              baseData['car']['carTypeId'] = int.parse(carType.text);
              baseData['car']['carWeight'] = double.parse(carWeigth.text);
              baseData['car']['brandId'] = int.parse(carBrand.text);
              baseData['car']['modelId'] = int.parse(carModel.text);
              baseData['car']['modelYear'] = int.parse(carYear.text);

              // widget.jdata = [];
              res['clientIndivisual'] = baseData;

              widget.jdata = res;

              dynamic doc = [];

              showLoadingIndicator(context);

              RegisterDbDriverIndi(
                      docs: doc, regData: baseData, token: pm.token.toString())
                  .register()
                  .then(
                (value) {
                  hideOpenDialog(context);

                  print('Response: $value');

                  if (value.toString() == '401') {
                    final provider = SessionDataProvider();
                    provider.setSessionId(null);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        MainNavigationRouteNames.changeLang,
                        (Route<dynamic> route) => false);
                  }

                  if (value.contains('Успешная регистрация!')) {
                    _onBasicAlertPressedSucsess(context);
                  } else if (value.contains('уже зарегистрирован')) {
                    _onBasicAlertPressed2(context);
                  } else {
                    _onBasicAlertPressed3(context);
                  }
                },
              );
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
    // final textStyle = const TextStyle(
    //   fontWeight: FontWeight.bold,
    //   fontSize: 14,
    //   color: Colors.blueGrey,
    // );

    final provider = Provider.of<LocaleProvider>(context);

    var row = Row(
      children: [
        Image.asset("images/Vector30.png", height: 8),
        SizedBox(width: 10),
      ],
    );

    var DropTxtStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 15,
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

    CarBrandDropDown() {
      List<String> sugars = [];
      for (var item in widget.CarBrands.carBrands) {
        sugars.add(item.brandNameRu);
      }

      // var id = widget.CarBrands.carBrands
      //     .where((e) => e.brandId == int.parse(carBrand.text));

      String? _currentSugars =
          widget.CarBrands.carBrands.last.brandNameRu.toString();
      return DropdownButtonFormField<String>(
        icon: row,
        decoration: inputDecoration,
        isExpanded: true,
        value: _currentSugars,
        items: sugars.map((sugar) {
          return DropdownMenuItem(
            value: sugar,
            child: Text(
              '$sugar',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: provider.selectedThemeMode != ThemeMode.dark
                    ? Color.fromRGBO(53, 54, 61, 1)
                    : Colors.white,
              ),
            ),
          );
        }).toList(),
        onChanged: (val) => setState(
          () {
            _currentSugars = val;

            var id =
                widget.CarBrands.carBrands.where((e) => e.brandNameRu == val);
            carBrand.text = id.last.brandId.toString();

            showLoadingIndicator(context);
            GetCarModels(
              token: widget.token,
              brandId: int.parse(carBrand.text),
            ).get().then(
              (value) {
                hideOpenDialog(context);
                print('Response: $value');

                if (value.toString() == '401') {
                  final provider = SessionDataProvider();
                  provider.setSessionId(null);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      MainNavigationRouteNames.changeLang,
                      (Route<dynamic> route) => false);
                }

                if (value.contains('Error')) {
                  showErrorIndicator(context);
                } else {
                  final parsedJson = jsonDecode(value);
                  CarModelsDet = CarModelDetail.fromJson(parsedJson);
                  List<String> aaa = [];
                  for (var item in CarModelsDet.carModels!) {
                    aaa.add(item.modelNameRu);
                  }
                  setState(() {
                    CarModels = aaa;
                  });
                }
              },
            );
          },
        ),
      );
    }

    CarModelDropDown() {
      if (CarModels.any((element) => true)) {
        String? _currentSugars = CarModels.first;
        return DropdownButtonFormField<String>(
          icon: row,
          decoration: inputDecoration,
          isExpanded: true,
          value: _currentSugars,
          items: CarModels.map((sugar) {
            return DropdownMenuItem(
              value: sugar,
              child: Text(
                '$sugar',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: provider.selectedThemeMode != ThemeMode.dark
                      ? Color.fromRGBO(53, 54, 61, 1)
                      : Colors.white,
                ),
              ),
            );
          }).toList(),
          onChanged: (val) => setState(() {
            _currentSugars = val;
            print(_currentSugars);
            print(CarModels.indexOf(_currentSugars.toString()));
            var id = CarModelsDet.carModels!
                .where((element) => element.modelNameRu == val);
            carModel.text = id.last.modelId.toString();
          }),
        );
      } else {
        try {
          GetCarModels(
            token: widget.token,
            brandId: int.parse(carBrand.text),
          ).get().then(
            (value) {
              if (value.toString() == '401') {
                final provider = SessionDataProvider();
                provider.setSessionId(null);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    MainNavigationRouteNames.changeLang,
                    (Route<dynamic> route) => false);
              }

              if (value.contains('Error')) {
                showErrorIndicator(context);
              } else {
                final parsedJson = jsonDecode(value);
                CarModelsDet = CarModelDetail.fromJson(parsedJson);
                List<String> aaa = [];
                for (var item in CarModelsDet.carModels!) {
                  aaa.add(item.modelNameRu);
                }
                setState(() {
                  CarModels = aaa;
                });
              }
            },
          );
        } catch (e) {
          print(e);
        }
        return Text("");
      }
    }

    CarTypeDropDown() {
      if (CarTypes.any((element) => true)) {
        String? _currentSugars = CarTypes.first;
        return DropdownButtonFormField<String>(
          icon: row,
          decoration: inputDecoration,
          isExpanded: true,
          value: _currentSugars,
          items: CarTypes.map((sugar) {
            return DropdownMenuItem(
              value: sugar,
              child: Text(
                '$sugar',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: provider.selectedThemeMode != ThemeMode.dark
                      ? Color.fromRGBO(53, 54, 61, 1)
                      : Colors.white,
                ),
              ),
            );
          }).toList(),
          onChanged: (val) => setState(() {
            _currentSugars = val;
            print(_currentSugars);
            print(CarTypes.indexOf(_currentSugars.toString()));

            var id =
                CarTypeDet.carTypes.where((element) => element.nameRu == val);

            carType.text = (id.last.carTypeId).toString();
          }),
        );
      } else {
        return Text('Не удалось загрузить тип кузова');
      }
    }

    final textStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
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
                  //     // Navigator.of(context).pop();
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
                      Navigator.of(context).pop();
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
                      Navigator.of(context).pop();
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
                SizedBox(height: 5),
                Text(AppLocalizations.of(context)!.familiya, style: textStyle),
                SizedBox(height: 8),
                TextFormField(
                  controller: lName,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
                SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.imya, style: textStyle),
                SizedBox(height: 8),
                TextFormField(
                  controller: fName,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
                SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.otchest, style: textStyle),
                SizedBox(height: 8),
                TextFormField(
                  controller: pName,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
                SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.iin, style: textStyle),
                SizedBox(height: 8),
                TextFormField(
                  controller: iin,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(12),
                  ],
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                  maxLength: 12,
                  onChanged: (value) {
                    setState(() {
                      validationMessageIIN = "";
                    });
                  },
                ),
                Text(validationMessageIIN, style: TextStyle(color: Colors.red)),
                SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.email, style: textStyle),
                SizedBox(height: 8),
                TextFormField(
                  controller: eMail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
                SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.gosNomer, style: textStyle),
                SizedBox(height: 8),
                TextFormField(
                  controller: carNum,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
                Text(validationMessage, style: TextStyle(color: Colors.red)),
                SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.gruzPodemnost,
                    style: textStyle),
                SizedBox(height: 8),
                TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(3)
                  ],
                  textInputAction: TextInputAction.next,
                  controller: carWeigth,
                  keyboardType: TextInputType.number,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
                SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.godAvto, style: textStyle),
                SizedBox(height: 8),
                TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(4)
                  ],
                  textInputAction: TextInputAction.next,
                  controller: carYear,
                  keyboardType: TextInputType.number,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
                SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.markaAvto, style: textStyle),
                SizedBox(height: 8),
                CarBrandDropDown(),
                SizedBox(height: 20),
                carBrand.text == ""
                    ? SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)!.modelAvto,
                              style: textStyle),
                          SizedBox(height: 8),
                          CarModelDropDown(),
                        ],
                      ),
                SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.tipKuzova, style: textStyle),
                SizedBox(height: 8),
                CarTypeDropDown(),
                SizedBox(height: 20),
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

          SizedBox(height: 25),
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
      debugPrint(base64img.text.substring(0, 100));
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

  _onBasicAlertPressedSucsess(context) {
    var alertStyle = AlertStyle(
        buttonAreaPadding: EdgeInsets.all(10),
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
              await _sessionDataProvider.setRoleType("3");

              Navigator.of(context).pushNamedAndRemoveUntil(
                MainNavigationRouteNames.mainScreen,
                (Route<dynamic> route) => false,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileView(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                color: Colors.black, // Задний фон черный
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    AppLocalizations.of(context)!.prodolzhit,
                    style: TextStyle(
                        fontSize: 20, color: Colors.white), // Текст белый
                  ),
                ),
              ),
            ),
          ),
        ]).show();
  }
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
          onPressed: () => Navigator.of(context).pop(),
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
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.of(context)!.prodolzhit,
            style: TextStyle(fontSize: 20),
          ),
        )
      ]).show();
}
