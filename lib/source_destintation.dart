import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'request/commencer_letracking.dart';
import 'package:geolocator/geolocator.dart';
import 'request/commencer_letracking.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import'package:google_maps_webservice/places.dart';
import 'package:geocoder/geocoder.dart';
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: "AIzaSyCN5CJGsvRnutmMNhpN8toEprd3fn7cIBg");

class s_d extends StatefulWidget {

  @override
  source_destination createState() =>source_destination();
}

class source_destination extends State<s_d>
{
  GoogleMapController _controller ;
 // source_destination(GoogleMapController controller) {this._controller = controller ;}
static final CameraPosition _initialLocation = CameraPosition(
  target: LatLng(36.752887,  3.042048),
  zoom: 14.4746,
);
String  searchADR ;
static LatLng destination ;
TextEditingController LocationController = TextEditingController() ;
TextEditingController DestinationController = TextEditingController();
Set <Marker> _markers = {} ;
//LatLng _lastPosition = _initialPosition ;
@override
void initState() {
  super.initState();
  _GetUserLocation() ;

}
@override

  Widget build(BuildContext context)
  {

    return Scaffold(
      appBar: AppBar(
        title: Text("home_page"),
      ),
      body: Stack( children :  <Widget> [
          GoogleMap(
           mapType: MapType.normal,
           initialCameraPosition: _initialLocation,
           markers: _markers,
           onMapCreated: (GoogleMapController controller) {
           _controller = controller;
        },),
        Positioned (
          top : 50.0 ,
          right : 15.0 ,
          left: 15.0 ,
          child : Container (
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0) ,
              color: Colors.white ,
              boxShadow : [BoxShadow(color: Colors.black12 , offset: Offset(1.0,5.0),blurRadius: 10 , spreadRadius: 3) ],
            ),
            child: TextField(
                controller: LocationController,
                cursorColor: Colors.black,
                decoration : InputDecoration ( icon: Container(margin: EdgeInsets.only(left: 20,top: 5), width: 10, height: 10, child: Icon ( Icons.location_on),) ,
                  hintText: "source" ,
                  border: InputBorder.none ,
                )),
          ),
        ),
        Positioned (
          top : 105.0 ,
          right : 15.0 ,
          left: 15.0 ,
          child : Container (
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0) ,
              color: Colors.white ,
              boxShadow : [BoxShadow(color: Colors.black12 , offset: Offset(1.0,5.0),blurRadius: 10 , spreadRadius: 3) ],
            ),
            child: TextField(
              controller: DestinationController,
              cursorColor: Colors.black,
              onTap: () async{ Prediction p = await PlacesAutocomplete.show(
                  context: context, apiKey: "AIzaSyCN5CJGsvRnutmMNhpN8toEprd3fn7cIBg" ,  mode: Mode.overlay );
                displayPrediction(p);} ,
                decoration : InputDecoration ( icon: Container(margin: EdgeInsets.only(left: 20,top: 5), width: 10, height: 10, child: Icon ( Icons.directions_car ), ) ,
                  hintText: "Destination" ,
                  border: InputBorder.none ,
                ),

            ),
          ),
        ),
        Positioned(  top : 80.0 ,
                     right : 10.0 ,
                     left: 10.0 ,
            child: RaisedButton( color : Colors.white ,onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=> track (_controller , destination))); }, child: Text("commencer"),) ),

    ]));



  }






  Future <LatLng> _GetUserLocation()  async{
  var currentLocation = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  LatLng crlocation = LatLng(currentLocation.latitude , currentLocation.longitude) ;
  List <Placemark> _placemark =  await Geolocator().placemarkFromCoordinates(currentLocation.latitude, currentLocation.longitude) ;
  LocationController.text = _placemark[0].name ;
   setState(() {
     final marker = Marker(
       markerId: MarkerId("curr_loc"),
      position: LatLng(currentLocation.latitude, currentLocation.longitude),
      infoWindow: InfoWindow(title: 'Your Location'),
    );
    _markers.add(marker);
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition ( target: LatLng (currentLocation.latitude, currentLocation.longitude), zoom: 11.0 ,  ),
    ),
    );
  } ) ;
  return crlocation ;
}
   chercher()
  {

    Geolocator().placemarkFromAddress(searchADR).then((result) {  _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition ( target: LatLng (result[0].position.latitude, result[0].position.longitude), zoom: 11.0 ,
      ),
    ),
    );
    destination = LatLng (result[0].position.latitude, result[0].position.longitude) ;
    print( "dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd") ;
    print(destination.longitude) ;
    print(destination.latitude) ;
    setState(() {
      final marker = Marker(
        markerId: MarkerId("destination"),
        position: LatLng (result[0].position.latitude, result[0].position.longitude),
        infoWindow: InfoWindow(title: 'Your destination'),
      );
      _markers.add(marker);

    } ) ;
    }
    );
    print(destination.longitude) ;
    print(destination.latitude) ;

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
        CameraPosition ( target: LatLng ( detail.result.geometry.location.lat,  detail.result.geometry.location.lng), zoom: 18.0 ,  ),
      ),
      );
       destination =  LatLng ( detail.result.geometry.location.lat,  detail.result.geometry.location.lng);
       Placemark nation;
       // =  LatLng ( detail.result.geometry.location.lat,  detail.result.geometry.location.lng);

      DestinationController.text = detail.result.name ;
      setState(() {
        final marker = Marker(
          markerId: MarkerId("destination"),
          position:  LatLng ( detail.result.geometry.location.lat,  detail.result.geometry.location.lng),
          infoWindow: InfoWindow(title: 'Your destination'),
        );
        _markers.add(marker);

      } ) ;
    }
  }












}