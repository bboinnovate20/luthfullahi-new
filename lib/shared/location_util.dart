import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationUtil {
  Position? position;
  late LocationSettings locationSettings;
  late Function streamFunction;

  LocationUtil() {
    // initialize();
  }



  initialize() async {
    try {
      bool isPermitted = await askPermission();
      if (isPermitted) {
        position = await Geolocator.getLastKnownPosition();
      
        if (position == null) {
          position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          locationSettings = const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 1,
          );
        }
      }

      return position;
    } catch (e) {
      return Position;
    }
  }

  askPermission() async {
    // final pos = await initialize();
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (serviceEnabled) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return false;
        }
        return true;
      }
      return true;
    }
    return false;
  }

  Future<StreamSubscription<Position>> startListening() async {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );
    final positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      streamFunction(position);
    });
    return positionStream;
  }

  getLocation() async {
    // initiatlize();

    // await initiatlize();

    return {
      'accuracy': position?.accuracy,
      'long': position?.longitude,
      'lat': position?.latitude
    };
  }

  getKnownLocation() async {
    position = await Geolocator.getLastKnownPosition();
  }

}
