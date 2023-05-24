// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:typed_data';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/register_step1_page.dart';
import 'package:themoviedb/full/ui/register/register_step3_client_fiz_page.dart';
import 'package:themoviedb/full/ui/register/register_step3_client_ur_page.dart';
import 'package:themoviedb/full/ui/register/register_step3_driver_fiz_page.dart';
import 'package:themoviedb/full/ui/register/register_step3_driver_ur_page.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_list/Current/newCurrentOrder.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_list/Current/notify_order.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../app/my_app.dart';
import '../../main_list/Current/Order_history.dart';
import '../Settings_page.dart';
import 'my_cars.dart';
import 'my_drivers.dart';
import 'profileDet.dart';
import 'swape_role.dart';

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';
import '../../../../../controllers/location_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final pm = ProfileModel();
  dynamic jData = [];
  Uint8List? _image;
  bool load = true;

  var phoneNumber = '';
  var token = '';
  var NotifyCount = '';

  var sysUserType = '';
  var sysUserTypeName = '';

  var ButtonName = '';

  dynamic clientData = [];

  @override
  void initState() {
    super.initState();
    pm.setupLocale(context).then(
      (value) async {
        // print(pm.token);
        // print(pm.sysUserType);
        GetSysType(
          token: pm.token.toString(),
          sysUserType: pm.sysUserType.toString(),
        ).getSysType().then(
          (value) {
            // print('Response: $value');

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
              } catch (e) {
                print('Get Cabinet error ===> $e');
              }
              sysUserType = pm.sysUserType;

              if (sysUserType == '1') {
                final clientId = result["clientIndivisual"]['clientId'];
                final firstName = result["clientIndivisual"]['firstName'];
                final lastName = result["clientIndivisual"]['lastName'];
                final thirdName = result["clientIndivisual"]['thirdName'];
                final email = result["clientIndivisual"]['email'];
                final iin = result["clientIndivisual"]['iin'];

                pm.sysUserType = sysUserType.toString();
                pm.clientId = clientId.toString();
                pm.FullName = "$lastName $firstName $thirdName";
                pm.firstName = firstName.toString();
                pm.lastName = lastName.toString();
                pm.pName = thirdName.toString();
                pm.email = email.toString();
                pm.iin = iin.toString();
                pm.sysUserTypeName = AppLocalizations.of(context)!.gruzOtprav1;

                setState(() {
                  jData = result;
                  ButtonName = AppLocalizations.of(context)!.redaktirovat;
                  sysUserType = sysUserType.toString();
                  sysUserTypeName = AppLocalizations.of(context)!.gruzOtprav;
                  phoneNumber = pm.phoneNumber;
                  token = pm.token;
                  load = false;
                });
              } else if (sysUserType == '2') {
                final clientId = result["clientCompany"]['clientId'];
                final companyName = result["clientCompany"]['companyName'];
                final companyIIN = result["clientCompany"]['companyIIN'];
                final companyAddress =
                    result["clientCompany"]['companyAddress'];
                final email = result["clientCompany"]['email'];

                pm.sysUserType = sysUserType.toString();
                pm.clientId = clientId.toString();
                pm.FullName = "$companyName";
                pm.companyName = companyName.toString();
                pm.companyIIN = companyIIN.toString();
                pm.companyAddress = companyAddress.toString();
                pm.email = email.toString();
                pm.sysUserTypeName = AppLocalizations.of(context)!.gruzOtprav2;

                setState(() {
                  jData = result;
                  ButtonName = AppLocalizations.of(context)!.redaktirovat;
                  sysUserType = sysUserType.toString();
                  sysUserTypeName = AppLocalizations.of(context)!.gruzOtprav;
                  phoneNumber = pm.phoneNumber;
                  token = pm.token;
                  load = false;
                });
              } else if (sysUserType == '3') {
                var temp = result['clientIndivisual'];

                pm.sysUserType = sysUserType.toString();
                pm.clientId = temp['clientId'].toString();
                pm.firstName = temp['firstName'];
                pm.lastName = temp['lastName'];
                pm.pName = temp['thirdName'];

                pm.FullName =
                    "${temp['lastName']} ${temp['firstName']} ${temp['thirdName']}";

                pm.email = temp['email'];
                pm.iin = temp['iin'].toString();
                pm.sysUserTypeName = AppLocalizations.of(context)!.gruzPerevoz1;

                setState(() {
                  jData = result;
                  ButtonName = AppLocalizations.of(context)!.redaktirovat;
                  sysUserType = sysUserType.toString();
                  sysUserTypeName = AppLocalizations.of(context)!.gruzPerevoz;
                  phoneNumber = pm.phoneNumber;
                  token = pm.token;
                  load = false;
                });
              } else if (sysUserType == '4') {
                var jdata = result['clientCompany'];

                pm.sysUserType = sysUserType.toString();
                pm.clientId = jdata['clientId'].toString();
                pm.firstName = jdata['companyName'];

                pm.FullName = "${jdata['companyName']}";

                pm.sysUserTypeName = AppLocalizations.of(context)!.gruzPerevoz2;
                // pm.pName = '';
                // pm.lastName = jdata['lastName'];
                // pm.email = jdata['email'];
                // pm.iin = jdata['iin'].toString();
                // pm.ButtonName = AppLocalizations.of(context)!.redaktirovat;
                // pm.userTypeName = AppLocalizations.of(context)!.gruzPerevoz;

                setState(() {
                  jData = result;
                  ButtonName = AppLocalizations.of(context)!.redaktirovat;
                  sysUserType = sysUserType.toString();
                  sysUserTypeName = AppLocalizations.of(context)!.gruzPerevoz;
                  phoneNumber = pm.phoneNumber;
                  token = pm.token;
                  load = false;
                });
              } else if (sysUserType == '5') {
                var jdata = result['clientIndivisual'];

                pm.sysUserType = sysUserType.toString();
                pm.clientId = jdata['clientId'].toString();
                pm.firstName = jdata['firstName'];
                pm.pName = jdata['driverCompany'];
                pm.lastName = jdata['lastName'];

                pm.FullName =
                    "${jdata['lastName']} ${jdata['firstName']} ${jdata['thirdName']}";

                pm.email = jdata['email'];
                pm.iin = jdata['iin'].toString();
                pm.sysUserTypeName = AppLocalizations.of(context)!.voditel;
                // pm.ButtonName = AppLocalizations.of(context)!.redaktirovat;
                // pm.userTypeName = AppLocalizations.of(context)!.voditel;

                setState(() {
                  jData = result;
                  ButtonName = AppLocalizations.of(context)!.redaktirovat;
                  sysUserType = sysUserType.toString();
                  sysUserTypeName = AppLocalizations.of(context)!.voditel;
                  phoneNumber = pm.phoneNumber;
                  token = pm.token;
                  load = false;
                });
              } else {
                pm.firstName = AppLocalizations.of(context)!.gost;
                // pm.ButtonName = AppLocalizations.of(context)!.register;

                setState(() {
                  jData = result;
                  ButtonName = AppLocalizations.of(context)!.register;
                  sysUserType = sysUserType.toString();
                  sysUserTypeName = AppLocalizations.of(context)!.voditel;
                  phoneNumber = pm.phoneNumber;
                  token = pm.token;
                  load = false;
                });
              }
            } catch (e) {
              print('error $e');
              pm.firstName = AppLocalizations.of(context)!.gost;
              // pm.ButtonName = AppLocalizations.of(context)!.register;

              setState(() {
                jData = result;
                ButtonName = AppLocalizations.of(context)!.register;
                sysUserType = sysUserType.toString();
                sysUserTypeName = AppLocalizations.of(context)!.voditel;
                phoneNumber = pm.phoneNumber;
                token = pm.token;
                load = false;
              });
            }
          },
        );

        if (pm.sysUserType == '3' || pm.sysUserType == '4') {
          await NotCount(
            token: pm.token,
          ).DriverData().then(
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
                NotifyCount = value;
                setState(() {});
              }
            },
          );
        }

        if (pm.sysUserType == '1' || pm.sysUserType == '2') {
          await NotCount(
            token: pm.token,
          ).ClientData().then(
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
                NotifyCount = value;
                setState(() {});
              }
            },
          );
          await Clientdeliveredlist(
            token: pm.token,
          ).getList().then(
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

                for (var item in parsedJson) {
                  showDialog(
                    context: context,
                    barrierDismissible:
                        true, // set to false if you want to force a rating
                    builder: (context) => RatingDialog(
                      image: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.zakazy}:',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                item['orderName'],
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            item['beginPointName'],
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            item['endPointName'],
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.gruzPerevoz}:',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                item['driver']['firstName'] +
                                    " " +
                                    item['driver']['lastName'],
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      starSize: 35,
                      initialRating: 5.0,
                      title: Text(
                        AppLocalizations.of(context)!.otcenitePerevozchika,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      message: Text(
                        AppLocalizations.of(context)!.kosnitecZvezdy,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15),
                      ),
                      submitButtonText: AppLocalizations.of(context)!.zavershit,
                      submitButtonTextStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      commentHint:
                          AppLocalizations.of(context)!.napishiteKomment,
                      onCancelled: () {
                        clientfeedbackclose(
                          token: pm.token,
                          orderId: item['orderId'],
                        ).end().then(
                          (value) {
                            // print('Response: $value');

                            if (value.toString() == '401') {
                              final provider = SessionDataProvider();
                              provider.setSessionId(null);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  MainNavigationRouteNames.changeLang,
                                  (Route<dynamic> route) => false);
                            }

                            if (value.contains('Успеш')) {
                              _onBasicAlertPressedUpd(context);
                            } else if (value.contains('уже')) {
                              _onBasicAlertPressed2(context);
                            } else {
                              _onBasicAlertPressed3(context);
                            }
                          },
                        );
                      },
                      onSubmitted: (response) async {
                        await Clientfeedback(
                          token: pm.token,
                          orderId: item['orderId'],
                          clientId: item['creator']['clientId'],
                          driverId: item['driver']['clientId'],
                          orgId: item['driver']['orgId'],
                          rankPoint: response.rating.toInt(),
                          description: response.comment,
                        ).end().then(
                          (value) {
                            // print('Response: $value');

                            if (value.toString() == '401') {
                              final provider = SessionDataProvider();
                              provider.setSessionId(null);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  MainNavigationRouteNames.changeLang,
                                  (Route<dynamic> route) => false);
                            }

                            if (value.contains('Успеш')) {
                              _onBasicAlertPressedUpd(context);
                            } else if (value.contains('уже')) {
                              _onBasicAlertPressed2(context);
                            } else {
                              _onBasicAlertPressed3(context);
                            }
                          },
                        );
                      },
                    ),
                  );
                }
              }
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.kabinet,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          // ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => TestSocket()),
          //       );
          //     },
          //     child: Text('Socket')),
          IconButton(
            onPressed: () => SheetBar(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: load ? LoadingData() : profileData(),
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
                  style: Theme.of(context).textTheme.subtitle2,
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

  Container profileData() {
    // try {
    //   if (jData.length > 0) {
    //     if (jData["clientIndivisual"]['photo'] != "") {
    //       base64ToImgFile(jData["clientIndivisual"]['photo']);
    //     } else if (jData["clientCompany"]['photo'] != "") {
    //       base64ToImgFile(jData["clientCompany"]['photo']);
    //     }
    //   }
    // } catch (e) {
    //   print('viewPhoto ===> $e');
    // }

    if (sysUserType == '1') {
      //жеке клиент
      return sysUserType1(context, pm, phoneNumber, ButtonName);
    } else if (sysUserType == '2') {
      // компания клиент
      return sysUserType2(context, phoneNumber, pm, token, ButtonName);
    } else if (sysUserType == '3') {
      //жеке драйвер
      return sysUserType3(context, pm, phoneNumber, pm, ButtonName);
    } else if (sysUserType == '4') {
      //компания драйвер
      return sysUserType4(context, pm, phoneNumber, ButtonName);
    } else if (sysUserType == '5') {
      //компания жургызушысы
      return sysUserType5(context, pm, phoneNumber, ButtonName);
    } else {
      // гость
      return sysUserTypeElse(context, phoneNumber, pm, token, ButtonName);
    }
  }

  Container sysUserTypeElse(BuildContext context, String? phoneNumber,
      ProfileModel? model, String? token, String? ButtonName) {
    return Container(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      // color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //for user profile header
          Container(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                        height: 80,
                        width: 80,
                        child: ClipOval(
                          child: Image.asset(
                            'images/Portrait_Placeholder.png',
                            fit: BoxFit.cover,
                          ),
                        )),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${model?.firstName}',
                            style: TextStyle(
                                // color: Colors.grey[500],
                                fontFamily: "Roboto",
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 8),
                          Text(
                            phoneNumber.toString(),
                            style: TextStyle(
                              // color: Colors.black,
                              fontFamily: "Roboto",
                              fontSize: 15,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Token: $token',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontFamily: "Roboto",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // const SerialsListWidget(), //logout
                  ],
                ),
              ),
            ),
          ),

          Container(
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterStep1View()));
              },
              icon: Image.asset("images/key.png",
                  width: 16, height: 16, color: Colors.white),
              label: Text(ButtonName!),
            ),
          ),
        ],
      ),
    );
  }

  Container sysUserType5(BuildContext context, ProfileModel? model,
      String? phoneNumber, String? ButtonName) {
    final provider = Provider.of<LocaleProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      // color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ProfileDetails(
              //       pm: model!,
              //       jData: jData,
              //       onClickAction: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => RegisterStep3ClientUrView(
              //                     edit: true,
              //                     jdata: jData,
              //                     swapeRole: false,
              //                   )),
              //         );
              //       },
              //     ),
              //   ),
              // );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primaryColors[0],
                      child: CircleAvatar(
                        radius: 40 - 1,
                        backgroundImage: _image == null || _image?.length == 0
                            ? Image.asset('images/Portrait_Placeholder.png',
                                    fit: BoxFit.cover)
                                .image
                            : Image.memory(_image!, fit: BoxFit.cover).image,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${model?.FullName}',
                            style: TextStyle(
                                // color: Colors.black,
                                fontFamily: "Roboto",
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 8),
                          Text(
                            phoneNumber.toString(),
                            style: TextStyle(
                                // color: Colors.grey[500],
                                fontFamily: "Roboto",
                                fontSize: 15,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${model?.sysUserTypeName}',
                            style: TextStyle(
                              // color: Colors.grey[500],
                              fontFamily: "Roboto",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Icon(
                    //   Icons.arrow_forward_ios,
                    //   size: 15,
                    // ),
                    // SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          cardVal(
            AppLocalizations.of(context)!.tecushZakaz,
            Image.asset(
              "images/currentOrders.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
            ),
            context,
            RegisterStep1View(),
          ),
          cardVal(
            AppLocalizations.of(context)!.istoryaZakaz,
            Image.asset(
              "images/historyOrders.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
            ),
            context,
            RegisterStep1View(),
          ),
        ],
      ),
    );
  }

  Container sysUserType4(BuildContext context, ProfileModel? model,
      String? phoneNumber, String? ButtonName) {
    String img = jData == null ? "" : jData["clientCompany"]['photo'];
    final provider = Provider.of<LocaleProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileDetails(
                    pm: model!,
                    jData: jData,
                    onClickAction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterStep3DriverUrView(
                                  edit: true,
                                  jdata: jData,
                                  swapeRole: false,
                                )),
                      );
                    },
                  ),
                ),
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primaryColors[0],
                      child: CircleAvatar(
                        radius: 40 - 1,
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
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${model?.FullName}',
                            style: TextStyle(
                                // color: Colors.black,
                                fontFamily: "Roboto",
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 8),
                          Text(
                            phoneNumber.toString(),
                            style: TextStyle(
                                // color: Colors.grey[500],
                                fontFamily: "Roboto",
                                fontSize: 15,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${model?.sysUserTypeName}',
                            style: TextStyle(
                              // color: Colors.grey[500],
                              fontFamily: "Roboto",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Icon(
                    //   Icons.open,
                    //   size: 15,
                    // ),
                    // SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          cardVal(
            AppLocalizations.of(context)!.moiVoditeli,
            Image.asset(
              "images/profile.users.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
            ),
            context,
            MyDrivers(),
          ),
          cardVal(
            AppLocalizations.of(context)!.moiAvto,
            Image.asset(
              "images/mycars.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
            ),
            context,
            MyCars(),
          ),
          cardVal(
            AppLocalizations.of(context)!.tecushZakaz,
            Image.asset(
              "images/currentOrders.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
            ),
            context,
            RegisterStep1View(),
          ),
          cardVal(
            AppLocalizations.of(context)!.istoryaZakaz,
            Image.asset(
              "images/historyOrders.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
            ),
            context,
            RegisterStep1View(),
          ),
          cardVal(
            AppLocalizations.of(context)!.uvedomleniya,
            Image.asset(
              "images/notify.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
            ),
            context,
            RegisterStep1View(),
          ),
          Spacer(),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SwapeRole(),
                    ));
              },
              icon: Icon(Icons.swap_horiz_rounded),
              label: Text(AppLocalizations.of(context)!.smenitRole),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Container sysUserType3(BuildContext context, ProfileModel? model,
      String? phoneNumber, ProfileModel pm, String? ButtonName) {
    String img = jData["clientIndivisual"]['photo'];

    final provider = Provider.of<LocaleProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      // color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileDetails(
                    pm: model!,
                    jData: jData,
                    onClickAction: () {
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
                              builder: (context) => RegisterStep3DriverFizView(
                                CarBrands: CarBrands,
                                token: pm.token,
                                edit: true,
                                jdata: jData,
                                swapeRole: false,
                              ),
                            ),
                          );
                        }
                      });
                    },
                  ),
                ),
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primaryColors[0],
                      child: CircleAvatar(
                        radius: 40 - 1,
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
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${model?.FullName}',
                            style: TextStyle(
                                // color: Colors.black,
                                fontFamily: "Roboto",
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 8),
                          Text(
                            phoneNumber.toString(),
                            style: TextStyle(
                                // color: Colors.grey[500],
                                fontFamily: "Roboto",
                                fontSize: 15,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${model?.sysUserTypeName}',
                            style: TextStyle(
                              // color: Colors.grey[500],
                              fontFamily: "Roboto",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Icon(
                    //   Icons.arrow_forward_ios,
                    //   size: 15,
                    // ),
                    // SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          cardVal(
            AppLocalizations.of(context)!.tecushZakaz,
            Image.asset(
              "images/currentOrders.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
            ),
            context,
            RegisterStep1View(),
          ),
          cardVal(
            AppLocalizations.of(context)!.istoryaZakaz,
            Image.asset(
              "images/historyOrders.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
            ),
            context,
            RegisterStep1View(),
          ),
          cardVal(
            AppLocalizations.of(context)!.uvedomleniya,
            Image.asset(
              "images/notify.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
            ),
            context,
            RegisterStep1View(),
          ),
          Spacer(),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SwapeRole(),
                    ));
              },
              icon: Icon(Icons.swap_horiz_rounded),
              label: Text(AppLocalizations.of(context)!.smenitRole),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Container sysUserType2(BuildContext context, String? phoneNumber,
      ProfileModel? model, String? token, String? ButtonName) {
    String img = jData["clientCompany"]['photo'];
    final provider = Provider.of<LocaleProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      // color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileDetails(
                    pm: model!,
                    jData: jData,
                    onClickAction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterStep3ClientUrView(
                                  edit: true,
                                  jdata: jData,
                                  swapeRole: false,
                                )),
                      );
                    },
                  ),
                ),
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primaryColors[0],
                      child: CircleAvatar(
                        radius: 40 - 1,
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
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${model?.FullName}',
                            style: TextStyle(
                                // color: Colors.black,
                                fontFamily: "Roboto",
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 8),
                          Text(
                            phoneNumber.toString(),
                            style: TextStyle(
                                // color: Colors.grey[500],
                                fontFamily: "Roboto",
                                fontSize: 15,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${model?.sysUserTypeName}',
                            style: TextStyle(
                              // color: Colors.grey[500],
                              fontFamily: "Roboto",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Icon(
                    //   Icons.arrow_forward_ios,
                    //   size: 15,
                    // ),
                    // SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          cardVal(
            AppLocalizations.of(context)!.tecushZakaz,
            Image.asset(
              "images/currentOrders.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
            ),
            context,
            RegisterStep1View(),
          ),
          cardVal(
            AppLocalizations.of(context)!.istoryaZakaz,
            Image.asset(
              "images/historyOrders.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
            ),
            context,
            RegisterStep1View(),
          ),
          cardVal(
            AppLocalizations.of(context)!.uvedomleniya,
            Image.asset(
              "images/notify.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
            ),
            context,
            RegisterStep1View(),
          ),
          Spacer(),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SwapeRole(),
                    ));
              },
              icon: Icon(Icons.swap_horiz_rounded),
              label: Text(AppLocalizations.of(context)!.smenitRole),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Container sysUserType1(BuildContext context, ProfileModel? model,
      String? phoneNumber, String? ButtonName) {
    String img = jData["clientIndivisual"]['photo'];

    final provider = Provider.of<LocaleProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      // color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileDetails(
                    pm: model!,
                    jData: jData,
                    onClickAction: () {
                      dynamic res = {
                        'token': model.token,
                        'imgBase64': jData["clientIndivisual"]['photo'],
                        'clientId': model.clientId,
                        'firstName': model.firstName,
                        'pName': model.pName,
                        'lastName': model.lastName,
                        'email': model.email,
                        'iin': model.iin,
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterStep3ClientFizView(
                            edit: true,
                            jdata: res,
                            swapeRole: false,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primaryColors[0],
                      child: CircleAvatar(
                        radius: 40 - 1,
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
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${model?.lastName} ${model?.firstName}',
                            style: TextStyle(
                                // color: Colors.black,
                                fontFamily: "Roboto",
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 8),
                          Text(
                            phoneNumber.toString(),
                            style: TextStyle(
                                // color: Colors.grey[500],
                                fontFamily: "Roboto",
                                fontSize: 15,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${model?.sysUserTypeName}',
                            style: TextStyle(
                              // color: Colors.grey[500],
                              fontFamily: "Roboto",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Icon(
                    //   Icons.arrow_forward_ios,
                    //   size: 15,
                    // ),
                    // SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          cardVal(
            AppLocalizations.of(context)!.tecushZakaz,
            Image.asset(
              "images/currentOrders.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
            ),
            context,
            RegisterStep1View(),
          ),
          cardVal(
            AppLocalizations.of(context)!.istoryaZakaz,
            Image.asset(
              "images/historyOrders.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
            ),
            context,
            RegisterStep1View(),
          ),
          cardVal(
            AppLocalizations.of(context)!.uvedomleniya,
            Image.asset(
              "images/notify.png",
              width: 24,
              color: provider.selectedThemeMode == ThemeMode.dark
                  ? Colors.white
                  : AppColors.primaryColors[0],
            ),
            context,
            RegisterStep1View(),
          ),
          Spacer(),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SwapeRole(),
                    ));
              },
              icon: Icon(Icons.swap_horiz_rounded),
              label: Text(AppLocalizations.of(context)!.smenitRole),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Card cardVal(String titleName, Widget iconVal, context, pageName) {
    final provider = Provider.of<LocaleProvider>(context);

    var titleSt = TextStyle(
      color: provider.selectedThemeMode == ThemeMode.dark
          ? Colors.white
          : AppColors.primaryColors[0],
      fontWeight: FontWeight.w400,
      fontSize: 15,
      letterSpacing: 0.3,
    );

    return Card(
      // color: Colors.grey[100],
      child: ListTile(
        leading: iconVal,
        title: titleName == AppLocalizations.of(context)!.uvedomleniya
            ? Row(
                children: [
                  Text(
                    titleName,
                    style: titleSt,
                  ),
                  SizedBox(width: 20),
                  Text(
                    !NotifyCount.contains("0") ? NotifyCount : "",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : Text(
                titleName,
                style: titleSt,
              ),
        trailing: Icon(
          Icons.arrow_forward,
          size: 20,
          color: provider.selectedThemeMode == ThemeMode.dark
              ? Colors.white
              : AppColors.primaryColors[0],
        ),
        onTap: () {
          if (titleName == AppLocalizations.of(context)!.uvedomleniya) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotifyCurrentOrders()),
            );
          } else if (titleName == AppLocalizations.of(context)!.moiVoditeli) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyDrivers()),
            );
          } else if (titleName == AppLocalizations.of(context)!.moiAvto) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyCars()),
            );
          } else if (titleName == AppLocalizations.of(context)!.tecushZakaz) {
            // var model1 = NotifierProvider.watchOnModel<ProfileModel>(context);
            // var token1 = model1?.token;

            Navigator.push(
              context,
              MaterialPageRoute(
                // builder: (context) => MyCurrentOrders(),
                builder: (context) => NewCurrentOrders(),
              ),
            );
          } else if (titleName == AppLocalizations.of(context)!.istoryaZakaz) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderHistory(),
              ),
            );
          } else {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => pageName),
            // );
          }
        },
      ),
    );
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

