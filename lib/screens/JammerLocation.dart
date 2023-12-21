import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class JammerLocation extends StatefulWidget {
  const JammerLocation({Key? key}) : super(key: key);

  @override
  State<JammerLocation> createState() => _JammerLocationState();
}

class _JammerLocationState extends State<JammerLocation> {
  late GoogleMapController mapController;

  // Initial coordinates for the map
  final LatLng _initialPosition = const LatLng(37.7749, -122.4194); // Example: San Francisco coordinates

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jammer Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 14.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: _createMarkers(),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return <Marker>{
      Marker(
        markerId: MarkerId('jammer_location'),
        position: _initialPosition,
        infoWindow: const InfoWindow(
          title: 'Jammer Location',
          snippet: 'Description of Jammer Location',
        ),
      ),
      // Add more markers if needed by adding more Marker objects to the Set
    };
  }
}
