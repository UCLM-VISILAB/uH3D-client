import 'package:microhikari3D_flutter/domain/microscope.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:mdi/mdi.dart';

class LightsPanel extends StatelessWidget {
  LightsPanel({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          const SizedBox(height: 10),
          ColorPickerWidget(),
          const SizedBox(height: 10),
          LightSwitches(),
        ]));
  }
}

class LightSwitches extends StatefulWidget {
  LightSwitches({Key? key}) : super(key: key);

  @override
  _LightSwitchesState createState() => _LightSwitchesState();
}

class _LightSwitchesState extends State<LightSwitches> {
  bool _buttomLed = true;

  @override
  void initState() {
    super.initState();
    _buttomLed = Microscope.arduino.bottomLight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Bottom Lights'),
            value: _buttomLed,
            onChanged: (bool value) {
              setState(() {
                Future<int> futureRequest =
                    Microscope.arduino.setBottomLight(value);
                futureRequest.then((statusCode) {
                  if (statusCode == 200) {
                    _buttomLed = value;
                    setState(() {
                      _buttomLed = value;
                    });
                  }
                });
              });
            },
            secondary: const Icon(
              Mdi.wallSconceFlatVariant,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class ColorPickerWidget extends StatefulWidget {
  ColorPickerWidget({Key? key}) : super(key: key);

  @override
  _ColorPickerWidgetState createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  // Color for the picker shown in Card on the screen.
  late Color screenPickerColor;
  // Color for the picker in a dialog using onChanged.
  late Color dialogPickerColor;
  // Color for picker using the color select dialog.
  late Color dialogSelectColor;

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      // Use the dialogPickerColor as start color.
      color: dialogPickerColor,
      // Update the dialogPickerColor using the callback.
      onColorChanged: (Color color) => setState(() {
        dialogPickerColor = color;
      }),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 300,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.caption,
      colorNameTextStyle: Theme.of(context).textTheme.caption,
      colorCodeTextStyle: Theme.of(context).textTheme.caption,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: true,
      },
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }

  @override
  void initState() {
    super.initState();
    screenPickerColor = Colors.white; // Material white.
    dialogPickerColor = Colors.white; // Material white.
    dialogSelectColor = const Color(0xFFA239CA); // A purple color.
  }

  @override
  Widget build(BuildContext context) {
    return // Pick color in a dialog.
        ListTile(
      title: Row(
        children: [
          Icon(
            Mdi.wallSconceFlat,
            color: Colors.grey,
          ),
          const SizedBox(width: 30),
          const Text('RGB Ring'),
        ],
      ),
      subtitle: Row(
        children: [
          const SizedBox(width: 54),
          Text(
            'R${dialogPickerColor.red} G${dialogPickerColor.green} B${dialogPickerColor.blue}',
          ),
        ],
      ),
      trailing: ColorIndicator(
        width: 44,
        height: 44,
        borderRadius: 4,
        hasBorder: true,
        color: dialogPickerColor,
        onSelectFocus: false,
        onSelect: () async {
          // Store current color before we open the dialog.
          final Color colorBeforeDialog = dialogPickerColor;
          // Wait for the picker to close, if dialog was dismissed,
          // then restore the color we had before it was opened.
          if (!(await colorPickerDialog())) {
            setState(() {
              dialogPickerColor = colorBeforeDialog;
            });
          } else {
            Microscope.arduino.setRGBringColor(dialogPickerColor);
          }
        },
      ),
    );
  }
}
