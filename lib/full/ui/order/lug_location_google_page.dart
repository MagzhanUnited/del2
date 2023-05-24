// import 'package:flutter/material.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:flutter_map/flutter_map.dart';

// class GoogpleMapsView extends StatefulWidget {
//   GoogpleMapsView({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _GoogpleMapsViewState createState() => _GoogpleMapsViewState();
// }

// class _GoogpleMapsViewState extends State<GoogpleMapsView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Местоположение груза',
//           style: TextStyle(
//             // color: Colors.grey,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: new FlutterMap(
//         options: new MapOptions(
//           center: new LatLng(40.71, -74.00),
//           minZoom: 10.0,
//         ),
//         layers: [
//           new TileLayerOptions(
//             urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//             subdomains: ['a', 'b', 'c'],
//           ),
//           new MarkerLayerOptions(
//             markers: [
//               new Marker(
//                 width: 45.0,
//                 height: 45.0,
//                 point: new LatLng(40.71, -74.00),
//                 builder: (context) => new Container(
//                   child: IconButton(
//                     icon: Icon(Icons.location_on),
//                     color: Colors.red,
//                     iconSize: 45.0,
//                     onPressed: () {
//                       print('Marker tapped');
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
