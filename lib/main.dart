import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'source_destintation.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: "AIzaSyCN5CJGsvRnutmMNhpN8toEprd3fn7cIBg");
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'tracking !'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription _locationSubscription;

  // Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  final Set <Marker> _markers = {};

  final Set <Polyline> _polyline = {};

  static LatLng _initialPosition;

  LatLng _lastPosition = _initialPosition;

  LatLng userPosition;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(36.752887, 3.042048),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          children: <Widget>[

            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: initialLocation,
              markers: _markers,
              polylines: _polyline,
              circles: Set.of((circle != null) ? [circle] : []),

              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },

            ),
            /* floatingActionButton: FloatingActionButton(
          child: Icon(Icons.directions_car ,  ),
          onPressed: () {
            getCurrentLocation();
          } , backgroundColor: Colors.lightGreen,),*/
            Positioned(
              top: 50.0,
              right: 15.0,
              left: 15.0,
              child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => s_d()));
                }, child: Text("lets go"),),
            ),
            FloatingActionButton(
              child: Icon(Icons.search,),
              onPressed: () async {
                // show input autocomplete with selected mode
                // then get the Prediction selected
                Prediction p = await PlacesAutocomplete.show(
                  context: context,
                  mode: Mode.overlay,
                  apiKey: "AIzaSyCN5CJGsvRnutmMNhpN8toEprd3fn7cIBg",
                  );
                 displayPrediction(p);
              }, backgroundColor: Colors.blue,),

          ],));
  }

  @override
  void initState() {
    super.initState();
    cloc();
  }

  cloc() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    userPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      // List <Place> _places ;
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);

      print(lat);
      print(lng);

      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(detail.result.geometry.location.lat,
              detail.result.geometry.location.lng), zoom: 18.0,),
      ),
      );
    }
  }


}