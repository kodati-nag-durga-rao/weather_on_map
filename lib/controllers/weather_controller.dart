import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/weather_model.dart';
import '../services/weather_services.dart';

class WeatherController extends GetxController {
  var weatherData = Rxn<WeatherModel?>(); // Observable weather data

  /// Function to fetch weather data for a specific latitude and longitude
  Future<void> fetchWeatherData(double latitude, double longitude) async {
    try {
      WeatherModel? data = await WeatherApi.getWeather(latitude, longitude);
      // print("weatherData : $data");
      weatherData.value = data;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching weather data: $e');
      }
      weatherData.value = null;
    }
  }
}
