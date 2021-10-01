import 'package:flutter/material.dart';
import 'package:microhikari3D_flutter/domain/microscope.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CameraSettingsWidget(),
          ],
        ),
      ),
    );
  }
}

class CameraSettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.only(left: 20),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                'Camera Settings',
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.start,
              ),
            )),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Text('Photo Resolution'),
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              child: PhotoResolutionPickerWidget(),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Text('Stream Resolution'),
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              child: StreamResolutionPickerWidget(),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Text('Filter'),
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              child: FilterPickerWidget(),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Text('ISO'),
            ),
            Expanded(
              child: Container(),
            ),
            SliderISOWidget(),
          ],
        ),
        Divider(),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Text('Sharpness'),
            ),
            Expanded(
              child: Container(),
            ),
            SliderSharpnessWidget(),
          ],
        ),
        Divider(),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Text('Saturation'),
            ),
            Expanded(
              child: Container(),
            ),
            SliderSaturationWidget(),
          ],
        ),
        Divider(),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Text('Change lens'),
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              child: ElevatedButton(
                  onPressed: () {
                    Microscope.steppers.changeLens();
                  },
                  child: Text('Start')),
            ),
          ],
        ),
      ],
    );
  }
}

class SliderISOWidget extends StatefulWidget {
  SliderISOWidget({Key? key}) : super(key: key);

  @override
  _SliderWidgetISOState createState() => _SliderWidgetISOState();
}

/// This is the private State class that goes with SliderISOWidget.
class _SliderWidgetISOState extends State<SliderISOWidget> {
  double _currentSliderValue = 0;

  int? getISOValuesFromState(int currentState) {
    var valueMap = {
      0: 0,
      1: 100,
      2: 200,
      3: 320,
      4: 400,
      5: 500,
      6: 600,
      7: 640,
      8: 800
    };

    return valueMap[currentState];
  }

  double? getStateValuesFromISO(int iso) {
    var valueMap = {
      0: 0.0,
      100: 1.0,
      200: 2.0,
      320: 3.0,
      400: 4.0,
      500: 5.0,
      600: 6.0,
      640: 7.0,
      800: 8.0
    };

    return valueMap[iso];
  }

  String getStringFromISOValue(int isoValue) {
    String isoString = 'Auto';
    if (isoValue != 0) {
      isoString = isoValue.toString();
    }
    return isoString;
  }

  @override
  void initState() {
    super.initState();
    _currentSliderValue = getStateValuesFromISO(Microscope.camera.iso)!;
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      min: 0,
      max: 8,
      divisions: 8,
      label: getStringFromISOValue(
          getISOValuesFromState(_currentSliderValue.round())!),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
      onChangeEnd: (double value) {
        Microscope.camera
            .setISO(getISOValuesFromState(_currentSliderValue.round())!);
      },
    );
  }
}

class SliderSharpnessWidget extends StatefulWidget {
  SliderSharpnessWidget({Key? key}) : super(key: key);

  @override
  _SliderSharpnessState createState() => _SliderSharpnessState();
}

/// This is the private State class that goes with SliderSharpnessWidget.
class _SliderSharpnessState extends State<SliderSharpnessWidget> {
  double _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = Microscope.camera.sharpness + .0;
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      min: -100,
      max: 100,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
      onChangeEnd: (double value) {
        Microscope.camera.setSharpness(value.round());
      },
    );
  }
}

class SliderSaturationWidget extends StatefulWidget {
  SliderSaturationWidget({Key? key}) : super(key: key);

  @override
  _SliderSaturationState createState() => _SliderSaturationState();
}

/// This is the private State class that goes with SliderSharpnessWidget.
class _SliderSaturationState extends State<SliderSaturationWidget> {
  double _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = Microscope.camera.saturation + .0;
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      min: -100,
      max: 100,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
      onChangeEnd: (double value) {
        Microscope.camera.setSaturation(value.round());
      },
    );
  }
}

