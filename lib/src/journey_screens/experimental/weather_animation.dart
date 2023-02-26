import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:weather_animation/weather_animation.dart';

class WeatherAnimation extends StatelessWidget {
  const WeatherAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Column(
      //   children: [
      //     Expanded(child: WeatherScene.values.byName('stormy').getWeather()),
      //   ],
      // ),

      body: Opacity(
        opacity: 0.5,
        child: SizedBox.expand(
            child: WeatherScene.values.byName('stormy').getWeather()),
      ),

      // body: ScrollConfiguration(
      //   behavior: ScrollConfiguration.of(context).copyWith(
      //     dragDevices: {
      //       PointerDeviceKind.touch,
      //       PointerDeviceKind.mouse,
      //     },
      //   ),
      // child: PageView(
      //   children: WeatherScene.values.map((e) => e.getWeather()).toList(),
      // ),
      //   child: WeatherScene.values.byName('stormy').getWeather(),
      // ),
    );
  }
}
