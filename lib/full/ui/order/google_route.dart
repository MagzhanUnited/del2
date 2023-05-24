import 'dart:convert';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';

class ad extends StatefulWidget {
  const ad({Key? key}) : super(key: key);

  @override
  _adState createState() => _adState();
}

class _adState extends State<ad> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// void main() => runApp(MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MapPage(),
//     ));

const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 20;
LatLng SOURCE_LOCATION = LatLng(42.7477863, -71.1699932);
LatLng DEST_LOCATION = LatLng(42.6871386, -71.2143403);

class MapPage extends StatefulWidget {
  final List<String> coord1;
  final List<String> coord2;
  final int orderStatusId;
  final int carId;

  const MapPage({
    Key? key,
    required this.coord1,
    required this.coord2,
    required this.orderStatusId,
    required this.carId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  // this set will hold my markers
  Set<Marker> _markers = {};
  // this will hold the generated polylines
  Set<Polyline> _polylines = {};
  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
  // this is the key object - the PolylinePoints
  // which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyAkUdrVbgXV_52Qrid_vdeqzTbBfmFxrNM";
  // for my custom icons
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;

  List data = [];
  final pm = ProfileModel();

  @override
  void initState() {
    if (widget.orderStatusId == 3)
      pm.setupLocale(context).then(
        (value) async {
          await locationLoad(
            token: pm.token.toString(),
            carId: widget.carId,
          ).getList().then(
            (value) {
              if (value.toString() == '401') {
                final provider = SessionDataProvider();
                provider.setSessionId(null);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    MainNavigationRouteNames.changeLang,
                    (Route<dynamic> route) => false);
              }

              if (value != 'error') {
                var docs = json.decode(value);

                print('locationLoad Sucsess ${docs.length}');

                _markers.add(Marker(
                    markerId: MarkerId('sourcePin123'),
                    position: LatLng(
                        double.parse(docs['lat']), double.parse(docs['lan'])),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueOrange)));

                setState(() {});
              } else {
                print('locationLoad Error');
              }
            },
          );
        },
      );

    super.initState();
    setSourceAndDestinationIcons();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.defaultMarker;
    destinationIcon = await BitmapDescriptor.defaultMarker;
  }

  @override
  Widget build(BuildContext context) {
    SOURCE_LOCATION = LatLng(
        double.parse(widget.coord1.first), double.parse(widget.coord1.last));
    DEST_LOCATION = LatLng(
        double.parse(widget.coord2.first), double.parse(widget.coord2.last));

    CameraPosition initialLocation = CameraPosition(
        zoom: CAMERA_ZOOM,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        target: SOURCE_LOCATION);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Маршрут',
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: true,
      ),
      body: GoogleMap(
          zoomControlsEnabled: true, //кнопки + -
          zoomGesturesEnabled: true, // увелечение двумя пальцами
          mapToolbarEnabled: true, //доп функции в виде кнопки маршрута
          trafficEnabled: false, //траффик дороги
          tiltGesturesEnabled: true, //  жесты наклона.
          scrollGesturesEnabled: true, //  жесты прокрутки.
          rotateGesturesEnabled: true, //   жесты поворота.
          myLocationEnabled: true,
          markers: _markers,
          polylines: _polylines,
          mapType: MapType.terrain,
          initialCameraPosition: initialLocation,
          onMapCreated: onMapCreated),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(Utils.mapStyles);
    _controller.complete(controller);
    setMapPins();
    setPolylines();
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: SOURCE_LOCATION,
          icon: sourceIcon!));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: DEST_LOCATION,
          icon: destinationIcon!));
    });
  }

  setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude),
      PointLatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude),
    );
    if (result.points.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // create a Polyline instance
    // with an id, an RGB color and the list of LatLng pairs
    Polyline polyline = Polyline(
      polylineId: PolylineId("poly"),
      width: 2,
      color: Color.fromARGB(255, 40, 122, 198),
      points: polylineCoordinates,
    );

    // add the constructed polyline as a set of points
    // to the polyline set, which will eventually
    // end up showing up on the map
    _polylines.add(polyline);

    setState(() {});
  }
}

class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}
