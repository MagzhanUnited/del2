import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:geolocator/geolocator.dart';
import 'package:get/state_manager.dart';

class LocationController extends GetxController {
  final socket = Rxn<Socket>();
  final start = false.obs;
  final carId = 0.obs;
  void main1(LocationController locationController) async {
    try {
      if (locationController.socket.value == null) {
        locationController.socket.value =
            await Socket.connect('185.116.193.86', 8088);
        print(
            'Connected to: ${locationController.socket.value!.remoteAddress.address}:${locationController.socket.value!.remotePort}');
        locationController.socket.value!.listen(
          (Uint8List data) {
            final serverResponse = String.fromCharCodes(data);
            print('Server: $serverResponse');
          },

          onError: (error) {
            print(locationController.socket.value);
            print(error);
            locationController.socket.value!.destroy();
            locationController.socket.value = null;
            // setState(() {});
          },

          // handle server ending connection
          onDone: () {
            locationController.socket.value = null;
            print('Server left.');
            // locationController.socket.value!.destroy();
            // setState(() {});
          },
        );
      }

      if (locationController.start.value) {
        await sendMessage(locationController.socket.value!);
      }
    } catch (e) {
      locationController.socket.value = null;
      print('socket error ' + e.toString());
    }
  }

  Future<void> sendMessage(Socket socket) async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      var temp = '${value.latitude}/${value.longitude}/${carId}/carnet';

      try {
        socket.write(temp);

        print('Client: $temp');
      } catch (e) {
        print("sendMessage ERROR " + e.toString());
      }
    });
    // await Future.delayed(Duration(seconds: 1));
  }

  void timeStart(LocationController locationController) {
    if (start.value) {
      Timer.periodic(
        Duration(seconds: 10),
        (Timer t) => locationController.main1(locationController),
      );
    }
  }
}
