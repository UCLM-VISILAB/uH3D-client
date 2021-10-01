import 'package:microhikari3D_flutter/domain/microscope.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:microhikari3D_flutter/presentation/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to MicroHikari3D'),
            IpAddressInput(),
          ],
        ),
      ),
    );
  }
}

class IpAddressInput extends StatefulWidget {
  IpAddressInput({Key? key}) : super(key: key);

  @override
  _IpAddressInputState createState() => _IpAddressInputState();
}

class _IpAddressInputState extends State<IpAddressInput> {
  final _formKey = GlobalKey<FormState>();
  late String _ip;
  String _lastIp = '';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _lastIpFuture;

  Future<void> _saveIpAddress() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _lastIpFuture = prefs.setString("lastIp", _lastIp).then((bool success) {
        return _lastIp;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _lastIpFuture = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('lastIp') ?? '');
    });
    _lastIpFuture.then((value) => _lastIp);
  }

  @override
  Widget build(BuildContext context) {
    Microscope.disconnect();
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Mdi.microscope),
                hintText: 'Enter IP Address',
                border: OutlineInputBorder(),
              ),
              initialValue: _lastIp,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an IP Address';
                }
                _ip = value;
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Microscope.setUriAddress(_ip, 5000);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(''),
                          content: Container(
                              width: 75,
                              height: 75,
                              child: Microscope.connectToMicro()),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                if (Microscope.connected) {
                                  _saveIpAddress();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                  );
                                }
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      });
                }
              },
              child: Text('Connect'),
            ),
          ),
        ],
      ),
    );
  }
}
