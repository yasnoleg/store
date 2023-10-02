import 'package:location/location.dart';

class LocationService {
  LocationService();
  GetUserLocation() async {
    
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    double latit;

    //GET PERMISSION TO READ LOCATION OF USER
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    //--------------------------------------------------------

    //READ USER LOCATION 
    locationData = await location.getLocation();
    //--------------------------------------------------------

    return locationData;
  }

}