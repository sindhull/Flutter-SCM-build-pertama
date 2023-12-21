import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';

import '../screens/MainPage.dart';

class AllDronePositions extends StatefulWidget {
  final List data;

  AllDronePositions({required this.data});

  @override
  _AllDronePositionsState createState() => _AllDronePositionsState();
}

class _AllDronePositionsState extends State<AllDronePositions> {
  double initialZoom = 14.0; // Adjusted initial zoom level
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
  }

  void fetchDataFromDatabase() {
    setInitialZoom();
  }

  void setInitialZoom() {
    // Adjust this logic to set the initial zoom based on your preferences or calculations
    initialZoom = 14.0; // You may need to adjust this value based on your needs
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> coordinates = [];

    for (int i = 0; i < widget.data.length; i++) {
      Map<String, dynamic> coordinate = {
        "center": LatLng(double.parse(widget.data[i]['latitude']), double.parse(widget.data[i]['longitude'])),
        "radius": 1.0, // Radius in kilometers
      };
      coordinates.add(coordinate);
    }

    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => MainPage(index: 1));
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            title: Text(
              'All Jammer Position',
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
                    builder: (context) => MainPage(index: 1),
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
            zoom: initialZoom,
            maxZoom: 18.25,
            minZoom: 1,
            center: LatLng(double.parse(widget.data[0]['latitude']), double.parse(widget.data[0]['longitude'])), // Focused to the first marker
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            PolygonLayerOptions(
              polygons: List.generate(coordinates.length, (index) {
                LatLng center = coordinates[index]["center"];
                double radius = coordinates[index]["radius"];
                List rad = getCircleCoordinates(center, radius);

                return Polygon(
                  points: List.generate(rad.length, (ind) {
                    return LatLng(rad[ind]['latitude'], rad[ind]['longitude']);
                  }),
                  color: Colors.green.withOpacity(0.3),
                  borderStrokeWidth: 2.0,
                  borderColor: Colors.green,
                );
              }),
            ),
            MarkerLayerOptions(
              markers: List.generate(
                widget.data.length,
                    (index) => Marker(
                  width: 40.0,
                  height: 40.0,
                  point: LatLng(double.parse(widget.data[index]['latitude']), double.parse(widget.data[index]['longitude'])),
                  anchorPos: AnchorPos.align(AnchorAlign.top),
                  builder: (ctx) => Stack(
                    children: [
                      Image.asset(
                        "assets/icons/marker.png",
                        width: 40.0,
                        height: 40.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Color(0xC5FFFFFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          widget.data[index]['no_seri'],
                          style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List getCircleCoordinates(LatLng center, double radius) {
    List coordinates = [];
    int points = 100;

    for (int i = 0; i < points; i++) {
      double radians = (i / points) * (2 * pi);
      double x = center.latitude + radius / 111.32 * cos(radians);
      double y = center.longitude + radius / (111.32 * cos(center.latitude * (pi / 180))) * sin(radians);
      coordinates.add({
        "latitude": x,
        "longitude": y,
      });
    }

    return coordinates;
  }
}
