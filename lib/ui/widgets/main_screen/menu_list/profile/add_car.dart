import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/app/my_app.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/my_cars.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Settings_page.dart';

class AddCar extends StatefulWidget {
  final Car CarBrands;
  final String token;
  const AddCar({
    Key? key,
    required this.CarBrands,
    required this.token,
  }) : super(key: key);

  @override
  _AddCarState createState() => _AddCarState();
}

List<String> CarModels = [];
List<String> CarTypes = [];

late CarModelDetail CarModelsDet;
late CarTypeDetail CarTypeDet;

final carNum = TextEditingController(text: '');
final carType = TextEditingController(text: '');
final carWeight = TextEditingController(text: '');
final carBrand = TextEditingController(text: '');
final carModel = TextEditingController(text: '');
final carYear = TextEditingController(text: '');

class _AddCarState extends State<AddCar> {
  @override
  void initState() {
    carNum.text = '';
    carType.text = '';
    carWeight.text = '';
    carBrand.text = '';
    carModel.text = '';
    carYear.text = '';
    super.initState();
    // if (CarTypes.length == 0) {
    GetCarType(
      token: widget.token,
    ).get().then(
      (value) {
        // hideOpenDialog(context);
        // print('Response: $value');

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
    // }
  }

  @override
  Widget build(BuildContext context) {
    String isEmpWidget = '';

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
      color: AppColors.primaryColors[0],
    );

    CarBrandDropDown() {
      List<String> sugars = [];
      for (var item in widget.CarBrands.carBrands) {
        sugars.add(item.brandNameRu);
      }
      String? _currentSugars = sugars.first;

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
              style: DropTxtStyle,
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
                style: DropTxtStyle,
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
        return Text('Выберите марку авто');
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
                style: DropTxtStyle,
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

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.navigate_next,
              color: Colors.black,
            ),
            onPressed: () {
              if (carNum.text.isEmpty ||
                  carType.text.isEmpty ||
                  carWeight.text.isEmpty ||
                  carModel.text.isEmpty ||
                  carYear.text.isEmpty ||
                  carBrand.text.isEmpty) {
                isEmpWidget = 'Должны быть заполнены все поля';
                print(isEmpWidget);
              } else {
                print(carNum.text);
                print(carType.text);
                print(carWeight.text);
                print(carModel.text);
                print(carBrand.text);
                print(carYear.text);

                dynamic parameters = <String, dynamic>{
                  'carId': 0,
                  'brandId': int.parse(carBrand.text),
                  'modelId': int.parse(carModel.text),
                  'modelYear': int.parse(carYear.text),
                  'carWeight': double.parse(carWeight.text),
                  'carNumber': carNum.text,
                  'carTypeId': int.parse(carType.text),
                  'carDocs': []
                };

                AddCompanyCar(
                  token: widget.token.toString(),
                  jdata: parameters,
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

                // GetDocs(token: widget.token).getDocs().then((value) {
                //   print('Response: $value');

                //   if (value.toString() == '401') {
                //     final provider = SessionDataProvider();
                //     provider.setSessionId(null);
                //     Navigator.of(context).pushNamedAndRemoveUntil(
                //         MainNavigationRouteNames.changeLang,
                //         (Route<dynamic> route) => false);
                //   }

                //   if (value != 'error') {
                //     var docs = json.decode(value);
                //     print(parameters);
                //     parameters['carDocs'] = docs;

                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => AddCardoc(
                //                 edit: false,
                //                 regData: parameters,
                //               )),
                //     );
                //   } else {
                //     print('Не удалость получить список документов');
                //   }
                // });
              }
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.dobavitAvto,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                child: Text(AppLocalizations.of(context)!.markaAvto,
                    style: textStyle),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CarBrandDropDown(),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(AppLocalizations.of(context)!.modelAvto,
                    style: textStyle),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CarModelDropDown(),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(AppLocalizations.of(context)!.tipKuzova,
                    style: textStyle),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CarTypeDropDown(),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(AppLocalizations.of(context)!.gosNomer,
                    style: textStyle),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: carNum,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(AppLocalizations.of(context)!.gruzPodemnost,
                    style: textStyle),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: carWeight,
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
                    Text(AppLocalizations.of(context)!.god, style: textStyle),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: carYear,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: DropTxtStyle,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
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
      desc: AppLocalizations.of(context)!.zapisUspeshnoDobavlena,
      buttons: [
        DialogButton(
          onPressed: () async {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyCars()),
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
