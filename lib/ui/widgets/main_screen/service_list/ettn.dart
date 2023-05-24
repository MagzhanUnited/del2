import 'dart:async';
import 'package:flutter/material.dart';

class Ettn extends StatefulWidget {
  const Ettn({Key? key}) : super(key: key);

  @override
  _EttnState createState() => _EttnState();
}

bool _isPressed = false;

class _EttnState extends State<Ettn> {
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
        title: const Text('е-ТТН'),
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
