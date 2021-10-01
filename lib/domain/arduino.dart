import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

Future<Arduino> createArduino(Uri uri) async {
  uri = new Uri(
      scheme: uri.scheme, host: uri.host, port: uri.port, path: "/api/v1/leds");
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return Arduino.fromJson(uri, jsonDecode(response.body));
  } else {
    throw Exception('Failed to create Arduino');
  }
}

class Arduino {
  Uri uri;
  bool bottomLight = true;
  late int red, green, blue, white;

  Arduino({required this.uri, required this.bottomLight});

  factory Arduino.fromJson(Uri uri, Map<String, dynamic> json) {
    return Arduino(uri: uri, bottomLight: json['bottom_light']);
  }

  void updateState(String responseBody) {
    Map<String, dynamic> responseMap = jsonDecode(responseBody);
    this.bottomLight = responseMap['bottom_light'];
    print(responseMap);
  }

  Future<int> setBottomLight(bool state) async {
    var response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, bool>{
        'bottom_light': state,
      }),
    );
    if (response.statusCode == 200) {
      updateState(response.body);
    }
    return response.statusCode;
  }

  Future<int> setRGBringColor(Color newColor) async {
    if (newColor.red == 255 && newColor.green == 255 && newColor.blue == 255) {
      return setRGBringtoWhite();
    } else {
      var response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, int>{
          'rgbw_red': newColor.red,
          'rgbw_green': newColor.green,
          'rgbw_blue': newColor.blue,
          'rgbw_white': 0,
        }),
      );
      if (response.statusCode == 200) {
        updateState(response.body);
      }
      return response.statusCode;
    }
  }

  Future<int> setRGBringtoWhite() async {
    var response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'rgbw_red': 0,
        'rgbw_green': 0,
        'rgbw_blue': 0,
        'rgbw_white': 255,
      }),
    );
    if (response.statusCode == 200) {
      updateState(response.body);
    }
    return response.statusCode;
  }
}
