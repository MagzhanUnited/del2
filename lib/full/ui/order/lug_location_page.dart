import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';


class LugLocationView extends StatefulWidget {
  LugLocationView({
    Key? key,
  }) : super(key: key);

  @override
  _LugLocationViewState createState() => _LugLocationViewState();
}

class _LugLocationViewState extends State<LugLocationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Местоположение груза',
          style: TextStyle(
            // color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: new FlutterMap(
        options: new MapOptions(
          center: new LatLng(51.128253, 71.430545),
          minZoom: 10.0,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 45.0,
                height: 45.0,
                point: new LatLng(51.123809, 71.433050),
                builder: (context) => new Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 45.0,
                    onPressed: () {
                      print('Marker tapped');
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
