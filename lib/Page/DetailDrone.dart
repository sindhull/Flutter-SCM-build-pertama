import 'dart:math';
import 'package:apk_sinduuu/screens/DetailScreen.dart';
import 'package:apk_sinduuu/screens/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';

import 'DroneList.dart';

class DetailDrone extends StatefulWidget {
  final Map data;
  final int id;

  DetailDrone({required this.data, required this.id});

  @override
  _DetailDroneState createState() => _DetailDroneState();
}

class _DetailDroneState extends State<DetailDrone> {
  double latitude = 0.0;
  double longitude = 0.0;
  double initialZoom = 14.0; // Adjusted initial zoom level
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
  }

  void fetchDataFromDatabase() {
    latitude = double.parse(widget.data['latitude']);
    longitude = double.parse(widget.data['longitude']);
    setInitialZoom();
  }

  void setInitialZoom() {
    // Adjust this logic to set the initial zoom based on your preferences or calculations
    initialZoom = 14.0; // You may need to adjust this value based on your needs
    print('Latitude: $latitude, Longitude: $longitude, Zoom: $initialZoom');
  }

  @override
  Widget build(BuildContext context) {
    LatLng centerPoint = LatLng(latitude, longitude);
    List<LatLng> circleCoordinates = getCircleCoordinates(centerPoint, 0.1); // 1 km in meters

    return WillPopScope(
      onWillPop: ()async{
        Get.offAll(() => const MainPage(index: 1));
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            title: Text(
              'Drone Blocker Location',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(id: widget.id),
                  ),
                );
              },
            ),
            backgroundColor: Colors.lightGreen, // Warna kuning pada app bar
            automaticallyImplyLeading: false,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30), // Sesuaikan radius lengkung
              ),
            ),
            centerTitle: true, // Menempatkan judul di tengah
          ),
        ),
        body: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: centerPoint,
            zoom: initialZoom,
            maxZoom: 18.25,
            minZoom: 10,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            PolygonLayerOptions(
              polygons: [
                Polygon(
                  points: circleCoordinates,
                  color: Colors.green.withOpacity(0.3),
                  borderStrokeWidth: 2.0,
                  borderColor: Colors.green,
                ),
              ],
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 40.0,
                  height: 40.0,
                  point: centerPoint,
                  anchorPos: AnchorPos.align(AnchorAlign.top),
                  builder: (ctx) => Container(
                    child: Image.asset(
                      "assets/icons/marker.png",
                      width: 40.0,
                      height: 40.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<LatLng> getCircleCoordinates(LatLng center, double radius) {
    List<LatLng> coordinates = [];
    int points = 100;

    for (int i = 0; i < points; i++) {
      double radians = (i / points) * (2 * pi);
      double x = center.latitude + radius / 111.32 * cos(radians);
      double y = center.longitude + radius / (111.32 * cos(center.latitude * (pi / 180))) * sin(radians);
      coordinates.add(LatLng(x, y));
    }

    return coordinates;
  }
}
