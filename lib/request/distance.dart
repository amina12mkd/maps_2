import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
class distence
{
  calculate_speed (  ) async
  {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    Position position ;
    Geolocator _geoLocator ;
   /* _geoLocator.getPositionStream((locationOptions)).listen((position) {
      var speedInMps = position.speed; // in mps
    });*/
  }



}