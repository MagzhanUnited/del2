import 'dart:async';
import 'package:flutter/material.dart';

class Epl extends StatefulWidget {
  const Epl({Key? key}) : super(key: key);

  @override
  _EplState createState() => _EplState();
}

bool _isPressed = false;

class _EplState extends State<Epl> {
  @override
  void initState() {
    _isPressed = false;
    super.initState();
  }

  void _myCallback() {
    setState(() {
      _isPressed = true;
    });

    Timer(Duration(seconds: 1), () {
      setState(() {
        _isPressed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('е-ПЛ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_outlined,
              size: 100,
            ),
            ElevatedButton(
              onPressed: _isPressed == false ? _myCallback : null,
              child: const Text('Сервис находится в разработке'),
            ),
          ],
        ),
      ),
    );
  }
}
