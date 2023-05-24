import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/add_driver.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/my_cars.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../app/my_app.dart';
import 'profile_model.dart';

class MyDrivers extends StatefulWidget {
  MyDrivers({Key? key}) : super(key: key);

  @override
  _MyDriversState createState() => _MyDriversState();
}

class _MyDriversState extends State<MyDrivers> {
  List driverList = [];
  bool load = true;

  @override
  void initState() {
    super.initState();

    final pm = ProfileModel();
    pm.setupLocale(context).then(
      (value) {
        // print(pm.token);
        // print(pm.sysUserType);
        GetDriverList(
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
                driverList = docs;
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDriver()),
              );
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
      body: load ? LoadingData() : MyDriverData(context),
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

  Center MyDriverData(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: ListView(
          children: new List.generate(driverList.length, (index) {
            return cardVal(
              '${driverList[index]['firstName']} ${driverList[index]['lastName']}',
              '${AppLocalizations.of(context)!.iin}: ${driverList[index]['iin']}',
              'Code: ${driverList[index]['driverCode']}',
              '${driverList[index]['photo']}',
              context,
              MyCars(),
            );
          }),
        ),
      ),
    );
  }

  Card cardVal(String titleName, String subtitle1, String subtitle2, img,
      context, pageName) {
    var image = CircleAvatar(
        backgroundImage:
            Image.asset('images/Portrait_Placeholder.png', fit: BoxFit.cover)
                .image);
    if (img.toString().length > 100) {
      Uint8List? _image;
      try {
        var replaced = img.toString();
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

      image = CircleAvatar(
        child: CircleAvatar(
          backgroundImage: Image.memory(_image!, fit: BoxFit.cover).image,
        ),
      );
    }

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                titleName,
                style: TextStyle(
                  color: AppColors.primaryColors[0],
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle1,
                style: TextStyle(
                  color: AppColors.primaryColors[0],
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle2,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          leading: image,
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
      ),
    );
  }
}
