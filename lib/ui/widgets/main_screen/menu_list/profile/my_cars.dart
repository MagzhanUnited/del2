import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/app/my_app.dart';
import '../Settings_page.dart';
import 'add_car.dart';
import 'profile_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyCars extends StatefulWidget {
  const MyCars({
    Key? key,
  }) : super(key: key);

  @override
  _MyCarsState createState() => _MyCarsState();
}

class _MyCarsState extends State<MyCars> {
  final pm = ProfileModel();
  List carList = [];
  bool load = true;

  @override
  void initState() {
    super.initState();
    pm.setupLocale(context).then(
      (value) {
        // print(pm.token);
        // print(pm.sysUserType);
        GetCarList(
          token: pm.token.toString(),
        ).getList().then(
          (value) {
            // print('Response: $value');

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
                carList = docs;
                load = false;
              });
            } else {
              print('Не удалось получить список водителей');
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              showLoadingIndicator(context);
              GetCarBrands(
                token: pm.token.toString(),
              ).get().then((value) {
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

                  final CarBrands = Car.fromJson(parsedJson);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCar(
                        CarBrands: CarBrands,
                        token: pm.token,
                      ),
                    ),
                  );
                }
              });
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.moiVoditeli,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: load ? LoadingData() : myCarData(context),
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
                      fontWeight: FontWeight.bold, color: Colors.black54),
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

  Center myCarData(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: ListView(
          children: new List.generate(carList.length, (index) {
            return cardVal(
              '${carList[index]['brandNameRu']} ${carList[index]['modelNameRu']} (${carList[index]['carNumber']})',
              '${carList[index]['modelYear']}, ${carList[index]['carTypeNameRu']}',
              Icon(Icons.person),
              context,
              MyCars(),
            );
          }),
        ),
      ),
    );
  }

  Card cardVal(String titleName, subtitle, Icon iconVal, context, pageName) {
    return Card(
      color: Colors.white,
      child: ListTile(
        // leading: iconVal,
        title: Text(
          titleName,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
        leading: Image.asset('images/mycars.png', height: 35),
        trailing: Icon(
          Icons.arrow_forward,
          color: AppColors.primaryColors[0],
        ),
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => pageName),
          // );
        },
      ),
    );
  }
}

class Car {
  List<CarBrands> carBrands;
  Null carModels;
  Null carTypes;

