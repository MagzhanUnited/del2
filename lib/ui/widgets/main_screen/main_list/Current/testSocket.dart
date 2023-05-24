import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:list_tile_switch/list_tile_switch.dart';

import 'package:geolocator/geolocator.dart';

class TestSocket extends StatefulWidget {
  const TestSocket({Key? key}) : super(key: key);

  @override
  State<TestSocket> createState() => _TestSocketState();
}

bool _start = false;
int qqq = 0;
Timer? timer;

class _TestSocketState extends State<TestSocket> {
  @override
  void initState() {
    _start = false;
    socket = null;
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Socket? socket = null;
  void main() async {
    try {
      if (socket == null) {
        socket = await Socket.connect('185.116.193.86', 8088);
        print(
            'Connected to: ${socket!.remoteAddress.address}:${socket!.remotePort}');
        socket!.listen(
          (Uint8List data) {
            final serverResponse = String.fromCharCodes(data);
            print('Server: $serverResponse');
          },

          onError: (error) {
            print(error);
            socket!.destroy();
            socket = null;
            setState(() {});
          },

          // handle server ending connection
          onDone: () {
            socket = null;
            print('Server left.');
            socket!.destroy();
            setState(() {});
          },
        );
      }

      await sendMessage(socket!, 'Banana');
    } catch (e) {
      socket = null;
      print('socket error ' + e.toString());
    }
  }

  Future<void> sendMessage(Socket socket, String message) async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      var temp = '${value.latitude}/${value.longitude}/${81}/carnet';

      try {
        socket.write(temp);

        print('Client: $temp');
      } catch (e) {
        print("sendMessage ERROR " + e.toString());
      }
    });

    // await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Test Socket',
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          automaticallyImplyLeading: true,
        ),
        body: Center(
            child: Column(
          children: [
            ListTileSwitch(
              value: _start,
              leading:
                  _start ? Icon(Icons.location_on) : Icon(Icons.location_off),
              onChanged: (value) {
                _start = value;

                if (_start) {
                  timer = Timer.periodic(
                      Duration(seconds: 10), (Timer t) => main());

                  print('Connect');
                } else {
                  try {
                    socket!.flush();
                    socket!.destroy();
                    socket = null;

                    timer?.cancel();
                    print('Disconnect');
                    setState(() {});
                  } catch (e) {
                    print("Disconnect error ${e.toString()}");
                  }
                }

                setState(() {});
              },
              switchActiveColor: Colors.teal,
              switchScale: 1,
              switchType: SwitchType.cupertino,
              title: Text(
                !_start
                    ? 'начать делиться местоположением'
                    : "прекратить делиться местоположением",
              ),
            ),
            SizedBox(height: 20),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                print(Theme.of(context).platform);
                print('My Location');

                Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high);
                print(position.latitude.toString() +
                    " " +
                    position.longitude.toString());
              },
              child: Text('My Location'),
            ),
          ],
        )),
      ),
    );
  }
}

// Future<Position> _determinePosition() async {
//   bool serviceEnabled;
//   LocationPermission permission;
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     return Future.error('Location services are disabled.');
//   }

//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       return Future.error('Location permissions are denied');
//     }
//   }

//   if (permission == LocationPermission.deniedForever) {
//     return Future.error(
//         'Location permissions are permanently denied, we cannot request permissions.');
//   }

//   return await Geolocator.getCurrentPosition();
// }
