import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test_mobile_dev/services/weather_api.dart';

import 'models/weather_data.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<WeatherViewModel>(
        create: (context) => WeatherViewModel(),
        child: const WeatherScreen(),
      ),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  TextEditingController latitudeController = TextEditingController(text: "59.437");
  TextEditingController longitudeController = TextEditingController(text: "24.754");

  @override
  void initState() {
    super.initState();
    var latitude = double.tryParse(latitudeController.text);
    var longitude = double.tryParse(longitudeController.text);
    if(latitude != null && longitude != null) {
      Provider.of<WeatherViewModel>(context, listen: false).loadWeatherData(latitude, longitude);
    } else {
      print('Invalid coordinates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              var latitude = double.tryParse(latitudeController.text);
              var longitude = double.tryParse(longitudeController.text);
              if(latitude != null && longitude != null) {
                Provider.of<WeatherViewModel>(context, listen: false).loadWeatherData(latitude, longitude);
              } else {
                print('Invalid coordinates');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Consumer<WeatherViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0), // padding on left and right
                  width: MediaQuery.of(context).size.width * 0.5, // setting width to 50% of screen width
                  child: TextField(
                    controller: latitudeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Enter Latitude'),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0), // padding on left and right
                  width: MediaQuery.of(context).size.width * 0.5, // setting width to 50% of screen width
                  child: TextField(
                    controller: longitudeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Enter Longitude'),
                  ),
                ),
                if (viewModel.weatherData != null)
                  ...[
                    Text(
                      '(${latitudeController.text}, ${longitudeController.text})',
                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateTime.now().toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${viewModel.weatherData!.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      viewModel.weatherData!.conditionDescription,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ]
                else
                  const CircularProgressIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class WeatherViewModel extends ChangeNotifier {
  final WeatherApi _weatherApi = WeatherApi();
  WeatherData? _weatherData;

  WeatherData? get weatherData => _weatherData;
  WeatherViewModel() {}

  Future<void> loadWeatherData(double latitude, double longitude) async {
    try {
      final data = await _weatherApi.fetchWeatherData(latitude, longitude);
      _weatherData = data;
      notifyListeners();
    } catch (error) {
      print("Error fetching weather data: $error");
    }
  }
}
