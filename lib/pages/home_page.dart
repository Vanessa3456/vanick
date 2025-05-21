import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:permission_handler/permission_handler.dart';

import '../network/query.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  double? originLatitude, originLongitude;
  double? destLatitude, destLongitude;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyAZOhKQaJLCH21qg0rzizsayymN_zcc1Sg";

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> suggestedPlaces = [];
  List<Map<String, dynamic>> favoritePlaces = [];
  List<String> previousStartingPoints = [];
  List<String> previousDestinations = [];

  @override
  void initState() {
    super.initState();
    _initLocation();
    _fetchSuggestedPlaces();
    _fetchFavoritePlaces();
    _fetchPreviousPoints();
  }

  Future<void> _initLocation() async {
    await Permission.location.request();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    setState(() {
      originLatitude = position.latitude;
      originLongitude = position.longitude;
      destLatitude = position.latitude;
      destLongitude = position.longitude;
    });

    _updateRoute();
  }

  Future<void> _fetchSuggestedPlaces() async {
    final snapshot = await FirebaseFirestore.instance.collection('suggested_places').get();
    setState(() {
      suggestedPlaces = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> _fetchFavoritePlaces() async {
    final snapshot = await FirebaseFirestore.instance.collection('favorite_places').get();
    setState(() {
      favoritePlaces = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> _fetchPreviousPoints() async {
    final snapshot = await FirebaseFirestore.instance.collection('previous_points').get();
    for (var doc in snapshot.docs) {
      final data = doc.data();
      setState(() {
        previousStartingPoints.add(data['starting_point']);
        previousDestinations.add(data['destination']);
      });
    }
  }

  Future<void> _updateRoute() async {
    if (originLatitude == null || originLongitude == null || destLatitude == null || destLongitude == null) return;

    polylineCoordinates.clear();
    polylines.clear();
    markers.clear();

    _addMarker(LatLng(originLatitude!, originLongitude!), "origin", BitmapDescriptor.defaultMarker);
    _addMarker(LatLng(destLatitude!, destLongitude!), "destination", BitmapDescriptor.defaultMarkerWithHue(90));

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleAPiKey,
      request: PolylineRequest(
     origin:  PointLatLng(originLatitude!, originLongitude!),
    destination:   PointLatLng(destLatitude!, destLongitude!),
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


  Future<void> _searchPlace(String place) async {
  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text("Searching for $place...")),
  );

  try {
  LatLng position = await getPosition(place,context);

  setState(() {
  destLatitude = position.latitude;
  destLongitude = position.longitude;
  });
  String? email = FirebaseAuth.instance.currentUser?.email;
  await FirebaseFirestore.instance.collection('suggested_places')
      .add({
    'name': place,
    'location': {'lat': destLatitude, 'lng': destLongitude},
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



  void _showRequestForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        String? selectedStartingPoint;
        String? selectedDestination;
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Starting Point'),
                      items: ['Current Location', ...previousStartingPoints].map((point) {
                        return DropdownMenuItem(
                          value: point,
                          child: Text(point),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedStartingPoint = value;
                        });
                      },
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Destination'),
                      items: previousDestinations.map((point) {
                        return DropdownMenuItem(
                          value: point,
                          child: Text(point),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedDestination = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedStartingPoint != null && selectedDestination != null) {
                          // Save to Firebase
                          await FirebaseFirestore.instance.collection('previous_points').add({
                            'starting_point': selectedStartingPoint,
                            'destination': selectedDestination,
                          });

                          // Update route
                          // Implement logic to get coordinates based on selected points
                          setState(() {
                            destLatitude = originLatitude! + 0.02;
                            destLongitude = originLongitude! + 0.02;
                          });

                          _updateRoute();
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Request'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: DraggableScrollableSheet(
        initialChildSize: 0.35,
        minChildSize: 0.2,
        maxChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              children: [
                Container(height: 4, width: 40, color: Colors.grey[300]),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _showRequestForm,
                  child: Text("Request a Ride"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: suggestedPlaces.length,
                    itemBuilder: (context, index) {
                      final place = suggestedPlaces[index];
                      return ListTile(
                        hoverColor: Colors.grey,
                        selectedColor: Colors.blue,

                        leading: Icon(Icons.history),
                        title: Text(place['name']),
                        trailing: IconButton(
                          icon: Icon(Icons.favorite_border),
                          onPressed: () async {
                            await FirebaseFirestore.instance.collection('favorite_places').add(place);
                            _fetchFavoritePlaces();
                          },
                        ),
                        onTap: () {
                          setState(() {
                            destLatitude = place['location']['lat'];
                            destLongitude = place['location']['lng'];
                          });
                          _updateRoute();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
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

        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        mapType: MapType.hybrid,
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of(polylines.values),
      ),
            Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search a place...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      _searchPlace(value);
                    }
                  },
                ),
              ),
            ),
            _buildBottomSheet(),
          ],
      ),
    );
  }
}
