import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:weather_on_map/pages/weather_info_page.dart';
import '../controllers/map_controller.dart';
import '../controllers/weather_controller.dart';

class WeatherMapPage extends StatelessWidget {
  final MapController mapController = Get.put(MapController());
  final WeatherController weatherController = Get.put(WeatherController());

  WeatherMapPage({super.key});

  /// Function to remove all added markers (except initialMarkers) and hide the custom info window
  void _removeAddedMarkers() {
    final initialMarkers = [
      const LatLng(17.4376, 78.5017),
      const LatLng(17.3850, 78.4867),
      const LatLng(17.4454, 78.4662),
      const LatLng(17.3945, 78.4289),
      const LatLng(17.6336, 78.3952),
      const LatLng(17.5964, 78.5699),
    ];

    /// Remove markers except those in initialMarkers
    mapController.markers.removeWhere((marker) {
      final markerPosition = marker.position;
      return !initialMarkers.contains(markerPosition);
    });

    /// Hide custom info window if it's showing
    mapController.showCustomDialog.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather on Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed:
                _removeAddedMarkers, // Call the function to remove markers and hide the dialog
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            /// Circular Progress Indicator while loading the map
            Obx(() {
              return AnimatedOpacity(
                opacity: mapController.isMapLoading.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Visibility(
                  visible:  mapController.isMapLoading.value,
                  child: const Center(
                    child: CircularProgressIndicator(), // Show progress indicator
                  ),
                ),
              );
            }),

            /// Google Map
            Obx(() {
              return AnimatedOpacity(
                opacity: mapController.isMapLoading.value ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 500),
                child: GoogleMap(
                  onMapCreated: (controller) {
                    mapController.mapController = controller;
                    //print("MapController initialized");

                    /// Move to current location once it's available
                    if (mapController.currentLocation.value != null) {
                      mapController.mapController?.animateCamera(
                        CameraUpdate.newLatLng(
                            mapController.currentLocation.value!),
                      );
                    }
                  },
                  initialCameraPosition: CameraPosition(
                    target: mapController.currentLocation.value ?? const LatLng(17.4376, 78.5017), // Default to Hyderabad until location is retrieved
                    zoom: 11,
                  ),
                  markers: mapController.markers.toSet(), // Trigger reactivity for markers
                  onTap: (LatLng position) async {

                    await weatherController.fetchWeatherData(
                        position.latitude, position.longitude);
                    mapController.addOrUpdateMarker(position); // Add red marker on tap
                  },
                ),
              );
            }),

            /// Custom Info Window Dialog
            Obx(() {
              if (mapController.showCustomDialog.value) {
                return WeatherInfoWidget(
                  weather: weatherController.weatherData.value,
                  markerPosition: mapController.selectedMarkerPosition.value!,
                  screenPosition: mapController.screenPosition.value!,
                  onClose: () {
                    mapController.showCustomDialog.value = false;
                  },
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