class SerialsListWidget extends StatelessWidget {
  const SerialsListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: Icon(Icons.logout),
        onPressed: () => SheetBar(context),
      ),
    );
  }
}

Future<dynamic> SheetBar(BuildContext context) {
  LocationController locationController = Get.find();
  return showAdaptiveActionSheet(
    context: context,
    title: Text(AppLocalizations.of(context)!.vyDeistviVuiti),
    actions: <BottomSheetAction>[
      BottomSheetAction(
        title: Text(
          AppLocalizations.of(context)!.vyhod,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        onPressed: (context) {
          locationController.start.value = false;
          final provider = SessionDataProvider();
          provider.setSessionId(null);
          Navigator.of(context).pushNamedAndRemoveUntil(
              MainNavigationRouteNames.changeLang,
              (Route<dynamic> route) => false);
        },
        // leading: const Icon(Icons.circle_outlined, size: 25),
      ),
    ],
    cancelAction: CancelAction(
        title: Text(
      AppLocalizations.of(context)!.otmena,
      style: TextStyle(color: Colors.blueAccent),
    )),
  );
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
    desc: AppLocalizations.of(context)!.zakazZavershen,
  ).show();
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
  return Alert(
      context: context,
      style: alertStyle,
      // title: "RFLUTTER ALERT",
      desc: AppLocalizations.of(context)!.vyUzheZavershiliZakaz,
      buttons: [
        DialogButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
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
  return Alert(
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
