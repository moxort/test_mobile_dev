import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test_mobile_dev/services/weather_api.dart';

import 'models/weather_data.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<WeatherViewModel>(
        create: (context) => WeatherViewModel(),
        child: WeatherScreen(),
      ),
    );
  }
}

class WeatherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Provider.of<WeatherViewModel>(context, listen: false).loadWeatherData();
            },
          ),
        ],
      ),
      body: Center(
        child: Consumer<WeatherViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.weatherData == null) {
              return CircularProgressIndicator();
            } else {
              final weatherData = viewModel.weatherData;
              final cityName = "Tallinn"; // replace with actual city name
              final latitude = 59.437; // replace with actual latitude
              final longitude = 24.754; // replace with actual longitude
              final now = DateTime.now();

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$cityName (${latitude.toStringAsFixed(3)}, ${longitude.toStringAsFixed(3)})',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    now.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${weatherData.temperature.toStringAsFixed(1)}°C',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    weatherData.conditionDescription,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}


class WeatherViewModel extends ChangeNotifier {
  final WeatherApi _weatherApi = WeatherApi();
  WeatherData? _weatherData;

  WeatherData get weatherData => _weatherData!;
  WeatherViewModel() {
    loadWeatherData();
  }

  Future<void> loadWeatherData() async {
    try {
      final data = await _weatherApi.fetchWeatherData(59.437, 24.754); // Tallinn's coordinates
      _weatherData = data;
      notifyListeners();
    } catch (error) {
      print("Error fetching weather data: $error");
    }
  }
}