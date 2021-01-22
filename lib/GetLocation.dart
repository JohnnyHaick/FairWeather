import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoder/geocoder.dart';


class GetLocation{
  double latitude;
  double longitude;
  String City;
  //get current location. async ensure method doesn't run from ui thread. future is used for app thst will take longer
  Future<void>getCurrentLocation() async{
    //to make sure errors dont pop up to the end user
    try{
      //to get your current position
      Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
      //print('your position is: $position');

      //parsing latitude and longitude to. We add await cos the method is Future
      City = await getCityName(position.latitude, position.longitude);
    }
    catch(e){
      print(e);
    }
  }

  //get city name
  Future<String> getCityName(double lat, double lon) async{
    //getting coordinates from getCurrentLocation Method
    List<Placemark> placemark = await placemarkFromCoordinates(lat, lon);
    //we're including the curly brackets cos of the dot in there. going use subadmin area instead of locality cos of the Android sdk
    print('city name is: ${placemark[0].subAdministrativeArea}');
    return placemark[0].subAdministrativeArea;

    //another way to do it
    /*final coordinates = new Coordinates(lat, lon);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.adminArea} : ${first.subLocality} : ${first.subAdminArea}: ${first.locality} : ${first.addressLine}");
*/

  }
}