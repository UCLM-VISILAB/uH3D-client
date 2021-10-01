import 'package:flutter/material.dart';
import 'package:microhikari3D_flutter/presentation/ai_panel.dart';
import 'package:microhikari3D_flutter/presentation/settings_screen.dart';
import 'package:microhikari3D_flutter/presentation/steppers_panel.dart';
import 'package:microhikari3D_flutter/presentation/camera_panel.dart';
import 'package:microhikari3D_flutter/presentation/lights_panel.dart';
import 'package:microhikari3D_flutter/domain/microscope.dart';
import 'package:mdi/mdi.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  //StreamPlayer _streamPlayer = StreamPlayer();
  String videoUri = '${Microscope.uri}/video_feed.mjpeg';

  static List<Widget> _widgetOptions = <Widget>[
    StepperButtonsPanel(),
    CameraButtonsPanel(),
    AiPanel(), //placeholder for imageclassification panel
    LightsPanel(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.mediaLibrary,
      Permission.photos,
      Permission.camera,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  Widget _portraitView() {
    return Container(
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        AspectRatio(
            aspectRatio: 4 / 3,
            //interactiveViewer
            child: InteractiveViewer( child: Mjpeg(
              stream: videoUri,
              isLive: true,
            )),
            ),
        _widgetOptions.elementAt(_selectedIndex),
      ]),
    );
  }

  Widget _landscapeView() {
    return Container(
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: InteractiveViewer(
              child: Mjpeg(
            stream: videoUri,
            isLive: true,
          )),
        ),
        _widgetOptions.elementAt(_selectedIndex),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MicroHikari3D'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return Center(
            child: orientation == Orientation.portrait
                ? _portraitView()
                : _landscapeView());
      }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Mdi.cameraControl),
            label: 'Steppers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Mdi.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Mdi.brain),
            label: 'AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Mdi.alarmLight),
            label: 'Lights',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
