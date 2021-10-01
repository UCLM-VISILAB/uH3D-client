import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:mdi/mdi.dart';
import 'package:microhikari3D_flutter/domain/microscope.dart';

class StepperButtonsPanel extends StatefulWidget {
  StepperButtonsPanel({Key? key}) : super(key: key);

  @override
  _StepperButtonsPanelState createState() => _StepperButtonsPanelState();
}

class _StepperButtonsPanelState extends State<StepperButtonsPanel> {
  String xPos = "xPos: ${(Microscope.steppers.xPos).toStringAsFixed(3)}";
  String yPos = "yPos: ${(Microscope.steppers.yPos).toStringAsFixed(3)}";
  String zPos = "zPos: ${(Microscope.steppers.zPos).toStringAsFixed(3)}";

  Widget textDataStepper() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 10),
          Text(xPos),
          const SizedBox(width: 10),
          Text(yPos),
          const SizedBox(width: 10),
          Text(zPos),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget dpadWidget() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Ink(
                width: 55,
                height: 55,
                decoration: const ShapeDecoration(
                  color: Colors.blue,
                  shape: BeveledRectangleBorder(),
                ),
                child: IconButton(
                  icon: Icon(Mdi.arrowUpBold),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: () {
                    Vibration.vibrate(duration: 100);
                    Future<int> futureStatusCode =
                        Microscope.steppers.moveyAxis(Microscope.step);
                    futureStatusCode.then((statusCode) => {
                          if (statusCode == 200)
                            {
                              setState(() {
                                yPos =
                                    "yPos: ${(Microscope.steppers.yPos).toStringAsFixed(3)}";
                              })
                            }
                        });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Ink(
                decoration: const ShapeDecoration(
                  color: Colors.blue,
                  shape: BeveledRectangleBorder(),
                ),
                child: IconButton(
                  icon: Icon(Mdi.arrowLeftBold),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: () {
                    Vibration.vibrate(duration: 100);
                    Future<int> futureStatusCode =
                        Microscope.steppers.movexAxis(-Microscope.step);
                    futureStatusCode.then((statusCode) => {
                          if (statusCode == 200)
                            {
                              setState(() {
                                xPos =
                                    "xPos: ${(Microscope.steppers.xPos).toStringAsFixed(3)}";
                              })
                            }
                        });
                  },
                ),
              ),
              const SizedBox(width: 2),
              Ink(
                decoration: const ShapeDecoration(
                  color: Colors.blue,
                  shape: BeveledRectangleBorder(),
                ),
                child: IconButton(
                  icon: Icon(Mdi.arrowDownBold),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: () {
                    Vibration.vibrate(duration: 100);
                    Future<int> futureStatusCode =
                        Microscope.steppers.moveyAxis(-Microscope.step);
                    futureStatusCode.then((statusCode) => {
                          if (statusCode == 200)
                            {
                              setState(() {
                                yPos =
                                    "yPos: ${(Microscope.steppers.yPos).toStringAsFixed(3)}";
                              })
                            }
                        });
                  },
                ),
              ),
              const SizedBox(width: 2),
              Ink(
                decoration: const ShapeDecoration(
                  color: Colors.blue,
                  shape: BeveledRectangleBorder(),
                ),
                child: IconButton(
                  icon: Icon(Mdi.arrowRightBold),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: () {
                    Vibration.vibrate(duration: 100);
                    Future<int> futureStatusCode =
                        Microscope.steppers.movexAxis(Microscope.step);
                    futureStatusCode.then((statusCode) => {
                          if (statusCode == 200)
                            {
                              setState(() {
                                xPos =
                                    "xPos: ${(Microscope.steppers.xPos).toStringAsFixed(3)}";
                              })
                            }
                        });
                  },
                ),
              ),
            ],
          ),
          Text(
            'Plate',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget upDownWidget() {
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Ink(
          decoration: const ShapeDecoration(
            color: Colors.blue,
            shape: BeveledRectangleBorder(),
          ),
          child: IconButton(
            icon: Icon(Mdi.plus),
            iconSize: 40,
            color: Colors.white,
            onPressed: () {
              Vibration.vibrate(duration: 100);
              Future<int> futureStatusCode =
                  Microscope.steppers.movezAxis(Microscope.step);
              futureStatusCode.then((statusCode) => {
                    if (statusCode == 200)
                      {
                        setState(() {
                          zPos =
                              "zPos: ${(Microscope.steppers.zPos).toStringAsFixed(3)}";
                        })
                      }
                  });
            },
          ),
        ),
        const SizedBox(height: 2),
        Ink(
          decoration: const ShapeDecoration(
            color: Colors.blue,
            shape: BeveledRectangleBorder(),
          ),
          child: IconButton(
            icon: Icon(Mdi.minus),
            iconSize: 40,
            color: Colors.white,
            onPressed: () {
              Vibration.vibrate(duration: 100);
              Future<int> futureStatusCode =
                  Microscope.steppers.movezAxis(-Microscope.step);
              futureStatusCode.then((statusCode) => {
                    if (statusCode == 200)
                      {
                        setState(() {
                          zPos =
                              "zPos: ${(Microscope.steppers.zPos).toStringAsFixed(3)}";
                        })
                      }
                  });
            },
          ),
        ),
        Text(
          'Camera',
          textAlign: TextAlign.center,
        ),
      ],
    ));
  }

  Widget centralButtonsWidget() {
    return Container(
        child: Column(
      children: [
        Ink(
          decoration: const ShapeDecoration(
            color: Colors.blue,
            shape: BeveledRectangleBorder(),
          ),
          child: IconButton(
            icon: Icon(Mdi.imageFilterCenterFocus),
            iconSize: 40,
            color: Colors.white,
            onPressed: () {
              Vibration.vibrate(duration: 100);
              Future<int> futureStatusCode = Microscope.steppers.center();
              futureStatusCode.then((statusCode) => {
                    if (statusCode == 200)
                      {
                        setState(() {
                          xPos = "xPos: ${Microscope.steppers.xPos}";
                          yPos = "yPos: ${Microscope.steppers.yPos}";
                          zPos = "zPos: ${Microscope.steppers.zPos}";
                        })
                      }
                  });
            },
          ),
        ),
        const SizedBox(height: 2),
        Ink(
          decoration: const ShapeDecoration(
            color: Colors.blue,
            shape: BeveledRectangleBorder(),
          ),
          child: IconButton(
            icon: Icon(Mdi.home),
            iconSize: 40,
            color: Colors.white,
            onPressed: () {
              Vibration.vibrate(duration: 100);
              Future<int> futureStatusCode = Microscope.steppers.home();
              futureStatusCode.then((statusCode) => {
                    if (statusCode == 200)
                      {
                        setState(() {
                          xPos = "xPos: 0.000";
                          yPos = "yPos: 0.000";
                          zPos = "zPos: 0.000";
                        })
                      }
                  });
            },
          ),
        ),
        const SizedBox(height: 15),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          textDataStepper(),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: dpadWidget(),
              ),
              Expanded(
                child: Container(),
              ),
              centralButtonsWidget(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: upDownWidget(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Speed'),
                const SizedBox(width: 5),
                SpeedPicker(),
                Expanded(
                  child: Container(),
                ),
                Text('Step'),
                const SizedBox(width: 5),
                StepPicker(),
              ],
            ),
          ),
        ]));
  }
}

