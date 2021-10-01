import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Inference> createInference(Uri uri) async {
  uri = new Uri(
      scheme: uri.scheme, host: uri.host, port: uri.port, path: "/inference");
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return Inference.fromJson(uri, jsonDecode(response.body));
  } else {
    throw Exception('Failed to create Inference');
  }
}

class Inference {
  Uri uri;
  List<dynamic> models;
  String model;

  Inference({
    required this.uri,
    required this.models,
    required this.model,
  });

  factory Inference.fromJson(Uri uri, Map<String, dynamic> json) {
    return Inference(
        uri: uri, models: json['models'], model: json['models'][0]);
  }

  Future<List<dynamic>?> getResults() async {
    Uri inferenceUri = new Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        path: '/inference',
        query: 'model=$model');
    late List<dynamic> result;
    print(inferenceUri);
    var response = await http.get(inferenceUri);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      result = json.decode(response.body);
    }
    print(result);
    return result;
  }

  Future<String?> getLabeledResults() async {
    var result = await getResults();
    // ignore: unused_local_variable
    String label = '';
    var bestResult = 0.0;
    result!.forEach((element) {
      if (element[1] > bestResult) {
        bestResult = element[1];
        label = element[0];
      }
    });
    return '$label: $bestResult %';
  }

  List<String> getModels() {
    List<String> output = [];
    models.forEach((value) {
      output.add(value);
    });
    return output;
  }
}