class PhotoResolutionPickerWidget extends StatefulWidget {
  PhotoResolutionPickerWidget({Key? key}) : super(key: key);

  @override
  _PhotoResolutionPickerWidgetState createState() =>
      _PhotoResolutionPickerWidgetState();
}

/// This is the private State class that goes with PhotoResolutionPickerWidget.
class _PhotoResolutionPickerWidgetState
    extends State<PhotoResolutionPickerWidget> {
  String dropdownValue = '4056 x 3040';

  int? _getIntFromDropdownValue(String dropdownValue) {
    var stepMap = {'4056 x 3040': 1, '3280 x 2464': 2};
    return stepMap[dropdownValue];
  }

  @override
  void initState() {
    super.initState();
    dropdownValue =
        "${Microscope.camera.photoResolution[0]} x ${Microscope.camera.photoResolution[1]}";
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      iconSize: 30,
      elevation: 16,
      style: TextStyle(color: Colors.blue),
      underline: Container(
        height: 3,
        color: Colors.blueAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue.toString();
          //send rest to  feedrate Microscope

          Microscope.camera
              .setPhotoResolution(_getIntFromDropdownValue(dropdownValue)!);
        });
      },
      items: <String>['4056 x 3040', '3280 x 2464']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class StreamResolutionPickerWidget extends StatefulWidget {
  StreamResolutionPickerWidget({Key? key}) : super(key: key);

  @override
  _StreamResolutionPickerWidgetState createState() =>
      _StreamResolutionPickerWidgetState();
}

/// This is the private State class that goes with PhotoResolutionPickerWidget.
class _StreamResolutionPickerWidgetState
    extends State<StreamResolutionPickerWidget> {
  String dropdownValue = '1640 x 1232';

  int? _getIntFromDropdownValue(String dropdownValue) {
    var stepMap = {'1640 x 1232': 1, '1280 x 960': 2, '640 x 480': 3};
    return stepMap[dropdownValue];
  }

  @override
  void initState() {
    super.initState();
    dropdownValue =
        "${Microscope.camera.streamResolution[0]} x ${Microscope.camera.streamResolution[1]}";
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      iconSize: 30,
      elevation: 16,
      style: TextStyle(color: Colors.blue),
      underline: Container(
        height: 3,
        color: Colors.blueAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue.toString();
          //send rest to  feedrate Microscope

          Microscope.camera
              .setStreamResolution(_getIntFromDropdownValue(dropdownValue)!);
        });
      },
      items: <String>['1640 x 1232', '1280 x 960', '640 x 480']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class FilterPickerWidget extends StatefulWidget {
  FilterPickerWidget({Key? key}) : super(key: key);

  @override
  _FilterPickerWidgetState createState() => _FilterPickerWidgetState();
}

/// This is the private State class that goes with FilterPickerWidget.
class _FilterPickerWidgetState extends State<FilterPickerWidget> {
  String dropdownValue = 'None';

  String? _getFilterFromDropdownValue(String dropdownValue) {
    var stepMap = {'None': 'none', 'Color correction': 'color'};
    return stepMap[dropdownValue];
  }

  String? _getDropdownValueFromFilter(String filter) {
    var stepMap = {'none': 'None', 'color': 'Color correction'};
    return stepMap[filter];
  }

  @override
  void initState() {
    super.initState();
    dropdownValue =
        _getDropdownValueFromFilter(Microscope.camera.filter).toString();
    print(Microscope.camera.filter);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      iconSize: 30,
      elevation: 16,
      style: TextStyle(color: Colors.blue),
      underline: Container(
        height: 3,
        color: Colors.blueAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue.toString();
          //send rest to  feedrate Microscope

          Microscope.camera.filter =
              _getFilterFromDropdownValue(dropdownValue)!;
        });
      },
      items: <String>['None', 'Color correction']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
