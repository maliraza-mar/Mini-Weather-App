import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:miniwhatherapp/models/weather_model.dart';
import 'package:miniwhatherapp/service/weather_service.dart';


class WheatherPage extends StatefulWidget {
  const WheatherPage({super.key});

  @override
  State<WheatherPage> createState() => _WheatherPageState();
}

class _WheatherPageState extends State<WheatherPage> {

  // -- Here in this app i have added both Permissions for Android and Ios.

  // -- apiKey
  final _weatherService = WeatherServices(apiKey: '6367623a68b6d3596f94dae02679e4c6');
  Weather? _weather;

  // -- fetch weather
  _fetchWeather() async{
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e){
      print(e);
    }
  }

  // -- weather animations
  String getWeatherAnimation(String? mainCondition) {
    if(mainCondition == null) return 'assets/sunny.json' ; // default to sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunder storm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';

    }
  }

  // -- init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // -- city name
            Text(
                _weather?.cityName
                    ?? 'loading city..',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // -- animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // -- temperature
            Text('${
                _weather?.temperature.round()}^C',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // -- weather condition
            Text(_weather?.mainCondition ?? ''),
          ],
        ),
      ),
    );
  }
}
