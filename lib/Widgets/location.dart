import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Services/location.dart';

class LocationsScreen extends StatefulWidget {
  static const String routeName = '/locations';

  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  static const initialLocationLat = 42.00506402606598;
  static const initialLocationLng = 21.410094125135565;

  final List<Marker> _eventLocationMarkers = [];

  final _locationService = LocationService();

  final _initialLocation = const LatLng(initialLocationLat, initialLocationLng);

  late GoogleMapController mapController;

  final Completer<GoogleMapController> _controller = Completer();

  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  final _markers = <Marker>{};
  final _polygons = <Polygon>{};
  final _polylines = <Polyline>{};
  List<LatLng> polygonLatLngs = <LatLng>[];

  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  bool _isInit = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (_isInit) {
      for (var element in _eventLocationMarkers) {
        var currentMarker = Marker(
          markerId: element.markerId,
          position: element.position,
          infoWindow: InfoWindow(title: element.infoWindow.title),
          onTap: () async => await _drawPolyLines(element),
        );

        _markers.add(currentMarker);
      }

      _isInit = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _setMarker(_initialLocation);
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(point.hashCode.toString()),
          position: point,
          infoWindow: const InfoWindow(title: "Your location"),
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      );
    });
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;
    _polygons.add(Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: Colors.black12));
  }

  void _setPolyLine(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId(polylineIdVal),
          width: 6,
          color: Colors.blue,
          points: points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Route'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _fromController,
                        decoration: const InputDecoration(
                          labelText: 'From',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _toController,
                        decoration: const InputDecoration(
                          labelText: 'To',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_fromController.text.isEmpty ||
                              _toController.text.isEmpty) {
                            return;
                          }
                          _findRoute();
                        },
                        child: const Text('Find Route'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              polylines: _polylines,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (point) {
                setState(() {
                  polygonLatLngs.add(point);
                  _setPolygon();
                });
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(initialLocationLat, initialLocationLng),
                zoom: 10.0,
              ),
              markers: _markers,
            ),
          )
        ],
      ),
    );
  }

  void _findRoute() async {
    var directions = await _locationService.getDirections(
      _fromController.text,
      _toController.text,
    );

    if (directions.isNotEmpty) {
      _setPolyLine(directions['polyline_decoded']);
    }

    _fromController.text = '';
    _toController.text = '';
  }

  Future<void> _drawPolyLines(Marker tappedMarker) async {
    var directions = await _locationService.getDirections(
      '$initialLocationLat,$initialLocationLng',
      '${tappedMarker.position.latitude},${tappedMarker.position.longitude}',
    );
    _setPolyLine(directions['polyline_decoded']);
  }
}