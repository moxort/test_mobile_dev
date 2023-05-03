import 'package:flutter/foundation.dart';

class WeatherData {
  final double temperature;
  final int condition;

  WeatherData({required this.temperature, required this.condition});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['temperature'].toDouble(),
      condition: json['weathercode'],
    );
  }
  String get conditionDescription {
    switch (condition) {
      case 0:
        return 'Clear sky';
      case 1:
      case 2:
      case 3:
        return 'Partly cloudy';
      case 45:
      case 48:
        return 'Fog';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 56:
      case 57:
        return 'Freezing drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rain';
      case 66:
      case 67:
        return 'Freezing rain';
      case 71:
      case 73:
      case 75:
        return 'Snowfall';
      case 77:
        return 'Snow grains';
      case 80:
      case 81:
      case 82:
        return 'Rain showers';
      case 85:
      case 86:
        return 'Snow showers';
      case 95:
        return 'Thunderstorm (slight or moderate)';
      case 96:
      case 99:
        return 'Thunderstorm with hail';
      default:
        return 'Unknown condition';
    }
  }


}

