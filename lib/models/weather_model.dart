class WeatherModel {
  final String cityName;
  final double temperature;
  final String condition;
  final double rainRate;
  final int humidity;
  final double feelsLike;
  final double windSpeed;
  final double?
      uvIndex; // Made nullable since it may not be in all API responses
  final double?
      airQuality; // Made nullable as it may not be in all API responses
  final String sunrise;
  final String sunset;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.rainRate,
    required this.humidity,
    required this.feelsLike,
    required this.windSpeed,
    this.uvIndex, // Nullable field
    this.airQuality, // Nullable field
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? 'Unknown City',
      temperature: json['main']?['temp']?.toDouble() ?? 0.0,
      condition: json['weather'] != null && json['weather'].isNotEmpty
          ? json['weather'][0]['main']
          : 'Unknown',
      rainRate:
          json['rain'] != null ? json['rain']['1h']?.toDouble() ?? 0.0 : 0.0,
      humidity: json['main']?['humidity']?.toInt() ?? 0,
      feelsLike: json['main']?['feels_like']?.toDouble() ?? 0.0,
      windSpeed: json['wind']?['speed']?.toDouble() ?? 0.0,
      uvIndex:
          json['current'] != null ? json['current']['uvi']?.toDouble() : null,
      airQuality: json['air_quality']?['aqi']?.toDouble() ?? null,
      sunrise: json['sys']?['sunrise'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000)
              .toString()
          : 'N/A',
      sunset: json['sys']?['sunset'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000)
              .toString()
          : 'N/A',
    );
  }
}

/*class HourlyWeather {
  final String time;
  final String icon;
  final double temperature;

  HourlyWeather({required this.time, required this.icon, required this.temperature});
}

class WeatherModel {
  final String cityName;
  final double temperature;
  final String condition;
  final double rainRate;
  final int humidity;
  final double feelsLike;
  final double windSpeed;
  final double? uvIndex; // Made nullable since it may not be in all API responses
  final double? airQuality; // Made nullable as it may not be in all API responses
  final String sunrise;
  final String sunset;
  final List<HourlyWeather>? hourlyForecast;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.rainRate,
    required this.humidity,
    required this.feelsLike,
    required this.windSpeed,
    this.uvIndex, // Nullable field
    this.airQuality, // Nullable field
    required this.sunrise,
    required this.sunset,
    required this.hourlyForecast,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? 'Unknown City',
      temperature: json['main']?['temp']?.toDouble() ?? 0.0,
      condition: json['weather'] != null && json['weather'].isNotEmpty ? json['weather'][0]['main'] : 'Unknown',
      rainRate: json['rain'] != null ? json['rain']['1h']?.toDouble() ?? 0.0 : 0.0, // Check for rain data
      humidity: json['main']?['humidity']?.toInt() ?? 0, // Check for humidity
      feelsLike: json['main']?['feels_like']?.toDouble() ?? 0.0, // Check for feels-like temp
      windSpeed: json['wind']?['speed']?.toDouble() ?? 0.0, // Check for wind speed
      uvIndex: json['current'] != null ? json['current']['uvi']?.toDouble() : null, // UV index is optional
      airQuality: json['air_quality']?['aqi']?.toDouble() ?? null, // Air quality is optional
      sunrise: json['sys']?['sunrise'] != null ? DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000).toString() : 'N/A',
      sunset: json['sys']?['sunset'] != null ? DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000).toString() : 'N/A',
      hourlyForecast: [],
    );
  }
}*/

/*// weather_model.dart
class WeatherModel {
  final double temperature;
  final String condition;
  final String icon;

  WeatherModel({
    required this.temperature,
    required this.condition,
    required this.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['main']['temp'] as double,
      condition: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
    );
  }
}*/
