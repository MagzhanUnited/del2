import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:themoviedb/Theme/app_colors.dart';
import 'package:themoviedb/full/ui/order/lug_location_page.dart';

class OrderDatailView extends StatefulWidget {
  final dynamic jdata;
  OrderDatailView({
    Key? key,
    required this.jdata,
  }) : super(key: key);

  @override
  _OrderDatailViewState createState() => _OrderDatailViewState();
}

class _OrderDatailViewState extends State<OrderDatailView> {
  @override
  Widget build(BuildContext context) {
    // print(widget.jdata);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Детали заказа',
          style: TextStyle(
            // color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: MyStatefulWidget(
          jdata1: widget.jdata,
        ),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  final dynamic jdata1;
  MyStatefulWidget({
    Key? key,
    required this.jdata1,
  }) : super(key: key);

  @override
  State<MyStatefulWidget> createState() =>
      _MyStatefulWidgetState(jdata: jdata1);
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final dynamic jdata;
  _MyStatefulWidgetState({
    required this.jdata,
  });

  dropDown() {
    final sugars = ['Тент', 'Холодильник'];
    String? _currentSugars = 'Тент';
    return DropdownButtonFormField<String>(
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
              color: Colors.blueGrey,
            ),
          ),
        );
      }).toList(),
      onChanged: (val) => setState(() {
        _currentSugars = val;
        print(_currentSugars);
      }),
    );
  }

  bool isChecked1 = true;
  bool isChecked2 = true;
  String isEmpWidget = '';

  @override
  Widget build(BuildContext context) {
    print(widget.jdata1);

    var data = widget.jdata1;
    var formatted = data['tripDate'];

    int carType = data['carTypeId'];
    final sugars = ['Тент', 'Холодильник'];

    int carType1 = data['carTypeId'];
    final payType = ['Наличный', 'Без наличный'];

    final lugDesk = TextEditingController(text: data['orderName']);
    final lugWeigth = TextEditingController(text: data['lugWeight'].toString());
    final lugKub = TextEditingController(text: data['lugSize'].toString());
    final carT = TextEditingController(text: sugars[carType - 1]);
    final lugDate = TextEditingController(text: formatted);
    final money = TextEditingController(text: "${data['bookerOfferPrice']} тг");
    final cashType = TextEditingController(text: payType[carType1 - 1]);

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

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Груз',
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
                    'Описание груза *',
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    decoration: textFieldDecorator,
                    controller: lugDesk,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Вес груза(тонна) *',
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: lugWeigth,
                    decoration: textFieldDecorator,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Объем(м3)',
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: lugKub,
                    decoration: textFieldDecorator,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Опасный груз ',
                    style: textStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Checkbox(
                      //   checkColor: Colors.white,
                      //   fillColor: MaterialStateProperty.resolveWith(getColor),
                      //   shape: CircleBorder(),
                      //   value: isChecked1,
                      //   onChanged: (bool? value) {
                      //     setState(() {
                      //       isChecked1 = value!;
                      //       isChecked2 = false;
                      //       // notCkecked = '';
                      //       // print(isChecked2);
                      //     });
                      //   },
                      // ),
                      // Text('Да', style: textStyle),
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        shape: CircleBorder(),
                        value: isChecked2,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked2 = value!;
                            isChecked1 = false;
                            // notCkecked = '';
                            // print(isChecked2);
                          });
                        },
                      ),
                      data['isDanger'] == 1
                          ? Text('да', style: textStyle)
                          : Text('Нет', style: textStyle),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Тип транспорта',
                    style: textStyle,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: carT,
                    decoration: textFieldDecorator,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            Text(
              'Маршрут',
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
                            Text(
                              // filteredData[index].email.toLowerCase(),
                              data['beginPointName'],
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
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
                            Text(
                              // filteredData[index].email.toLowerCase(),
                              data['endPointName'],
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
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
                                      builder: (context) => LugLocationView(),
                                    ),
                                  );
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.location_on),
                                  const Text('Местоположение груза',
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
            Text(
              'Грузоперевозчик',
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
                                  radius: 40,
                                  backgroundImage: Image.asset(
                                          'images/Portrait_Placeholder.png',
                                          fit: BoxFit.cover)
                                      .image,
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Айдынов Төлеген',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rounded,
                                          color: AppColors.mainOrange,
                                          size: 13,
                                        ),
                                        Text(
                                          '5.0',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  'Тент, 15т, 2018',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Mercedes Actros',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '01 AAA 888',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
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
            Text(
              'Дата',
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
              'Оплата',
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
                    'Сумма оплаты',
                    style: textStyle,
                  ),
                  TextField(
                    decoration: textFieldDecorator,
                    controller: money,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Тип оплаты',
                    style: textStyle,
                  ),
                  TextField(
                    decoration: textFieldDecorator,
                    controller: cashType,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 100, vertical: 20)),
                    onPressed: () {
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Позвонить',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 100, vertical: 20)),
                    onPressed: () {
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Чат',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 90, vertical: 20)),
                    onPressed: () {
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Редактировать',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 100, vertical: 20)),
                    onPressed: () {
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Отменить',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
