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
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Temperature: ${viewModel.weatherData!.temperature}°C',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Condition: ${viewModel.weatherData!.conditionDescription}',
                    style: TextStyle(fontSize: 24),
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