  Car({
    required this.carBrands,
    this.carModels,
    this.carTypes,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    final carBrands = <CarBrands>[];
    if (json['carBrands'] != null) {
      json['carBrands'].forEach((v) {
        carBrands.add(new CarBrands.fromJson(v));
      });
    }
    final carModels = json['carModels'];
    final carTypes = json['carTypes'];
    return Car(
      carBrands: carBrands,
      carModels: carModels,
      carTypes: carTypes,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['carBrands'] = this.carBrands.map((v) => v.toJson()).toList();
    data['carModels'] = this.carModels;
    data['carTypes'] = this.carTypes;
    return data;
  }
}

class CarBrands {
  int brandId;
  String brandNameKz;
  String brandNameRu;
  String brandNameEn;

  CarBrands({
    required this.brandId,
    required this.brandNameKz,
    required this.brandNameRu,
    required this.brandNameEn,
  });

  factory CarBrands.fromJson(Map<String, dynamic> json) {
    final brandId = json['brandId'];
    final brandNameKz = json['brandNameKz']!;
    final brandNameRu = json['brandNameRu']!;
    final brandNameEn = json['brandNameEn']!;
    return CarBrands(
        brandId: brandId,
        brandNameKz: brandNameKz,
        brandNameRu: brandNameRu,
        brandNameEn: brandNameEn);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandId'] = this.brandId;
    data['brandNameKz'] = this.brandNameKz;
    data['brandNameRu'] = this.brandNameRu;
    data['brandNameEn'] = this.brandNameEn;
    return data;
  }
}

class CarModelDetail {
  Null carBrands;
  List<CarModels>? carModels;
  Null carTypes;

  CarModelDetail({
    required this.carBrands,
    required this.carModels,
    required this.carTypes,
  });

  factory CarModelDetail.fromJson(Map<String, dynamic> json) {
    final carBrands = json['carBrands'];
    final carModels = <CarModels>[];
    if (json['carModels'] != null) {
      json['carModels'].forEach((v) {
        carModels.add(new CarModels.fromJson(v));
      });
    }
    final carTypes = json['carTypes'];
    return CarModelDetail(
      carBrands: carBrands,
      carModels: carModels,
      carTypes: carTypes,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['carBrands'] = this.carBrands;
    if (this.carModels != null) {
      data['carModels'] = this.carModels!.map((v) => v.toJson()).toList();
    }
    data['carTypes'] = this.carTypes;
    return data;
  }
}

class CarModels {
  int modelId;
  String modelNameKz;
  String modelNameRu;
  String modelNameEn;
  List<CarTypes> carTypes;

  CarModels(
      {required this.modelId,
      required this.modelNameKz,
      required this.modelNameRu,
      required this.modelNameEn,
      required this.carTypes});

  factory CarModels.fromJson(Map<String, dynamic> json) {
    final modelId = json['modelId'];
    final modelNameKz = json['modelNameKz']!;
    final modelNameRu = json['modelNameRu']!;
    final modelNameEn = json['modelNameEn']!;

    final carTypes = <CarTypes>[];
    if (json['carTypes'] != null) {
      json['carTypes'].forEach((v) {
        carTypes.add(new CarTypes.fromJson(v));
      });
    }
    return CarModels(
      modelId: modelId,
      modelNameKz: modelNameKz,
      modelNameRu: modelNameRu,
      modelNameEn: modelNameEn,
      carTypes: carTypes,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modelId'] = this.modelId;
    data['modelNameKz'] = this.modelNameKz;
    data['modelNameRu'] = this.modelNameRu;
    data['modelNameEn'] = this.modelNameEn;
    data['carTypes'] = this.carTypes.map((v) => v.toJson()).toList();
    return data;
  }
}

class CarTypes {
  int carTypeId;
  String nameKz;
  String nameRu;
  String nameEn;

  CarTypes({
    required this.carTypeId,
    required this.nameKz,
    required this.nameRu,
    required this.nameEn,
  });

  factory CarTypes.fromJson(Map<String, dynamic> json) {
    final carTypeId = json['carTypeId'];
    final nameKz = json['nameKz']!;
    final nameRu = json['nameRu']!;
    final nameEn = json['nameEn']!;
    return CarTypes(
      carTypeId: carTypeId,
      nameKz: nameKz,
      nameRu: nameRu,
      nameEn: nameEn,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['carTypeId'] = this.carTypeId;
    data['nameKz'] = this.nameKz;
    data['nameRu'] = this.nameRu;
    data['nameEn'] = this.nameEn;
    return data;
  }
}

class CarTypeDetail {
  Null carBrands;
  Null carModels;
  List<CarTypes> carTypes;

  CarTypeDetail({
    required this.carBrands,
    required this.carModels,
    required this.carTypes,
  });

  factory CarTypeDetail.fromJson(Map<String, dynamic> json) {
    final carBrands = json['carBrands'];
    final carModels = json['carModels'];
    final carTypes = <CarTypes>[];
    if (json['carTypes'] != null) {
      json['carTypes'].forEach((v) {
        carTypes.add(new CarTypes.fromJson(v));
      });
    }
    return CarTypeDetail(
      carBrands: carBrands,
      carModels: carModels,
      carTypes: carTypes,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['carBrands'] = this.carBrands;
    data['carModels'] = this.carModels;
    data['carTypes'] = this.carTypes.map((v) => v.toJson()).toList();
    return data;
  }
}
