import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:routenavigation/models.dart';

///This is the google api key that i am using for the app
const apiKey = "AIzaSyA5KR-nqqdv1PmzDH8WXtxY290ATmIXo7Q";

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  /// indicating the location loading state in start of the app
  bool loading = true;

  ///List of the location between which the route will be shown
  final List<LatLng> locations = [];

  ///True if we are picking the destination otherwise false
  bool addDestination = false;

  ///We are using 'MapboxNavigation' to show the route
  MapboxNavigation _directions;

  ///Controller for google map
  Completer<GoogleMapController> _controller = Completer();

  ///camera position in google map
  static LatLng cameraPosition;

  ///polyline for the route
  final Set<Polyline> _polyLines = {};

  LatLng currentLocation;

  /// for my custom marker pins
  BitmapDescriptor startIcon;
  BitmapDescriptor destinationIcon;
  BitmapDescriptor currentLocationIcon;

  bool useGoogle = true;

  @override
  void initState() {
    _directions = new MapboxNavigation();
    setCustomIcons();
    setState(() {
      ///loading the initial position of the user
      getLocation();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GoogleMap(
                  polylines: _polyLines.toSet(),
                  markers: _getMarkers(),
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: cameraPosition,
                    zoom: 15,
                  ),
                  minMaxZoomPreference: MinMaxZoomPreference(13, 16),
                  onCameraMove: onCameraMove,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  //onTap: _onTapOnMap,
                ),
          addDestination
              ? Center(
                  child: Icon(Icons.place),
                )
              : SizedBox(),

          ///this is the button change the navigation system. (Google map or mapbox)
          Positioned(
            top: 48,
            right: 16.0,
            child: SizedBox(
              height: 60.0,
              width: 60.0,
              child: FlatButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                onPressed: () {
                  setState(() {
                    useGoogle = !useGoogle;
                  });
                },
                child: Image.asset(useGoogle
                    ? 'assets/location_pins/googlemap.png'
                    : 'assets/location_pins/mapbox.png'),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: loading
          ? null
          : FloatingActionButton(
              onPressed: () {
                ///if we have start and end point
                if (locations.length == 2) {
                  setState(() {
                    locations.clear();
                    _polyLines.clear();
                    addDestination = false;
                  });
                  return;
                }

                ///if are selecting the destination
                if (addDestination) {
                  if (addDestination) locations.add(cameraPosition);
                  if (useGoogle)
                    _showRouteInMap();
                  else
                    _showRouteWithMapboxNavigator();
                } else {
                  if (locations.length > 1)
                    setState(() {
                      locations.removeAt(1);
                    });
                }
                setState(() {
                  if (!addDestination) {
                    locations.clear();
                    locations.add(currentLocation);
                  }
                  addDestination = !addDestination;
                });
              },

              ///when we have start and end location we will show close icon
              /// if no start location the show the select destination location
              /// if the destination is set , navigation icon
              child: Icon(
                locations.length == 2
                    ? Icons.close
                    : addDestination ? Icons.navigation : Icons.add_location,
              ),
              backgroundColor: locations.length == 2
                  ? Colors.red
                  : addDestination ? Colors.blue : Colors.green,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// Set of markers for the map with custom icon
  Set<Marker> _getMarkers() {
    ///market for the start  and end
    Set<Marker> markers = List.generate(locations.length, (index) {
      return Marker(
        markerId: MarkerId('${100 + index}'),
        infoWindow: InfoWindow(title: index == 0 ? 'Start Point' : 'End Point'),
        position: locations[index],
        icon: index == 0 ? startIcon : destinationIcon,
      );
    }).toSet();

    ///current user location marker
    markers.add(Marker(
      markerId: MarkerId('${000}'),
      infoWindow: InfoWindow(title: 'Current position'),
      position: currentLocation,
      icon: currentLocationIcon,
    ));

    return markers;
  }

  ///here we are using the map box for live navigation
  void _showRouteWithMapboxNavigator() {
    Future.delayed(Duration(seconds: 1), () {
      for (dynamic l in locations) print(l);
      _directions.startNavigation(
          origin: Location(
              name: "Start",
              latitude: locations[0].latitude,
              longitude: locations[0].longitude),
          destination: Location(
              name: "Start",
              latitude: locations[1].latitude,
              longitude: locations[1].longitude),
          mode: NavigationMode.drivingWithTraffic,
          simulateRoute: false,
          language: "English",
          units: VoiceUnits.metric);
    });
  }

  ///Method to obtain the current user location as start point
  getLocation() async {
    var location = new loc.Location();

    ///updating the setting to retrieve the user location in every 30 second
    location.changeSettings(interval: 30000, distanceFilter: 0);

    ///here we are getting the current location of the user in start
    location.getLocation().then((currentLocation) {
      setState(() {
        cameraPosition =
            LatLng(currentLocation.latitude, currentLocation.longitude);
        this.currentLocation =
            LatLng(currentLocation.latitude, currentLocation.longitude);
      });
      loading = false;
    });

    ///every 30 second we are notifies in this stream
    location.onLocationChanged.listen(_continusLocationUpdate);
  }

  ///location change listener method
  void _continusLocationUpdate(currentLocation) {
    setState(() {
      this.currentLocation =
          LatLng(currentLocation.latitude, currentLocation.longitude);
    });
  }

  ///updates the camera location depending on the camera movement
  void onCameraMove(CameraPosition position) {
    cameraPosition = position.target;
  }

  ///Here we load the roue from mapbox
  void _showRouteInMap() {
    String poses = '';

    ///processing latlagn to use in api
    for (LatLng latLan in locations) {
      poses +=
          '${poses.isEmpty ? '' : '%3B'}${latLan.longitude}%2C${latLan.latitude}';
    }

    ///loading dialog
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));

    ///Making the api request to Mapbox for route polyline details
    Dio()
        .get(
            'https://api.mapbox.com/directions/v5/mapbox/driving/$poses?alternatives=true&geometries=geojson&steps=true&access_token=pk.eyJ1Ijoic2Fra2FyIiwiYSI6ImNqeXdzNHltdDBnOTMzaG52dmFqYzJ0eTcifQ.7tEAWC0E-00EAitgG2iqNA')
        .then((value) {
      NavigatorModel navigatorModel = NavigatorModel.fromJson(value.data);
      setState(() {
        Navigator.pop(context);
        _polyLines.clear();
        _polyLines.add(Polyline(
            endCap: Cap.roundCap,
            startCap: Cap.roundCap,
            width: 3,
            polylineId: PolylineId('route_to_dest'),
            points: navigatorModel.routes[0].geometry.coordinates));
      });
    });
  }

  void setCustomIcons() async {
    startIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/location_pins/home.png',
    );

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/location_pins/target.png');

    currentLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5, size: Size(48, 48)),
        'assets/location_pins/current.png');
  }
}
