import 'dart:ui'; // For BackdropFilter

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:weather_on_map/utils/common/widgets/image_strings.dart';
import '../models/weather_model.dart';
import '../utils/common/widgets/weather_data_container.dart';

class WeatherInfoWidget extends StatelessWidget {
  final WeatherModel? weather; // Weather data passed to the widget
  final LatLng markerPosition; // LatLng data passed to the widget
  final Offset screenPosition; // Position to place the widget on screen
  final Function onClose; // Close button callback

  const WeatherInfoWidget({
    super.key,
    required this.weather,
    required this.markerPosition,
    required this.screenPosition,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    String sunSetTime = "";
    String sunRiseTime = "";

    /// Get screen coordinates
    double dx = screenSize.width / 2 - 150; // Center the dialog horizontally
    double dy = screenPosition.dy - 380; // Adjust to show above the marker

    /// Ensure dialog is within screen bounds
    if (dx < 0) dx = 10;
    if (dx + 250 > screenSize.width) dx = screenSize.width - 260;
    if (dy < 0) dy = 10;

    /// Define background image based on weather conditions
    String backgroundImage = AppImageStrings.sunnyImage; // Default to sunny
    if (weather != null) {
      sunRiseTime = DateFormat("HH:MM").format(DateTime.parse(weather!.sunrise)).toString();
      sunSetTime = DateFormat("HH:MM").format(DateTime.parse(weather!.sunset)).toString();

      if (weather!.condition == 'Rain' || weather!.condition == 'Drizzle' || weather!.condition == 'Drizzle') {
        backgroundImage = AppImageStrings.rainImage;
      } else if (weather!.condition == 'Clouds' || weather!.condition == 'Mist' || weather!.condition == 'Haze' ||weather!.condition == 'Smoke' || weather!.condition == 'Dust' || weather!.condition == 'Fog') {
        backgroundImage = AppImageStrings.cloudImage;
      } else if (weather!.condition == 'Thunderstorm') {
        backgroundImage = AppImageStrings.thunderImage;
      } else if (weather!.condition == 'Clear') {
        backgroundImage = AppImageStrings.sunnyImage;
      }
    }

    return Positioned(
      left: dx,
      top: dy,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          children: [
            /// Background Image
            Container(
              padding: const EdgeInsets.all(10),
              width: 300,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),

            ),

            /// Glass effect layer
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                width: 300,
                height: 160,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Weather Info',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,alignment: Alignment.centerRight,
                            onPressed: () => onClose(), icon: const Icon(Icons.close,color: Colors.blue,size: 30,))
                      ],
                    ),
                    if (weather == null) ...[
                      const Text('Fetching weather...',
                          style: TextStyle(color: Colors.white,fontSize: 12)),
                    ]else ...[
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,color: Colors.white,),
                        Expanded(
                          child: Text(weather!.cityName,
                              style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),

                    SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          WeatherDataContainer(title: '${weather!.temperature}°C',subTitle: 'Temperature'),
                          const SizedBox(width: 8,),
                          WeatherDataContainer(title: '${weather!.feelsLike}°C',subTitle: 'Feels Like'),
                          const SizedBox(width: 8,),
                          WeatherDataContainer(title: '${weather!.humidity}%',subTitle: 'Humidity'),
                          const SizedBox(width: 8,),
                          WeatherDataContainer(title: '${weather!.windSpeed} m/s',subTitle: 'Wind Speed'),
                          const SizedBox(width: 8,),
                          WeatherDataContainer(title: sunRiseTime,subTitle: 'Sun Rise'),
                          const SizedBox(width: 8,),
                          WeatherDataContainer(title: sunSetTime,subTitle: 'Sun Set'),
                        ],
                      ),
                    ),


                  ] ,

                  ],
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
