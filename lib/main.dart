// @dart=2.9
import 'package:microhikari3D_flutter/presentation/welcome_screen.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Lock portrait orientation in phone mode
  if (Device.get().isPhone) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  runApp(MicroHikari3sApp());
}

class MicroHikari3sApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MicroHikari3D',
        theme: ThemeData(
          brightness: Brightness.light,
          /* light theme settings */
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          /* dark theme settings */
        ),
        themeMode: ThemeMode.system,
        home: WelcomeScreen());
  }
}
