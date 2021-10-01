import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Camera> createCamera(Uri uri) async {
  uri = new Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.port,
      path: "/api/v1/camera");
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return Camera.fromJson(uri, jsonDecode(response.body));
  } else {
    throw Exception('Failed to create Camera');
  }
}

class Camera {
  Uri uri;
  int iso, sharpness, saturation;
  int nfocus = 3;
  int fovx = 5;
  int fovy = 5;
  bool focusstack = false;
  String filter;
  double stepPerFov = 0.7;
  var photoResolution, streamResolution;

  Camera(
      {required this.uri,
      required this.iso,
      required this.sharpness,
      required this.saturation,
      required this.photoResolution,
      required this.streamResolution,
      required this.filter});

  factory Camera.fromJson(Uri uri, Map<String, dynamic> json) {
    return Camera(
        uri: uri,
        iso: json['iso'],
        sharpness: json['sharpness'],
        saturation: json['saturation'],
        photoResolution: json['photo_resolution'],
        streamResolution: json['stream_resolution'],
        filter: 'none');
  }

  void updateState(String responseBody) {
    Map<String, dynamic> responseMap = jsonDecode(responseBody);
    this.iso = responseMap['iso'];
    this.sharpness = responseMap['sharpness'];
    this.saturation = responseMap['saturation'];
    this.photoResolution = responseMap['photo_resolution'];
    this.streamResolution = responseMap['stream_resolution'];
    print(responseMap);
  }

  Future<int> setISO(int iso) async {
    var response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'iso': iso,
      }),
    );
    if (response.statusCode == 200) {
      updateState(response.body);
    }
    return response.statusCode;
  }

  Future<int> setSharpness(int sharpness) async {
    var response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'sharpness': sharpness,
      }),
    );
    if (response.statusCode == 200) {
      updateState(response.body);
    }
    return response.statusCode;
  }

  Future<int> setSaturation(int saturation) async {
    var response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'saturation': saturation,
      }),
    );
    if (response.statusCode == 200) {
      updateState(response.body);
    }
    return response.statusCode;
  }

  Future<int> setPhotoResolution(int resolutionMode) async {
    var resolutionModeMap = {
      1: [4056, 3040],
      2: [3280, 2464]
    };
    List<int> resolution = resolutionModeMap[resolutionMode]!;
    var response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, List<int>>{
        'photo_resolution': resolution,
      }),
    );
    if (response.statusCode == 200) {
      updateState(response.body);
    }
    return response.statusCode;
  }

  Future<int> setStreamResolution(int resolutionMode) async {
    var resolutionModeMap = {
      1: [1640, 1232],
      2: [1280, 960],
      3: [640, 480]
    };
    List<int> resolution = resolutionModeMap[resolutionMode]!;
    var response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, List<int>>{
        'stream_resolution': resolution,
      }),
    );
    if (response.statusCode == 200) {
      updateState(response.body);
    }
    return response.statusCode;
  }

  Future<int> focus() async {
    Uri focusUri = new Uri(
        scheme: uri.scheme, host: uri.host, port: uri.port, path: '/autofocus');
    print(focusUri);
    var response = await http.get(focusUri);
    return response.statusCode;
  }

  Future<int> focusFine() async {
    Uri focusUri = new Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        path: '/autofocus',
        query: 'fine');
    print(focusUri);
    var response = await http.get(focusUri);
    return response.statusCode;
  }

  Future<int?> takePhoto() async {
    Uri photoUri = new Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        path: '/photo.jpg',
        query: 'filter=$filter');
    var now = new DateTime.now();
    late Future<bool?> result;
    var response = await http.get(photoUri);
    print('Response status: ${response.statusCode}');
    print(photoUri);
    if (response.statusCode == 200) {
      print('Saving photo');
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File photo = new File('$tempPath/$now.jpg');
      await photo.writeAsBytes(response.bodyBytes);
      result = GallerySaver.saveImage(photo.path, albumName: 'MicroHikari3D');
    }
    return response.statusCode;
  }

  Future<int?> takeFocusStackPhoto() async {
    Uri photoUri = new Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        path: '/focusstackphoto.jpg',
        query: 'nfocus=$nfocus&filter=$filter');
    var now = new DateTime.now();
    late Future<bool?> result;
    var response = await http.get(photoUri);
    print('Response status: ${response.statusCode}');
    print(photoUri);
    if (response.statusCode == 200) {
      print('Saving photo');
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File photo = new File('$tempPath/$now.jpg');
      await photo.writeAsBytes(response.bodyBytes);
      result = GallerySaver.saveImage(photo.path, albumName: 'MicroHikari3D');
    }
    return response.statusCode;
  }

  Future<int?> takePanoramaPhoto() async {
    Uri photoUri = new Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        path: '/stitch',
        query: 'fovx=$fovx&fovy=$fovy&focusstack=$focusstack');
    var now = new DateTime.now();
    late Future<bool?> result;
    print(photoUri);
    var response = await http.get(photoUri);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Saving panorama');
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File photo = new File('$tempPath/$now.jpg');
      await photo.writeAsBytes(response.bodyBytes);
      result = GallerySaver.saveImage(photo.path, albumName: 'MicroHikari3D');
    }
    return response.statusCode;
  }
}
