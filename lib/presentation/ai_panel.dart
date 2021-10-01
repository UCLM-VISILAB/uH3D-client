import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:microhikari3D_flutter/domain/microscope.dart';

class AiPanel extends StatefulWidget {
  AiPanel({Key? key}) : super(key: key);

  @override
  _AiPanelState createState() => _AiPanelState();
}

/// This is the private State class that goes with StepPicker.
class _AiPanelState extends State<AiPanel> {
  Widget result = Text('');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('Model'),
              ),
              ModelPicker(),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("Infer"),
                onPressed: () {
                  Vibration.vibrate(duration: 100);
                  setState(() {
                    result = new FutureBuilder<String?>(
                        future: Microscope.inference.getLabeledResults(),
                        builder: (context, snapshot) {
                          Widget children = CircularProgressIndicator();
                          if (snapshot.hasData) {
                            children = Text(
                              snapshot.data.toString(),
                              style: TextStyle(fontSize: 25.0),
                            );
                          } else {
                            children = CircularProgressIndicator();
                            print('No data :(');
                          }
                          return children;
                        });
                  });
                },
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
                'Result',
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Container(padding: const EdgeInsets.only(top: 20), child: result),
        ],
      ),
    );
  }
}

class ModelPicker extends StatefulWidget {
  ModelPicker({Key? key}) : super(key: key);

  @override
  _ModelPickerState createState() => _ModelPickerState();
}

/// This is the private State class that goes with StepPicker.
class _ModelPickerState extends State<ModelPicker> {
  String? dropdownValue = Microscope.inference.model;
  List<String>? models = Microscope.inference.getModels();

  @override
  void initState() {
    super.initState();
    models = Microscope.inference.getModels();
    dropdownValue = Microscope.inference.model;
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
          dropdownValue = newValue;
          Microscope.inference.model = newValue!;
        });
      },
      items: models!.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}
