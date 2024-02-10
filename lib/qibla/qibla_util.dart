import 'dart:async';
import "dart:math" as Math;

import 'package:geolocator/geolocator.dart';
import 'package:prayers_times/prayers_times.dart';

class QiblaUtil {
  late Position? position;
  late LocationSettings locationSettings;

  QiblaUtil() {
    // initialize();;
  }

  initialize(long, lat) {
    final myCoordinates = Coordinates(lat, long);
    final qibla = Qibla.qibla(myCoordinates);
    return qibla;
  }

  // double calculateQiblaDirection(double latitude, double longitude) {
  //   final getMeccaDirection = initialize(latitude, longitude);
  //   final meccaLatitude = getMeccaDirection.location;
  //   const meccaLongitude = 39.8262;

  //   final lat1 = latitude * (Math.pi / 180);
  //   final lon1 = longitude * (Math.pi / 180);
  //   const lat2 = meccaLatitude * (Math.pi / 180);
  //   const lon2 = meccaLongitude * (Math.pi / 180);

  //   final dLon = lon2 - lon1;
  //   final dLat = lat2 - lat1;

  //   final y = Math.sin(dLon) * Math.cos(lat2);
  //   final x = Math.cos(lat1) * Math.sin(lat2) -
  //       Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLon);
  //   final qibla = Math.atan2(y, x) * (180 / Math.pi);

  //   final qiblaNormalized = (qibla + 360) % 360;
  //   return qiblaNormalized;
  // }
}
