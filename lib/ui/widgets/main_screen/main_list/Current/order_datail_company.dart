// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:themoviedb/Theme/app_colors.dart';
// import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
// import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';

// class Order extends StatefulWidget {
//   Order({Key? key}) : super(key: key);

//   @override
//   _OrderState createState() => _OrderState();
// }

// class _OrderState extends State<Order> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// /// This is the private State class that goes with MyStatefulWidget.
// class OrderDetailCompany extends StatefulWidget {
//   final dynamic jdata;
//   _MyStatefulWidgetState({
//     required this.jdata,
//   });

//   int orderId = -1;
//   int driverId = -1;
//   int carId = -1;
//   int offerPrice = -1;

//   dropDown1() {
//     List<String> drivers = [];
//     String testD = '';
//     for (var item in myDrivers) {
//       var value = '${item['firstName']} ${item['lastName']} ${item['iin']}';
//       drivers.add(value);
//       testD = value;
//     }

//     final sugars = drivers;
//     String? _currentSugars = testD;
//     return DropdownButtonFormField<String>(
//       isExpanded: true,
//       value: _currentSugars,
//       items: sugars.map((sugar) {
//         return DropdownMenuItem(
//           value: sugar,
//           child: Text(
//             '$sugar',
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontWeight: FontWeight.normal,
//               fontSize: 14,
//               color: Colors.blueGrey,
//             ),
//           ),
//         );
//       }).toList(),
//       onChanged: (val) => setState(() {
//         _currentSugars = val;
//         print(_currentSugars);
//         int ind = sugars.indexOf(_currentSugars.toString());
//         print(ind);
//         print(myDrivers[ind]['clientId']);
//         driverId = myDrivers[ind]['clientId'];
//       }),
//     );
//   }

//   dropDown2() {
//     List<String> cars = [];
//     String testD = '';
//     for (var item in myCars) {
//       var value =
//           '${item['brandId']} ${item['modelId']} ${item['modelYear']} ${item['carNumber']}';
//       cars.add(value);
//       testD = value;
//     }

//     final sugars = cars;
//     String? _currentSugars = testD;
//     return DropdownButtonFormField<String>(
//       isExpanded: true,
//       value: _currentSugars,
//       items: sugars.map((sugar) {
//         return DropdownMenuItem(
//           value: sugar,
//           child: Text(
//             '$sugar',
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontWeight: FontWeight.normal,
//               fontSize: 14,
//               color: Colors.blueGrey,
//             ),
//           ),
//         );
//       }).toList(),
//       onChanged: (val) => setState(() {
//         _currentSugars = val;
//         print(_currentSugars);
//         int ind = sugars.indexOf(_currentSugars.toString());
//         print(ind);
//         print(myCars[ind]['carId']);
//         carId = myCars[ind]['carId'];
//       }),
//     );
//   }

//   bool isChecked1 = true;
//   bool isChecked2 = true;
//   String isEmpWidget = '';

//   @override
//   Widget build(BuildContext context) {
//     // print(widget.jdata);

//     final pm = ProfileModel();
//     pm.setupLocale(context);

//     var data = widget.jdata;

//     //Сохраняем номер заказаы
//     orderId = data['orderId'];
//     driverId = myDrivers[0]['clientId'];
//     carId = myCars[0]['carId'];
//     offerPrice = data['bookerOfferPrice'];

//     var formatted = data['tripDate'];

//     int carType = data['carTypeId'];
//     final sugars = ['Тент', 'Холодильник'];

//     // int carType1 = data['carTypeId'];
//     // final payType = ['Наличный', 'Без наличный'];

//     final lugDesk = TextEditingController(text: data['orderName']);
//     final lugWeigth = TextEditingController(text: data['lugWeight'].toString());
//     final lugKub = TextEditingController(text: data['lugSize'].toString());
//     final carT = TextEditingController(text: sugars[carType - 1]);
//     final lugDate = TextEditingController(text: formatted);
//     final money = TextEditingController(text: "${data['bookerOfferPrice']} тг");
//     TextEditingController offerPriceField = TextEditingController();
//     // final cashType = TextEditingController(text: payType[carType1 - 1]);

