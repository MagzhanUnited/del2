import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:themoviedb/controllers/location_controller.dart';
import 'package:themoviedb/providers/provider.dart';
import 'package:themoviedb/ui/widgets/app/my_app.dart';
import 'package:themoviedb/ui/widgets/app/my_app_model.dart';

void main() async {
  LocationController locationController = Get.put(LocationController());

  WidgetsFlutterBinding.ensureInitialized();

  await Permission.location.request();
  await Permission.notification.request();

  if (Platform.isIOS) {
    await Permission.camera.request();
    requestCameraPermission();
  }

  requestLocationPermission();
  requestNotificationPermission();

  final model = MyAppModel();
  await model.checkAuth();
  final app = MyApp(model: model);
  final widget = Provider(model: model, child: app);
  runApp(widget);
  locationController.main1(locationController);
}

Future<void> requestCameraPermission() async {
  final status = await Permission.camera.request();

  if (status == PermissionStatus.granted) {
    print('camera Permission Granted');
  } else if (status == PermissionStatus.denied) {
    print('camera Permission denied');
  } else if (status == PermissionStatus.permanentlyDenied) {
    print('camera Permission Permanently Denied');
    await openAppSettings();
  }
}

Future<void> requestLocationPermission() async {
  final status = await Permission.locationWhenInUse.request();

  if (status == PermissionStatus.granted) {
    print('locationWhenInUse Permission Granted');
  } else if (status == PermissionStatus.denied) {
    print('locationWhenInUse Permission denied');
  } else if (status == PermissionStatus.permanentlyDenied) {
    print('locationWhenInUse Permission Permanently Denied');
    await openAppSettings();
  }
}

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;
  if (status.isDenied) {
    final result = await Permission.notification.request();
    final isPermanentlyDenied = result.isPermanentlyDenied;
    if (result.isGranted) {
      print('notification Permission Granted');
    } else if (isPermanentlyDenied) {
      openAppSettings();
      print('notification Permission Permanently Denied');
    }
  } else if (status.isGranted) {
    print('notification Permission Granted');
  }
}
