import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';


class WeatherServices{
  static const Base_Url = 'https://home.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherServices({required this.apiKey});

  Future<Weather> getWeather(String cityName)async{
    final response = await http.get(Uri.parse('$Base_Url?q=$cityName&appid=$apiKey&units=metric'));

    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Weather data');
    }
  }

  Future<String> getCurrentCity() async{
    // get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    // fetch the current location (Because now permission is given)
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    // convert the location into a list of placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    // extract the city name from the first placemark
    String? city = placemarks[0].locality;

    return city ?? '';
  }
}


