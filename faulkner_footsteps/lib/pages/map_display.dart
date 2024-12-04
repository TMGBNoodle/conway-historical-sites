<<<<<<< Updated upstream
import 'package:faulkner_footsteps/app_state.dart';
import 'package:faulkner_footsteps/dialogs/pin_Dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapDisplay extends StatefulWidget {
  const MapDisplay({super.key});

  @override
  _MapDisplayState createState() => _MapDisplayState();
}

class _MapDisplayState extends State<MapDisplay> {
  // Example locations with names but random coordinates -> I will fix this later
  final Map<String, LatLng> siteLocations = {
    "Buhler Hall": LatLng(35.0853, -92.4421),
    "Church of Christ": LatLng(35.0843, -92.4401),
    "Simon Park": LatLng(35.0823, -92.4431),
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        // Red colored pins for each historical site
        List<Marker> markers = siteLocations.entries.map((entry) {
          return Marker(
            point: entry.value,
            child: IconButton(
              icon: const Icon(Icons.location_pin, color: Colors.red, size: 30),
              onPressed: () {
                // Show PinDialog when a pin is clicked
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PinDialog(
                      siteName: entry.key,
                      appState: appState,
                    );
                  },
                );
              },
            ),
          );
        }).toList();

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 238, 214, 196),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 107, 79, 79),
            title: const Text(
              "Historical Site Map",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 243, 228),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(35.0843, -92.4421),
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: markers,
              ),
            ],
          ),
        );
      },
=======
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';


class MapDisplay extends StatelessWidget {
  const MapDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 214, 196),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 107, 79, 79),
        title: const Text(
          "Conway Map",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 243, 228),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(35.0918, -92.4367),
          initialZoom: 12,
          cameraConstraint: CameraConstraint.contain(
            bounds: LatLngBounds(
              const LatLng(-90, -180),
              const LatLng(90, 180),
            ),
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
        ],
      ),
>>>>>>> Stashed changes
    );
  }
}
