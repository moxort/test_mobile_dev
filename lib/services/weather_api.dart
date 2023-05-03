import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';

class WeatherApi {
  static const baseUrl = "https://api.open-meteo.com/v1/forecast";

  Future<WeatherData> fetchWeatherData(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        "$baseUrl?latitude=$latitude&longitude=$longitude&current_weather=true"));

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body)['current_weather']);
    } else {
      throw Exception("Failed to load weather data");
    }
  }
}
