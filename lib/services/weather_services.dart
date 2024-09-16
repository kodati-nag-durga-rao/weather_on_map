
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/weather_model.dart';


class WeatherApi {
  static const String _apiKey = '7be22ced066fa43f72912e33c2364e7d'; // Replace with your actual API key
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // Function to fetch weather data based on latitude and longitude
  static Future<WeatherModel?> getWeather(double latitude, double longitude) async {
    final url = Uri.parse('$_baseUrl?lat=$latitude&lon=$longitude&units=metric&appid=$_apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON response into WeatherModel
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        print('Failed to load weather data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      return null;
    }
  }
}







