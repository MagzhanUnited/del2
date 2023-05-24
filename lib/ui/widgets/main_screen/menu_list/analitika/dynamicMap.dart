import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';

class DynamicMap extends StatefulWidget {
  final dynamic dataNew;
  const DynamicMap({required this.dataNew, Key? key}) : super(key: key);

  @override
  State<DynamicMap> createState() => _DynamicMapState();
}

class _DynamicMapState extends State<DynamicMap> {
  List<TaggedPolyline> data = [];

  final lines = [
    [
      [51.165815, 71.443727, 1005],
      [43.238591, 76.902995, 208]
    ],
    [
      [49.812797, 73.106461, 218],
      [50.433691, 80.241210, 241]
    ],
    [
      [42.357009, 69.580893, 218],
      [47.111377, 51.876565, 241]
    ]
  ];

  List<LatLng> getPoints(int index) {
    return lines[index]
        .map((e) => LatLng(e[0] as double, e[1] as double))
        .toList();
  }

  @override
  void initState() {
    // print('------------object' + widget.dataNew.toString());

    for (var item in widget.dataNew) {
      var Bpp = item['beginPoint'].toString().split(',');
      var Epp = item['endPoint'].toString().split(',');

      Color c = item['transportCount'] >= 5
          ? Colors.red
          : item['transportCount'] >= 6
              ? Colors.orange
              : Colors.green;

      var rPoints = {
        LatLng(double.parse(Bpp[0]), double.parse(Bpp[1])),
        LatLng(double.parse(Epp[0]), double.parse(Epp[1])),
      };

      var temp = TaggedPolyline(
        tag: '${item['beginCityName']} - ${item['endCityName']}',
        points: rPoints.toList(),
        color: c,
        // borderColor: Colors.cyan,
        // borderStrokeWidth: 10.0,
        strokeWidth: 4.0,
      );

      data.add(temp);
    }

    // var aa = getPoints(0);

    // data = [
    //   TaggedPolyline(
    //     tag: 'Астана - Алматы',
    //     points: aa,
    //     color: Colors.red,
    //     // borderColor: Colors.cyan,
    //     // borderStrokeWidth: 10.0,
    //     strokeWidth: 4.0,
    //   ),
    //   TaggedPolyline(
    //     tag: 'Караганды - Семей',
    //     points: getPoints(1),
    //     color: Colors.green,
    //     strokeWidth: 4.0,
    //   ),
    //   TaggedPolyline(
    //     tag: 'Шымкент - Атырау',
    //     points: getPoints(2),
    //     color: Colors.orange,
    //     strokeWidth: 4.0,
    //   ),
    // ];

    setPolylines(
        PointLatLng(43.886429, 76.569222), PointLatLng(51.031391, 72.042855));
    super.initState();
  }

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyAkUdrVbgXV_52Qrid_vdeqzTbBfmFxrNM";

  dynamic setPolylines(PointLatLng A, PointLatLng B) {
    polylineCoordinates = [];

    polylinePoints.getRouteBetweenCoordinates(googleAPIKey, A, B).then(
          (result) => {
            if (result.points.isNotEmpty)
              {
                result.points.forEach(
                  (PointLatLng point) {
                    polylineCoordinates
                        .add(LatLng(point.latitude, point.longitude));
                  },
                )
              }
          },
        );
    print(polylineCoordinates.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Динамическая карта'),
      ),
      body: FlutterMap(
        options: MapOptions(
          plugins: [
            TappablePolylineMapPlugin(),
          ],
          center: LatLng(43.604411, 66.596639),
          zoom: 3.65,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          TappablePolylineLayerOptions(
            // Will only render visible polylines, increasing performance
            polylineCulling: true,
            pointerDistanceTolerance: 20,
            polylines: data,
            onTap: (polylines, tapPosition) {
              // print(
              //     'Tapped: ${polylines.map((polyline) => polyline.tag).join(',')} at ${tapPosition.globalPosition.toString()}');
              detail(
                  context,
                  polylines.map((polyline) => polyline.tag).join(','),
                  tapPosition.globalPosition.toString());
            },
            onMiss: (tapPosition) {
              // print('No polyline was tapped at position ' +
              //     tapPosition.globalPosition.toString());
            },
          )
        ],
      ),
    );
  }

  void detail(BuildContext context, String name, String position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final textStyle = const TextStyle(
          fontSize: 16,
          color: Color(0xff212529),
        );
        return AlertDialog(
          title: Text('Данные'),
          content: Container(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  Text('Направление: ' + name, style: textStyle),
                  SizedBox(height: 10),
                  Text('Координата: ' + position, style: textStyle),
                  SizedBox(height: 10),
                  Text('Самые доставляемые грузы: Металл, Зерновые грузы',
                      style: textStyle),
                  SizedBox(height: 10),
                  Text('Популярные Авто: КамАЗ 43114 (10)', style: textStyle),
                  SizedBox(height: 10),
                  Text('Топ перевозчики: Дәулет Мұқаев (20)', style: textStyle),
                ],
              ),
            ),
          ),
          // elevation: 24,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Закрыть',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// class _DynamicMapState extends State<DynamicMap> {
//   MapType _currentMapType = MapType.normal;
//   Set<Polyline> _polyline = {};
//   LatLng _lastMapPosition = LatLng(43.886429, 76.569222);
//   List<LatLng> latlng = [
//     LatLng(43.886429, 76.569222),
//     LatLng(51.031391, 72.042855),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     _polyline.add(
//       Polyline(
//         onTap: () {
//           print(_lastMapPosition.latitude);
//           print('click');
//         },
//         polylineId: PolylineId(_lastMapPosition.toString()),
//         visible: true,
//         //latlng is List<LatLng>
//         points: latlng,
//         color: Colors.blue,
//       ),
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Динамическая карта'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         automaticallyImplyLeading: true,
//       ),
//       body: Stack(
//         children: <Widget>[
//           GoogleMap(
//             zoomControlsEnabled: false, //кнопки + -
//             zoomGesturesEnabled: true, // увелечение двумя пальцами
//             mapToolbarEnabled: true, //доп функции в виде кнопки маршрута
//             trafficEnabled: false, //траффик дороги
//             tiltGesturesEnabled: true, //  жесты наклона.
//             scrollGesturesEnabled: true, //  жесты прокрутки.
//             rotateGesturesEnabled: false, //   жесты поворота.
//             // myLocationEnabled: true,
//             mapType: _currentMapType,
//             // onMapCreated: _onMapCreated,
//             initialCameraPosition: const CameraPosition(
//                 target: LatLng(49.056246, 66.857308), zoom: 3.6),
//             polylines: _polyline,
//             // markers: _markers.values.toSet(),
//           ),
//         ],
//       ),
//     );
//   }
// }

