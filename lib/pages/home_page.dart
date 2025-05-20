import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_place/google_place.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vanick/network/query.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MapScreenState();
}

class _MapScreenState extends State<HomePage> {
  late GoogleMapController mapController;

  double? originLatitude, originLongitude;
  double? destLatitude , destLongitude;

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyAZOhKQaJLCH21qg0rzizsayymN_zcc1Sg";

  List<Map<String, dynamic>> suggestedPlaces = [
    {"name": "Nairobi CBD", "location": LatLng(1.2921, 36.8219)},
    {"name": "Westlands", "location": LatLng(1.2677, 36.8110)},
    {"name": "Karen", "location": LatLng(1.3171, 36.7192)},
    {"name": "JKIA Airport", "location": LatLng(-1.3192, 36.9258)},
    {"name": "Thika Road Mall", "location": LatLng(1.2040, 36.8887)},
    {"name": "Galleria Mall", "location": LatLng(1.3321, 36.7073)},
    {"name": "Ngong Hills", "location": LatLng(1.3580, 36.6540)},
    {"name": "Two Rivers Mall", "location": LatLng(1.2195, 36.8042)},
  ];

  TextEditingController searchController = TextEditingController();
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    await Permission.location.request();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    setState(() {
      originLatitude = position.latitude;
      originLongitude = position.longitude;
      destLongitude = position.latitude;
      destLongitude = position.longitude;
    });

    _startLocationUpdates();
    _updateRoute();
  }

  void _startLocationUpdates() {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        originLatitude = position.latitude;
        originLongitude = position.longitude;
      });
      _updateRoute();
    });
  }

  Future<void> _updateRoute() async {
    if (originLatitude == null || originLongitude == null) return;

    polylineCoordinates.clear();
    polylines.clear();
    markers.clear();

    _addMarker(LatLng(originLatitude!, originLongitude!), "origin", BitmapDescriptor.defaultMarker);
    _addMarker(LatLng(destLatitude!, destLongitude!), "destination", BitmapDescriptor.defaultMarkerWithHue(90));

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleAPiKey,
      request: PolylineRequest(
      origin: PointLatLng(originLatitude!, originLongitude!),
      destination: PointLatLng(destLatitude!, destLongitude!),
      mode: TravelMode.driving,
      )
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      _addPolyLine();
    }

    setState(() {});
  }

  void _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  void _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }


  Future<void> getNewRoute(String place) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Searching for $place...")),
    );

    try {
      LatLng position = await getPosition(place,context);

      setState(() {
        destLatitude = position.latitude;
        destLongitude = position.longitude;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New coordinates: $destLatitude, $destLongitude')),
      );

      _updateRoute();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get coordinates: $e')),
      );
    }
  }




  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Suggested Places", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: suggestedPlaces.length,
                itemBuilder: (context, index) {
                  final place = suggestedPlaces[index];
                  return ListTile(
                    leading: Icon(Icons.place),
                    title: Text(place['name']),
                    onTap: () {

                      LatLng loc = place['location'];
                      setState(() {
                        destLatitude = loc.latitude;
                        destLongitude = loc.longitude;
                      });
                      Navigator.pop(context);
                      _updateRoute();


                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (originLatitude == null || originLongitude == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(originLatitude!, originLongitude!),
              zoom: 14,
            ),
            myLocationEnabled: true,
            onMapCreated: (controller) => mapController = controller,
            mapType: MapType.hybrid,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          ),
          Positioned(
            top: 50,
            left: 15,
            right: 15,
            child: TextField(
              controller: searchController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search destination...',
                filled: true,
                fillColor: Colors.white,

                prefixIcon: IconButton(
    onPressed: () async {
    await  getNewRoute(searchController.text);
    },
    icon: const Icon(Icons.search)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: _showBottomSheet,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
