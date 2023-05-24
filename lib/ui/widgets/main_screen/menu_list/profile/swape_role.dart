import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:themoviedb/full/ui/register/register_step3_client_ur_page.dart';
import 'package:themoviedb/full/ui/register/register_step3_driver_fiz_page.dart';
import 'package:themoviedb/full/ui/register/register_step3_driver_ur_page.dart';
import '../../../../../domain/data_providers/session_data_provider.dart';
import '../../../../../full/ui/register/register_step3_client_fiz_page.dart';
import '../../../../../full/ui/register/step3_client_fiz_model.dart';
import '../../../../navigation/main_navigation.dart';
import '../Settings_page.dart';
import 'my_cars.dart';
import 'profile_model.dart';

class SwapeRole extends StatefulWidget {
  const SwapeRole({Key? key}) : super(key: key);

  @override
  _SwapeRoleState createState() => _SwapeRoleState();
}

final pm = ProfileModel();
bool valueBool = false;
String SysType = '';

bool load = true;

class _SwapeRoleState extends State<SwapeRole> {
  @override
  void initState() {
    load = true;
    pm.setupLocale(context).then((value) {
      setState(() {
        SysType = pm.sysUserType;
        load = false;
        print("SysType: " + SysType);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.smenitRole),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: load
          ? Column()
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SysType == "1"
                      ? SizedBox()
                      : Card(
                          child: ListTile(
                            title:
                                Text(AppLocalizations.of(context)!.gruzOtprav1),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () => GetUpdateOdCreateRole("1"),
                          ),
                        ),
                  SysType == "2"
                      ? SizedBox()
                      : Card(
                          child: ListTile(
                            title:
                                Text(AppLocalizations.of(context)!.gruzOtprav2),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () => GetUpdateOdCreateRole("2"),
                          ),
                        ),
                  SysType == "3"
                      ? SizedBox()
                      : Card(
                          child: ListTile(
                            title: Text(
                                AppLocalizations.of(context)!.gruzPerevoz1),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () => GetUpdateOdCreateRole("3"),
                          ),
                        ),
                  SysType == "4"
                      ? SizedBox()
                      : Card(
                          child: ListTile(
                            title: Text(
                                AppLocalizations.of(context)!.gruzPerevoz2),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () => GetUpdateOdCreateRole("4"),
                          ),
                        ),
                ],
              ),
            ),
    );
  }

  Future<void> GetUpdateOdCreateRole(String sysUserType) async {
    print(sysUserType);

    await GetSysType(
      token: pm.token.toString(),
      sysUserType: sysUserType.toString(),
    ).getSysType().then(
      (value) async {
        print('Response: $value');

        if (value.toString() == '401') {
          final provider = SessionDataProvider();
          provider.setSessionId(null);
          Navigator.of(context).pushNamedAndRemoveUntil(
              MainNavigationRouteNames.changeLang,
              (Route<dynamic> route) => false);
        }

        dynamic result;

        try {
          try {
            result = json.decode(value);
            print(result);
          } catch (e) {
            print('Swape role error ===> $e');
          }

          if (sysUserType == '1') {
            final clientId = result["clientIndivisual"]['clientId'];
            final firstName = result["clientIndivisual"]['firstName'];
            final lastName = result["clientIndivisual"]['lastName'];
            final thirdName = result["clientIndivisual"]['thirdName'];
            final email = result["clientIndivisual"]['email'];
            final iin = result["clientIndivisual"]['iin'];

            pm.sysUserType = sysUserType.toString();
            pm.clientId = clientId.toString();
            pm.firstName = firstName.toString();
            pm.lastName = lastName.toString();
            pm.pName = thirdName.toString();
            pm.email = email.toString();
            pm.iin = iin.toString();

            dynamic res = {
              'token': pm.token,
              'imgBase64': result["clientIndivisual"]['photo'],
              'clientId': pm.clientId,
              'firstName': pm.firstName,
              'pName': pm.pName,
              'lastName': pm.lastName,
              'email': pm.email,
              'iin': pm.iin,
            };
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterStep3ClientFizView(
                  edit: true,
                  jdata: res,
                  swapeRole: true,
                ),
              ),
            );
          } else if (sysUserType == '2') {
            dynamic jData = result;
            final clientId = result["clientCompany"]['clientId'];
            final companyName = result["clientCompany"]['companyName'];
            final companyIIN = result["clientCompany"]['companyIIN'];
            final companyAddress = result["clientCompany"]['companyAddress'];
            final email = result["clientCompany"]['email'];

            pm.sysUserType = sysUserType.toString();
            pm.clientId = clientId.toString();
            pm.companyName = companyName.toString();
            pm.companyIIN = companyIIN.toString();
            pm.companyAddress = companyAddress.toString();
            pm.email = email.toString();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterStep3ClientUrView(
                  edit: true,
                  jdata: jData,
                  swapeRole: true,
                ),
              ),
            );
          } else if (sysUserType == '3') {
            var temp = result['clientIndivisual'];

            dynamic jData = result;

            pm.sysUserType = sysUserType.toString();
            pm.clientId = temp['clientId'].toString();
            pm.firstName = temp['firstName'];
            pm.pName = '';
            pm.lastName = temp['lastName'];
            pm.email = temp['email'];
            pm.iin = temp['iin'].toString();

            showLoadingIndicator(context);

            await GetCarBrands(
              token: pm.token.toString(),
            ).get().then((value) {
              print('Response: $value');

              if (value.toString() == '401') {
                final provider = SessionDataProvider();
                provider.setSessionId(null);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    MainNavigationRouteNames.changeLang,
                    (Route<dynamic> route) => false);
              }
              hideOpenDialog(context);

              if (value.contains('Error')) {
                showErrorIndicator(context);
              } else {
                final parsedJson = jsonDecode(value);

                final CarBrands = Car.fromJson(parsedJson);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterStep3DriverFizView(
                      CarBrands: CarBrands,
                      token: pm.token,
                      edit: true,
                      swapeRole: true,
                      jdata: jData,
                    ),
                  ),
                );
              }
            });
          } else if (sysUserType == '4') {
            var jdata = result['clientCompany'];

            pm.sysUserType = sysUserType.toString();
            pm.clientId = jdata['clientId'].toString();
            pm.firstName = jdata['companyName'];

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterStep3DriverUrView(
                  edit: true,
                  jdata: result,
                  swapeRole: true,
                ),
              ),
            );
          }
        } catch (e) {
          print('Swape role error $e');
        }
      },
    );
  }
}
