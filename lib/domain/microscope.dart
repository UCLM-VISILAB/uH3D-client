import 'package:microhikari3D_flutter/domain/inference.dart';
import 'package:microhikari3D_flutter/domain/steppers.dart';
import 'package:microhikari3D_flutter/domain/camera.dart';
import 'package:microhikari3D_flutter/domain/arduino.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

class Microscope {
  static late Uri uri;
  static late Steppers steppers;
  static late Camera camera;
  static late Arduino arduino;
  static late Inference inference;
  static bool connected = false;
  static double step = 1.0;

  static void setUriAddress(String host, int port) {
    uri = new Uri(
      scheme: 'http',
      host: host,
      port: port,
    );
  }

  static Widget connectToMicro() {
    Future<Steppers> steppersFuture = createSteppers(uri);
    return FutureBuilder<Steppers>(
      future: steppersFuture,
      builder: (context, snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          steppers = snapshot.data!;
          Future<Camera> cameraFuture = createCamera(uri);
          cameraFuture.then((value) {
            camera = value;
          });
          Future<Arduino> arduinoFuture = createArduino(uri);
          arduinoFuture.then((value) {
            arduino = value;
          });
          Future<Inference> inferenceFuture = createInference(uri);
          inferenceFuture.then((value) {
            inference = value;
          });
          connected = true;
          children = <Widget>[
            Icon(
              Mdi.checkCircle,
              color: Colors.green,
              size: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Connected'),
            )
          ];
        } else if (snapshot.hasError) {
          children = <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('ERROR check IP address'),
            )
          ];
        } else {
          children = <Widget>[
            CircularProgressIndicator(),
            Text("Connecting.."),
          ];
        }
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ));
      },
    );
  }

  static void disconnect() {
    connected = false;
  }
}
