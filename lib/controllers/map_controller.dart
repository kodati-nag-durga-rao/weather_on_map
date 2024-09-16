import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_on_map/controllers/weather_controller.dart';
import '../models/weather_model.dart';

class MapController extends GetxController {
  GoogleMapController? mapController;
  WeatherController? weatherController;

  var isMapLoading = true.obs;
  var selectedMarkerPosition = Rxn<LatLng>();
  var screenPosition = Rxn<Offset>();
  var showCustomDialog = false.obs;
  var markers = <Marker>{}.obs; // Observable set of markers
  var currentLocation = Rxn<LatLng>(); // Store current location
  var weatherData = Rxn<WeatherModel?>(); // Observable weather data

  BitmapDescriptor? greenIcon;
  BitmapDescriptor? redIcon;

  @override
  void onInit() async {
    super.onInit();
    await _createMarkerIcons();
    _addInitialMarkers(); // Add initial markers when the controller initializes
    _getCurrentLocation(); // Get current location after icons are loaded

    /// Delay to ensure CircularProgressIndicator is shown for at least 2 seconds
    await Future.delayed(const Duration(seconds: 2), () {
      isMapLoading.value = false;
    });
  }

  /// Function to mark map as loaded
  void onMapLoaded() {
    if (isMapLoading.value) {
      Future.delayed(const Duration(seconds: 2), () {
        isMapLoading.value = false;
      });
    }
  }

  // Function to handle marker taps
  Future<void> onMarkerTap(LatLng position) async {

    print("Lat : ${ position.latitude}");
    print("Lon : ${ position.longitude}");
    if (mapController != null) {
      try {
        /// Center the map to the tapped marker
        await mapController!.animateCamera(CameraUpdate.newLatLng(position));

        /// Get screen coordinates of the center of the map (device center)
        ScreenCoordinate screenCoordinate =
            await mapController!.getScreenCoordinate(position);

        /// Get screen size
        final screenSize = MediaQuery.of(Get.context!).size;

        /// Calculate the center position
        screenPosition.value =
            Offset(screenSize.width / 2, screenSize.height / 2);

        //screenPosition.value = Offset(screenCoordinate.x.toDouble(), screenCoordinate.y.toDouble());
        selectedMarkerPosition.value = position;
        showCustomDialog.value = true;
        try {
          /// Retrieve WeatherController using Get.find() if it's already initialized
          WeatherController weatherController = Get.find<WeatherController>();

          /// Fetch weather data for the selected marker position
          await weatherController.fetchWeatherData(
              position.latitude, position.longitude);
        } catch (e) {
          if (kDebugMode) {
            print('Error in onMarkerTap: $e');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error getting screen coordinate: $e');
        }
      }
    } else {
      if (kDebugMode) {
        print('MapController is not initialized yet');
      }
    }
  }

  /// Function to add or update a marker at a given position (tap event or current location update)
  void addOrUpdateMarker(LatLng position, {bool isCurrentLocation = false}) {
    final icon = isCurrentLocation
        ? greenIcon
        : redIcon; // Use green for current location, red for others

    if (icon != null) {
      final marker = Marker(
        markerId: MarkerId(
            isCurrentLocation ? 'currentLocation' : position.toString()),
        position: position,
        icon: icon,
        onTap: () => onMarkerTap(position),
      );

      if (isCurrentLocation) {
        markers.removeWhere((m) => m.markerId.value == 'currentLocation');
      }

      markers.add(marker);
    }
  }

  /// Function to add some initial markers (including a placeholder for the current location)
  void _addInitialMarkers() {
    final initialMarkers = [
      const LatLng(17.4376, 78.5017), // Placeholder for current location
      const LatLng(17.3850, 78.4867),
      const LatLng(17.4454, 78.4662),
      const LatLng(17.3945, 78.4289),
      const LatLng(17.6336, 78.3952),
      const LatLng(17.5964, 78.5699),
    ];

    /// Add a placeholder marker for the current location (using default icon)
    addOrUpdateMarker(initialMarkers[0], isCurrentLocation: true);

    /// Add other initial markers with red icons
    for (int i = 1; i < initialMarkers.length; i++) {
      addOrUpdateMarker(initialMarkers[i]);
    }
  }

  /// Get current location of the device and update the marker
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentLocation.value = LatLng(position.latitude, position.longitude);

      /// Update the current location marker with the actual location and green icon
      addOrUpdateMarker(currentLocation.value!, isCurrentLocation: true);

      /// Move the camera to the current location
      mapController
          ?.animateCamera(CameraUpdate.newLatLng(currentLocation.value!));
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current location: $e');
      }
    }
  }

  /// Function to create custom green and red marker icons
  Future<void> _createMarkerIcons() async {
    greenIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen); // Green marker icon
    redIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed); // Red marker icon
  }
}
