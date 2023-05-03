import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_mobile_dev/services/weather_api.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  late double? _currentTemperature = null;
  late String? _currentConditions = null;

  @override
  void initState() {
    super.initState();
    _getCurrentWeather();
  }

  Future<void> _getCurrentWeather() async {
    try {
      final weatherData = await getCurrentWeather();
      setState(() {
        _currentTemperature = weatherData['temperature_2m'].toDouble();
        _currentConditions = _getWeatherCondition(weatherData['weathercode']);
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  String _getWeatherCondition(int weatherCode) {
    if (weatherCode == 1000) {
      return 'Clear';
    } else if (weatherCode >= 1001 && weatherCode <= 1030) {
      return 'Cloudy';
    } else if (weatherCode >= 2000 && weatherCode <= 2339) {
      return 'Rainy';
    } else if (weatherCode >= 2500 && weatherCode <= 2739) {
      return 'Snowy';
    } else {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Weather App'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () => _getCurrentWeather(),
              ),
            ],
          ),
          body: Center(
            child: _currentTemperature == null || _currentConditions == null
                ? CircularProgressIndicator()
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${_currentTemperature!.toStringAsFixed(1)} °C',
                  style: TextStyle(fontSize: 64.0),
                ),
                SizedBox(height: 32.0),
                Text(
                  _currentConditions!,
                  style: TextStyle(fontSize: 32.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }


// @override
  // Widget build(BuildContext context) {
  //   final temperatureText = '${_currentTemperature?.toStringAsFixed(1)}°C';
  //   final conditionsText = _currentConditions;
  //
  //   return MaterialApp(
  //     title: 'Weather App',
  //     home: Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Current Weather in Tallinn'),
  //       ),
  //       body: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               _currentTemperature?.toStringAsFixed(1) ?? 'Loading...',
  //               style: const TextStyle(
  //                 fontSize: 60.0,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             const SizedBox(height: 20.0),
  //             Text(
  //               _currentConditions ?? 'Loading...',
  //               style: const TextStyle(
  //                 fontSize: 40.0,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       floatingActionButton: FloatingActionButton(
  //         onPressed: _getCurrentWeather,
  //         tooltip: 'Refresh',
  //         child: const Icon(Icons.refresh),
  //       ),
  //     ),
  //   );
  // }
}