//     Color getColor(Set<MaterialState> states) {
//       const Set<MaterialState> interactiveStates = <MaterialState>{
//         MaterialState.pressed,
//         MaterialState.hovered,
//         MaterialState.focused,
//       };
//       if (states.any(interactiveStates.contains)) {
//         return Colors.blue;
//       }
//       return Colors.red;
//     }

//     final textStyle = const TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 14,
//       color: Colors.blueGrey,
//     );
//     final textFieldDecorator = const InputDecoration(
//         border: OutlineInputBorder(),
//         focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.blue, width: 1)),
//         contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         isCollapsed: true);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Детали груза',
//           style: TextStyle(
//             // color: Colors.grey,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Груз',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   color: Colors.blueGrey,
//                 ),
//               ),
//               // SizedBox(height: 5),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       isEmpWidget,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 10,
//                         color: Colors.red,
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       'Описание груза *',
//                       style: textStyle,
//                     ),
//                     SizedBox(height: 5),
//                     TextField(
//                       enabled: false,
//                       decoration: textFieldDecorator,
//                       controller: lugDesk,
//                       inputFormatters: <TextInputFormatter>[
//                         FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
//                       ],
//                       textInputAction: TextInputAction.next,
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       'Вес груза(тонна) *',
//                       style: textStyle,
//                     ),
//                     SizedBox(height: 5),
//                     TextField(
//                       enabled: false,
//                       controller: lugWeigth,
//                       decoration: textFieldDecorator,
//                       inputFormatters: <TextInputFormatter>[
//                         FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//                       ],
//                       textInputAction: TextInputAction.next,
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       'Объем(м3)',
//                       style: textStyle,
//                     ),
//                     SizedBox(height: 5),
//                     TextField(
//                       enabled: false,
//                       controller: lugKub,
//                       decoration: textFieldDecorator,
//                       inputFormatters: <TextInputFormatter>[
//                         FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//                       ],
//                       textInputAction: TextInputAction.next,
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       'Опасный груз ',
//                       style: textStyle,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Checkbox(
//                           checkColor: Colors.white,
//                           fillColor:
//                               MaterialStateProperty.resolveWith(getColor),
//                           shape: CircleBorder(),
//                           value: isChecked2,
//                           onChanged: (bool? value) {
//                             // setState(() {
//                             //   isChecked2 = value!;
//                             //   isChecked1 = false;
//                             //   // notCkecked = '';
//                             //   // print(isChecked2);
//                             // });
//                           },
//                         ),
//                         data['isDanger'] == 1
//                             ? Text('да', style: textStyle)
//                             : Text('Нет', style: textStyle),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       'Тип транспорта',
//                       style: textStyle,
//                     ),
//                     SizedBox(height: 5),
//                     TextField(
//                       enabled: false,
//                       controller: carT,
//                       decoration: textFieldDecorator,
//                       inputFormatters: <TextInputFormatter>[
//                         FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//                       ],
//                       textInputAction: TextInputAction.next,
//                     ),
//                     SizedBox(height: 5),
//                   ],
//                 ),
//               ),
//               Text(
//                 'Маршрут',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   color: Colors.blueGrey,
//                 ),
//               ),
//               SizedBox(height: 5),
//               Column(
//                 children: [
//                   Card(
//                     elevation: 5,
//                     child: Padding(
//                       padding: EdgeInsets.all(10.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Row(
//                             children: [
//                               Text(
//                                 ' A',
//                                 style: TextStyle(
//                                   fontSize: 14.0,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               SizedBox(width: 10.0),
//                               Text(
//                                 // filteredData[index].email.toLowerCase(),
//                                 data['beginPointName'],
//                                 style: TextStyle(
//                                   fontSize: 14.0,
//                                   color: Colors.black,
//                                 ),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.fade,
//                               ),
//                             ],
//                           ),
//                           Divider(
//                             color: Colors.grey,
//                             height: 10,
//                           ),
//                           //машрут точка Б
//                           Row(
//                             children: [
//                               Text(
//                                 ' B',
//                                 style: TextStyle(
//                                   fontSize: 14.0,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               SizedBox(width: 10.0),
//                               Text(
//                                 // filteredData[index].email.toLowerCase(),
//                                 data['endPointName'],
//                                 style: TextStyle(
//                                   fontSize: 14.0,
//                                   color: Colors.black,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.fade,
//                               ),
//                             ],
//                           ),
//                           // SizedBox(height: 20),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               ElevatedButton(
//                                 onPressed: () {
                                  
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.location_on),
//                                     const Text('Маршут',
//                                         style: TextStyle(fontSize: 13)),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Text(
//                 'Грузоотправитель',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   color: Colors.blueGrey,
//                 ),
//               ),
//               SizedBox(height: 5),
//               Column(
//                 children: [
//                   Card(
//                     elevation: 5,
//                     child: Padding(
//                       padding: EdgeInsets.all(10.0),
//                       child: Column(
//                         children: <Widget>[
//                           Row(
//                             mainAxisAlignment:
//                                 MainAxisAlignment.start, //горизонтально
//                             crossAxisAlignment:
//                                 CrossAxisAlignment.start, // вертикально
//                             children: [
//                               Column(
//                                 children: [
//                                   CircleAvatar(
//                                     radius: 40,
//                                     backgroundImage: NetworkImage(
//                                         'https://img.freepik.com/free-photo/young-handsome-man-with-beard-over-isolated-keeping-the-arms-crossed-in-frontal-position_1368-132662.jpg?size=626&ext=jpg'),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(width: 10),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Text(
//                                         '${data['creator']['lastName']} ${data['creator']['firstName']}',
//                                         style: TextStyle(
//                                           fontSize: 13.0,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                       SizedBox(width: 10),
//                                       Row(
//                                         children: [
//                                           Icon(
//                                             Icons.star_rounded,
//                                             color: AppColors.mainOrange,
//                                             size: 13,
//                                           ),
//                                           Text(
//                                             '5.0',
//                                             style: TextStyle(
//                                               fontSize: 13.0,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.black,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Text(
//                 'Дата',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   color: Colors.blueGrey,
//                 ),
//               ),
//               SizedBox(height: 5),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     TextField(
//                       enabled: false,
//                       decoration: textFieldDecorator,
//                       controller: lugDate,
//                       inputFormatters: <TextInputFormatter>[
//                         FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
//                       ],
//                       textInputAction: TextInputAction.next,
//                     ),
//                     SizedBox(height: 5),
//                   ],
//                 ),
//               ),
//               Text(
//                 'Оплата',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   color: Colors.blueGrey,
//                 ),
//               ),
//               SizedBox(height: 5),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 5),
//                     Text(
//                       'Сумма клиента',
//                       style: textStyle,
//                     ),
//                     TextField(
//                       enabled: false,
//                       decoration: textFieldDecorator,
//                       controller: money,
//                       inputFormatters: <TextInputFormatter>[
//                         FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
//                       ],
//                       textInputAction: TextInputAction.next,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 5),
//               Text(
//                 'Ваше предложение цены',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   color: Colors.deepOrange,
//                 ),
//               ),
//               SizedBox(height: 5),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 5),
//                     Text(
//                       'Ваша сумма',
//                       style: textStyle,
//                     ),
//                     TextField(
//                       decoration: textFieldDecorator,
//                       controller: offerPriceField,
//                       keyboardType: TextInputType.number,
//                       textInputAction: TextInputAction.next,
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       'Водитель',
//                       style: textStyle,
//                     ),
//                     dropDown1(),
//                     SizedBox(height: 20),
//                     Text(
//                       'Авто',
//                       style: textStyle,
//                     ),
//                     dropDown2(),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 70, vertical: 20)),
//                       onPressed: () {
//                         offerPrice = offerPriceField.text == ''
//                             ? int.parse(offerPriceField.text)
//                             : data['bookerOfferPrice'];
//                         print(orderId);
//                         print(driverId);
//                         print(carId);
//                         print(offerPrice);

//                         dynamic orderData = {
//                           "orderId": orderId,
//                           "driverId": driverId,
//                           "carId": carId,
//                           "offerPrice": offerPrice
//                         };

//                         SendOrderRequest(
//                           token: pm.token.toString(),
//                           jdata: orderData,
//                         ).send().then(
//                           (value) {
//                             print('Response: $value');
//                             if (value != 'error') {
//                               print('Удача! $value');
//                             } else {
//                               print('Не удалось отправить заявку на услугу');
//                             }
//                           },
//                         );
//                       },
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             'Предложить услугу',
//                             style: TextStyle(fontSize: 13),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     throw UnimplementedError();
//   }
// }
