import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:vibration/vibration.dart';
import 'package:microhikari3D_flutter/domain/microscope.dart';

class CameraButtonsPanel extends StatefulWidget {
  CameraButtonsPanel({Key? key}) : super(key: key);

  @override
  _CameraButtonsPanelState createState() => _CameraButtonsPanelState();
}

/// This is the private State class that goes with PanoramaWidget.
class _CameraButtonsPanelState extends State<CameraButtonsPanel> {
  int _stateAutofocus = 0;
  int _stateCamera = 0;

  Widget getAutofocusButtonChild(Text child) {
    if (_stateAutofocus == 0) {
      return child;
    } else if (_stateAutofocus == 1) {
      return Center(
          child: SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2.0,
              )));
    }
    return child;
  }

  Widget getCameraButtonChild(Icon child) {
    if (_stateCamera == 0) {
      return child;
    } else if (_stateCamera == 1) {
      return Center(
          child: SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2.0,
              )));
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _stateAutofocus = 1;
                  });
                  Vibration.vibrate(duration: 100);
                  Microscope.camera.focus().then((status) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Autofocus done')));
                    setState(() {
                      _stateAutofocus = 0;
                    });
                  });
                },
                child: getAutofocusButtonChild(Text('AF')),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _stateCamera = 1;
                  });
                  Vibration.vibrate(duration: 100);
                  Microscope.camera.takePhoto().then((status) {
                    if (status == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Photo saved')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Server error')));
                    }
                    setState(() {
                      _stateCamera = 0;
                    });
                  });
                },
                child: getCameraButtonChild(Icon(
                  Mdi.camera,
                )),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _stateAutofocus = 1;
                  });
                  Vibration.vibrate(duration: 100);
                  Microscope.camera.focusFine().then((status) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fine autofocus done')));
                    setState(() {
                      _stateAutofocus = 0;
                    });
                  });
                },
                child: getAutofocusButtonChild(Text('AFᶠ')),
              ),
            ],
          ),
          Divider(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                'Focus Stack',
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          FocusStackWidget(),
          Divider(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                'Panorama',
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          PanoramaWidget(),
        ],
      ),
    );
  }
}

class FocusStackWidget extends StatefulWidget {
  FocusStackWidget({Key? key}) : super(key: key);

  @override
  _FocusStackWidgetState createState() => _FocusStackWidgetState();
}

/// This is the private State class that goes with PanoramaWidget.
class _FocusStackWidgetState extends State<FocusStackWidget> {
  int _stateFS = 0;

  Widget getFSButtonChild(Icon child) {
    if (_stateFS == 0) {
      return child;
    } else if (_stateFS == 1) {
      return Center(
          child: SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2.0,
              )));
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: FocusStackNfocusPicker()),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _stateFS = 1;
                });
                Vibration.vibrate(duration: 100);
                Microscope.camera.takeFocusStackPhoto().then((status) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Focus Stacked photo saved')));
                  setState(() {
                    _stateFS = 0;
                  });
                });
              },
              child: getFSButtonChild(Icon(
                Mdi.plusBoxMultiple,
              )),
            ),
          ),
        ]));
  }
}

class PanoramaWidget extends StatefulWidget {
  PanoramaWidget({Key? key}) : super(key: key);

  @override
  _PanoramaWidgetState createState() => _PanoramaWidgetState();
}

/// This is the private State class that goes with PanoramaWidget.
class _PanoramaWidgetState extends State<PanoramaWidget> {
  bool _focusstack = false;
  int _statePano = 0;

  Widget getPanoButtonChild(Icon child) {
    if (_statePano == 0) {
      return child;
    } else if (_statePano == 1) {
      return Center(
          child: SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2.0,
              )));
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PanoramaFovXPicker(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('x'),
            ),
            PanoramaFovYPicker(),
            Checkbox(
              value: _focusstack,
              onChanged: (bool? newValue) {
                setState(() {
                  _focusstack = newValue!;
                  Microscope.camera.focusstack = newValue;
                });
              },
            ),
            Text('FS'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _statePano = 1;
                    });
                    Vibration.vibrate(duration: 100);
                    Microscope.camera.takePanoramaPhoto().then((status) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Focus Stacked photo saved')));
                      setState(() {
                        _statePano = 0;
                      });
                    });
                  },
                  child: getPanoButtonChild(Icon(Mdi.panoramaHorizontal))),
            ),
          ],
        ),
      ),
    );
  }
}

class FocusStackNfocusPicker extends StatefulWidget {
  FocusStackNfocusPicker({Key? key}) : super(key: key);

  @override
  _FocusStackNfocusPickerState createState() => _FocusStackNfocusPickerState();
}

/// This is the private State class that goes with StepPicker.
class _FocusStackNfocusPickerState extends State<FocusStackNfocusPicker> {
  int? dropdownValue = 3;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: dropdownValue,
      iconSize: 30,
      elevation: 16,
      style: TextStyle(color: Colors.blue),
      underline: Container(
        height: 3,
        color: Colors.blueAccent,
      ),
      onChanged: (int? newValue) {
        setState(() {
          dropdownValue = newValue;
          //send rest to  feedrate Microscope

          Microscope.camera.nfocus = dropdownValue!;
        });
      },
      items: <int>[7, 5, 3].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}

class PanoramaFovXPicker extends StatefulWidget {
  PanoramaFovXPicker({Key? key}) : super(key: key);

  @override
  _PanoramaFovXPickerState createState() => _PanoramaFovXPickerState();
}

/// This is the private State class that goes with PanoramaFovXPicker.
class _PanoramaFovXPickerState extends State<PanoramaFovXPicker> {
  int? dropdownValue = 3;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: dropdownValue,
      iconSize: 30,
      elevation: 16,
      style: TextStyle(color: Colors.blue),
      underline: Container(
        height: 3,
        color: Colors.blueAccent,
      ),
      onChanged: (int? newValue) {
        setState(() {
          dropdownValue = newValue;
          //send rest to  feedrate Microscope
          Microscope.camera.fovx = dropdownValue!;
        });
      },
      items: <int>[2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}

class PanoramaFovYPicker extends StatefulWidget {
  PanoramaFovYPicker({Key? key}) : super(key: key);

  @override
  _PanoramaFovYPickerState createState() => _PanoramaFovYPickerState();
}

/// This is the private State class that goes with PanoramaFovYPicker.
class _PanoramaFovYPickerState extends State<PanoramaFovYPicker> {
  int? dropdownValue = 3;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: dropdownValue,
      iconSize: 30,
      elevation: 16,
      style: TextStyle(color: Colors.blue),
      underline: Container(
        height: 3,
        color: Colors.blueAccent,
      ),
      onChanged: (int? newValue) {
        setState(() {
          dropdownValue = newValue;
          //send rest to  feedrate Microscope
          Microscope.camera.fovy = dropdownValue!;
        });
      },
      items: <int>[2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}
