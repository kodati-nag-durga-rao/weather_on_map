import 'package:flutter/material.dart';

class WeatherDataContainer extends StatelessWidget {
  final String title;
  final String subTitle;
  const WeatherDataContainer({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade500,
        borderRadius: BorderRadius.all(Radius.circular(5)),

      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 14)),
          Text(subTitle, style: const TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 12))
        ],
      ),
    );
  }
}
