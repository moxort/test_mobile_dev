import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getCurrentWeather() async {
  final response = await http.get(
    Uri.parse('https://api.open-meteo.com/v1/forecast'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data is Map<String, dynamic>) {
      final hourlyData = data['hourly'];
      if (hourlyData is List && hourlyData.isNotEmpty) {
        return Map<String, dynamic>.from(hourlyData[0]);
      }
    }
  }

  throw Exception('Failed to load current weather data');
}
