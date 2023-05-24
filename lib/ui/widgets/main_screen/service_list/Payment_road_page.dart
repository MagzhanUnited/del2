import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PaymentRoadView extends StatefulWidget {
  const PaymentRoadView({Key? key}) : super(key: key);

  @override
  _PaymentRoadViewState createState() => _PaymentRoadViewState();
}

// bool _isPressed = false;

class _PaymentRoadViewState extends State<PaymentRoadView> {
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('ws://185.116.193.86:8081/ws'),
  );

  // @override
  // void initState() {
  //   _isPressed = false;
  //   super.initState();
  // }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  // void _myCallback() {
  //   setState(() {
  //     _isPressed = true;
  //   });

  //   Timer(Duration(seconds: 1), () {
  //     setState(() {
  //       _isPressed = false;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Платные дороги'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? '${snapshot.data} ' : '');
              },
            ),
            Icon(
              Icons.construction_outlined,
              size: 100,
            ),
            ElevatedButton(
              // onPressed: _isPressed == false ? _myCallback : null,
              onPressed: () {
                _channel.sink.add('87071686899');
              },
              child: const Text('Сервис находится в разработке'),
            ),
          ],
        ),
      ),
    );
  }
}
