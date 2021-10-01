import 'package:http/http.dart' as http;
import 'dart:convert';

/*
Steppers getSteppers(String uri) {
  Future<Steppers> futureSteppers = createSteppers(uri);
  futureSteppers.then((value) {
    return value;
  }).catchError((e) {
    print(e);
    return null;
  });
}
*/

Future<Steppers> createSteppers(Uri uri) async {
  uri = new Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.port,
      path: "/api/v1/steppers");
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return Steppers.fromJson(uri, jsonDecode(response.body));
  } else {
    throw Exception('Failed to create Steppers');
  }
}

class Steppers {
  Uri uri;
  double feedrate = 100.0;
  double xPos, yPos, zPos;

  Steppers(
      {required this.uri,
      required this.feedrate,
      required this.xPos,
      required this.yPos,
      required this.zPos});

  factory Steppers.fromJson(Uri uri, Map<String, dynamic> json) {
    return Steppers(
        uri: uri,
        feedrate: json['feedrate'] + .0,
        xPos: json['xPos'] + .0,
        yPos: json['yPos'] + .0,
        zPos: json['zPos'] + .0);
  }

  void updateState(String responseBody) {
    Map<String, dynamic> responseMap = jsonDecode(responseBody);
    this.feedrate = responseMap['feedrate'] + .0;
    this.xPos = responseMap['xPos'] + .0;
    this.yPos = responseMap['yPos'] + .0;
    this.zPos = responseMap['zPos'] + .0;
  }

  Future<int> movexAxis(double step) async {
    var response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, double>{
        'xAxis': step,
      }),
    );
    if (response.statusCode == 200) {
      updateState(response.body);
    }
    return response.statusCode;
  }

  Future<int> movezAxis(double step) async {
    var response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, double>{
        'zAxis': step,
      }),
    );
    if (response.statusCode == 200) {
      updateState(response.body);
    }
    return response.statusCode;
  }

  Future<int> moveyAxis(double step) async {
    var response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, double>{
        'yAxis': step,
      }),
    );
    if (response.statusCode == 200) {
      updateState(response.body);
    }
    return response.statusCode;
  }

  Future<int> setFeedrate(int feedrate) async {
    var response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'feedrate': feedrate,
      }),
    );
    if (response.statusCode == 200) {
      updateState(response.body);
    }
    return response.statusCode;
  }

  Future<int> home() async {
    Uri homeUri = new Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        path: uri.path + '/home');
    var response = await http.get(homeUri);
    if (response.statusCode == 200) {
      print('Sent home');
    }
    return response.statusCode;
  }

  Future<int> center() async {
    Uri homeUri = new Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        path: uri.path + '/center');
    var response = await http.get(homeUri);
    if (response.statusCode == 200) {
      print('Centered');
    }
    return response.statusCode;
  }

  Future<int> changeLens() async {
    Uri lensUri = new Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        path: uri.path + '/changelens');
    var response = await http.get(lensUri);
    if (response.statusCode == 200) {
      print('ChangeLens ok');
    }
    return response.statusCode;
  }
}
