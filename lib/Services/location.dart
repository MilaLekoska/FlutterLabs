import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class LocationService {

  Future<String> _getPlaceId(String input) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery";

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var locationId = json['candidates'][0]['place_id'] as String;

    return locationId;
  }

  Future<Map<String, dynamic>> getLocation(String input) async {
    final placeId = await _getPlaceId(input);
    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId";


      var response = await http.get(Uri.parse(url));
      var json = convert.jsonDecode(response.body);

      var results = json['result'] as Map<String, dynamic>;

      return results;

  }

  Future<Map<String, dynamic>> getDirections(
      String startingPoint, String destinationPoint) async {
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$startingPoint&destination=$destinationPoint";

      var response = await http.get(Uri.parse(url));
      var json = convert.jsonDecode(response.body);

      var results = {
        'bounds_ne': json['routes'][0]['bounds']['northeast'],
        'bounds_sw': json['routes'][0]['bounds']['southwest'],
        'start_location': json['routes'][0]['legs'][0]['start_location'],
        'end_location': json['routes'][0]['legs'][0]['end_location'],
        'polyline': json['routes'][0]['overview_polyline']['points'],
        'polyline_decoded': PolylinePoints()
            .decodePolyline(json['routes'][0]['overview_polyline']['points'])
      };

      return results;

  }

}