class SpeedPicker extends StatefulWidget {
  SpeedPicker({Key? key}) : super(key: key);

  @override
  _SpeedPickerState createState() => _SpeedPickerState();
}

/// This is the private State class that goes with SpeedPicker.
class _SpeedPickerState extends State<SpeedPicker> {
  String dropdownValue = 'Low';

  int? _getIntFromDropdownValue(String dropdownValue) {
    var feedrateMap = {'Low': 100, 'Medium': 1000, 'High': 1500, 'Max Q': 3000};
    return feedrateMap[dropdownValue];
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

          Microscope.steppers
              .setFeedrate(_getIntFromDropdownValue(dropdownValue)!);
        });
      },
      items: <String>['Low', 'Medium', 'High', 'Max Q']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class StepPicker extends StatefulWidget {
  StepPicker({Key? key}) : super(key: key);

  @override
  _StepPickerState createState() => _StepPickerState();
}

/// This is the private State class that goes with StepPicker.
class _StepPickerState extends State<StepPicker> {
  String dropdownValue = '1';

  double? _getIntFromDropdownValue(String dropdownValue) {
    var stepMap = {'10': 10.0, '1': 1.0, '0.1': 0.1, '0.025': 0.025};
    return stepMap[dropdownValue];
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

          Microscope.step = _getIntFromDropdownValue(dropdownValue)!.toDouble();
        });
      },
      items: <String>['10', '1', '0.1', '0.025']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
