import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_list/Current/Order_history.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import 'package:rating_dialog/rating_dialog.dart';
import '../../../domain/data_providers/session_data_provider.dart';
import '../../../ui/navigation/main_navigation.dart';
import '../register/step3_client_fiz_model.dart';
import 'google_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../controllers/location_controller.dart';

class OrderDatailCardView extends StatefulWidget {
  final dynamic jdata;
  final dynamic myDrivers;
  final dynamic myCars;
  OrderDatailCardView({
    Key? key,
    required this.jdata,
    required this.myDrivers,
    required this.myCars,
  }) : super(key: key);

  @override
  _OrderDatailCardViewState createState() => _OrderDatailCardViewState();
}

class _OrderDatailCardViewState extends State<OrderDatailCardView> {
  @override
  Widget build(BuildContext context) {
    // print(widget.jdata);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.detaliGruza,
          style: TextStyle(
            // color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: MyStatefulWidget(
          jdata: widget.jdata,
          myDrivers: widget.myDrivers,
          myCars: widget.myCars,
        ),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  final dynamic jdata;
  final dynamic myDrivers;
  final dynamic myCars;
  MyStatefulWidget({
    Key? key,
    required this.jdata,
    required this.myDrivers,
    required this.myCars,
  }) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState(
        jdata: jdata,
        myCars: myCars,
        myDrivers: myDrivers,
      );
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  LocationController locationController = Get.find();
  final dynamic jdata;
  final dynamic myDrivers;
  final dynamic myCars;
  _MyStatefulWidgetState({
    required this.jdata,
    required this.myDrivers,
    required this.myCars,
  });

  int orderId = -1;
  int driverId = -1;
  int carId = 0;
  int offerPrice = -1;

  String isEmpWidget = '';
  TextEditingController offerPriceField = TextEditingController();

  ProfileModel pm = ProfileModel();
  var carTypeTxt = '';
  bool _isPressed = false;

  @override
  void initState() {
    _isPressed = false;
    pm.setupLocale(context).then((value) {
      setState(() {
        pm = pm;
      });
    });
    super.initState();
  }

  void _myCallback() {
    locationController.start.value = false;
    setState(() {
      _isPressed = true;
    });

    final _dialog = RatingDialog(
      starSize: 35,
      initialRating: 5.0,
      title: Text(
        'Оцените клиента',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      message: Text(
        'Коснитесь звезды, чтобы оценить. Добавьте комментарии',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      submitButtonText: 'Завершить',
      submitButtonTextStyle: const TextStyle(
        fontSize: 20,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
      commentHint: 'Напишите комментарии',
      onCancelled: () => print('cancelled'),
      onSubmitted: newMethod,
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) => _dialog,
    );
  }

  newMethod(response) {
    Drivercompleteorder(
      token: pm.token,
      orderId: widget.jdata['orderId'],
      clientId: widget.jdata['creator']['clientId'],
      driverId: widget.jdata['driver']['clientId'],
      orgId: widget.jdata['driver']['orgId'],
      rankPoint: response.rating.toInt(),
      description: response.comment,
    ).end().then(
      (value) {
        print('Response: $value');

        setState(() {
          _isPressed = false;
        });

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

    print('rating: ${response.rating}, comment: ${response.comment}');
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.jdata;

    //Сохраняем номер заказаы
    orderId = data['orderId'];
    // driverId = myDrivers[0]['clientId'];
    driverId = 1;
    // carId = myCars[0]['carId'];
    carId = 0;
    offerPrice = data['bookerOfferPrice'];

    var formatted = data['tripDate'];
    try {
      DateTime parseDate =
          new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(formatted);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('dd.MM.yyyy');
      var outputDate = outputFormat.format(inputDate);
      // print(outputDate);
      formatted = outputDate;
    } catch (e) {
      print('date parse error');
    }

    final lugHeight = TextEditingController(text: data['lugHeight'].toString());
    final lugWidth = TextEditingController(text: data['lugWidth'].toString());
    final lugDepth = TextEditingController(text: data['lugDepth'].toString());

    final lugDesk = TextEditingController(text: data['orderName']);
    final lugWeigth = TextEditingController(text: data['lugWeight'].toString());
    final lugKub = TextEditingController(text: data['lugSize'].toString());
    // final carT = TextEditingController(text: carTypeTxt);
    final lugDate = TextEditingController(text: formatted);
    // final money = TextEditingController(text: "${data['bookerOfferPrice']} тг");

    // final cashType = TextEditingController(text: payType[carType1 - 1]);

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    final textStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.blueGrey,
    );
    final textFieldDecorator = const InputDecoration(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1)),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        isCollapsed: true);

    carId = data['car']['carId'];

    var coord1 = data['beginPoint'].toString().split(",");
    var coord2 = data['endPoint'].toString().split(",");
    int orderStatusId = data['orderStatus'];

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.gruz,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blueGrey,
              ),
            ),
            // SizedBox(height: 5),
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
                  Text(
                    '${AppLocalizations.of(context)!.opisanieGruz} *',
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    maxLines: 4,
                    enabled: false,
                    decoration: textFieldDecorator,
                    controller: lugDesk,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${AppLocalizations.of(context)!.vesGruz}(${AppLocalizations.of(context)!.tonna}) *',
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    enabled: false,
                    controller: lugWeigth,
                    decoration: textFieldDecorator,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${AppLocalizations.of(context)!.obem}(м3)',
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    enabled: false,
                    controller: lugKub,
                    decoration: textFieldDecorator,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.visota,
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    enabled: false,
                    controller: lugHeight,
                    decoration: textFieldDecorator,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.dlina,
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    enabled: false,
                    controller: lugDepth,
                    decoration: textFieldDecorator,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.shirina,
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    enabled: false,
                    controller: lugWidth,
                    decoration: textFieldDecorator,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.opasnuiGruz,
                    style: textStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        shape: CircleBorder(),
                        value: data['isDanger'] == 1,
                        onChanged: (bool? value) {
                          // setState(() {
                          //   isChecked2 = value!;
                          //   isChecked1 = false;
                          //   // notCkecked = '';
                          //   // print(isChecked2);
                          // });
                        },
                      ),
                      data['isDanger'] == 1
                          ? Text(AppLocalizations.of(context)!.yes,
                              style: textStyle)
                          : Text(AppLocalizations.of(context)!.no,
                              style: textStyle),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.dogruz,
                    style: textStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        shape: CircleBorder(),
                        value: data['isAdd'] == 1,
                        onChanged: (bool? value) {
                          // setState(() {
                          //   isChecked2 = value!;
                          //   isChecked1 = false;
                          //   // notCkecked = '';
                          //   // print(isChecked2);
                          // });
                        },
                      ),
                      data['isAdd'] == 1
                          ? Text(AppLocalizations.of(context)!.yes,
                              style: textStyle)
                          : Text(AppLocalizations.of(context)!.no,
                              style: textStyle),
                    ],
                  ),
                  SizedBox(height: 5),
                  // Text(
                  //   'Тип транспорта',
                  //   style: textStyle,
                  // ),
                  // SizedBox(height: 5),
                  // TextField(
                  //   enabled: false,
                  //   controller: carT,
                  //   decoration: textFieldDecorator,
                  //   inputFormatters: <TextInputFormatter>[
                  //     FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  //   ],
                  //   textInputAction: TextInputAction.next,
                  // ),
                  // SizedBox(height: 5),
                ],
              ),
            ),
            Text(
              AppLocalizations.of(context)!.marshrut,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 5),
            Column(
              children: [
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              ' A',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Container(
                              width: 250.0,
                              child: Text(
                                // filteredData[index].email.toLowerCase(),
                                data['beginPointName'],
                                style: TextStyle(
                                  fontSize: 14.0,
                                  // color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 10,
                        ),
                        //машрут точка Б
                        Row(
                          children: [
                            Text(
                              ' B',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Container(
                              width: 250.0,
                              child: Text(
                                // filteredData[index].email.toLowerCase(),
                                data['endPointName'],
                                style: TextStyle(
                                  fontSize: 14.0,
                                  // color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),

                        // SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapPage(
                                        coord1: coord1,
                                        coord2: coord2,
                                        orderStatusId: orderStatusId,
                                        carId: carId,
                                      ),
                                    ),
                                  );
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.location_on),
                                  Text(AppLocalizations.of(context)!.marshrut,
                                      style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            data['orderStatus'] < 5
                ? Column()
                // : data['orderStatus'] == 3
                // ? driverDet(data)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!.gruzOtprav,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(height: 5),
                      Column(
                        children: [
                          Card(
                            elevation: 5,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start, //горизонтально
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // вертикально
                                    children: [
                                      Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: Image.asset(
                                                    'images/Portrait_Placeholder.png',
                                                    fit: BoxFit.cover)
                                                .image,
                                            radius: 22,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 12),
                                      Column(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${data['creator']['lastName']} ${data['creator']['firstName']}',
                                                style: TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.bold,
                                                  // color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Row(
                                                children: [
                                                  Icon(Icons.star_rounded,
                                                      color:
                                                          Colors.orangeAccent,
                                                      size: 13),
                                                  Text(
                                                    '5.0',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      // color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!.gruzPerevoz,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(height: 5),
                      Column(
                        children: [
                          Card(
                            elevation: 5,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start, //горизонтально
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // вертикально
                                    children: [
                                      Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: Image.asset(
                                                    'images/Portrait_Placeholder.png',
                                                    fit: BoxFit.cover)
                                                .image,
                                            radius: 22,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 12),
                                      Column(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${data['driver']['orderInChargeName']}',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  // color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Row(
                                                children: [
                                                  Icon(Icons.star_rounded,
                                                      color:
                                                          Colors.orangeAccent,
                                                      size: 13),
                                                  Text(
                                                    '5.0',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      // color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                '${data['car']['brandNameRu']} ${data['car']['modelNameRu']}',
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400,
                                                  // color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                '${data['car']['carTypeNameRu']}, (${data['car']['carWeight']}т)',
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400,
                                                  // color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                '${data['car']['carNumber']}, (${data['car']['modelYear']}год)'
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400,
                                                  // color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                '${data['driver']['orderInChargePhone']}',
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400,
                                                  // color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

            Text(
              AppLocalizations.of(context)!.date,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    enabled: false,
                    decoration: textFieldDecorator,
                    controller: lugDate,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            Text(
              AppLocalizations.of(context)!.prise,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 5),
                  Text(
                    '${data['bookerOfferPrice']} ${data['currencyIcon']}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            data['orderStatus'] == 3 && {"3", "4", "5"}.contains(pm.sysUserType)
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 70, vertical: 20)),
                            onPressed: _isPressed == false ? _myCallback : null,
                            child: _isPressed == false
                                ? const Text(
                                    'Завершить заказ',
                                    style: TextStyle(fontSize: 14),
                                  )
                                : CircularProgressIndicator(),
                          ),
                        ],
                      ),
                    ),
                  )
                : Text(''),

            // SizedBox(height: 5),
            // Text(
            //   'Ваше предложение цены',
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 20,
            //     color: Colors.deepOrange,
            //   ),
            // ),
            // SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 5),
                  // Text(
                  //   'Ваша сумма',
                  //   style: textStyle,
                  // ),
                  // TextField(
                  //   decoration: textFieldDecorator,
                  //   controller: offerPriceField,
                  //   keyboardType: TextInputType.number,
                  //   textInputAction: TextInputAction.next,
                  // ),
                  SizedBox(height: 20),
                  // Text(
                  //   'Водитель',
                  //   style: textStyle,
                  // ),
                  // dropDown1(),
                  // SizedBox(height: 20),
                  // Text(
                  //   'Авто',
                  //   style: textStyle,
                  // ),
                  // dropDown2(),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //             padding:
            //                 EdgeInsets.symmetric(horizontal: 70, vertical: 20)),
            //         onPressed: () {
            //           showLoadingIndicator(context);

            //           offerPrice = offerPriceField.text != ''
            //               ? int.parse(offerPriceField.text)
            //               : data['bookerOfferPrice'];
            //           print(orderId);
            //           print(driverId);
            //           print(carId);
            //           print(offerPrice);

            //           dynamic orderData = {
            //             "orderId": orderId,
            //             "driverId": driverId,
            //             "carId": carId,
            //             "offerPrice": offerPrice
            //           };

            //           SendOrderRequest(
            //             token: pm.token.toString(),
            //             jdata: orderData,
            //           ).send().then(
            //             (value) {
            //               hideOpenDialog(context);

            //               print('Response: $value');
            //               if (value != 'error') {
            //                 print('Удача! $value');
            //               } else {
            //                 print('Не удалось отправить заявку на услугу');
            //               }
            //             },
            //           );
            //           hideOpenDialog(context);
            //         },
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             const Text(
            //               'Предложить услугу',
            //               style: TextStyle(fontSize: 13),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Column driverDet(data) {
    var driverName =
        data['driver']['orderInChargeName'].toString().toUpperCase();
    // var driverPhoneNumber = data['driver']['orderInChargePhone'];

    var companyName = data['companyName'].toString().toUpperCase();
    // var componyPhoneNumber = data['companyPhone'];

    var brand = data['car']['brandNameRu'].toString().toUpperCase();
    var model = data['car']['modelNameRu'].toString().toUpperCase();

    var pnum = data['car']['carNumber'].toString().toUpperCase();

    var carTypeName = data['car']['carTypeNameRu'].toString().toUpperCase();
    var year = data['car']['modelYear'];
    var tonna = data['car']['carWeight'];

    var carDet1 = '${brand} ${model} ';
    var carDet2 = '${pnum} ${year}Г';
    var carDet3 = '${carTypeName} ${tonna}T';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Перевозчик',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(height: 5),
        Column(
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, //горизонтально
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // вертикально
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driverName + ' - ' + companyName,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 5),
                            SizedBox(
                              // width: 180,
                              child: Text(
                                carDet1,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              carDet2,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              carDet3,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
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
      buttons: [
        DialogButton(
          onPressed: () async {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderHistory(),
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
      desc: AppLocalizations.of(context)!.vyUzheZavershiliZakaz,
      buttons: [
        DialogButton(
          onPressed: () async {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderHistory(),
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
