import 'package:flutter/material.dart';
import 'dart:async';
import 'bt-controller.dart';

void main() => runApp(ArduinoBT());

class ArduinoBT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder>{
      Page_1.routeName: (BuildContext context) => new Page_1(),
    };
    return MaterialApp(
      title: 'Arduino BT Demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: MainPage(title: 'Arduino BT Demo'),
      routes: routes,
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String sensorValue = "null";
  String val_1 = '-1';

  bool ledState = false;

  @override
  initState() {
    super.initState();
    BTController.init(onData);
    scanDevices();
  }

  void onData(dynamic str) {
    while (true) {
      setState(() {
        sensorValue = str;
      });
    }
  }

  void switchLed() {
    setState(() {
      ledState = !ledState;
    });
    BTController.transmit(ledState ? '0' : '1');
  }

  Future<void> scanDevices() async {
    BTController.enumerateDevices().then((devices) {
      onGetDevices(devices);
    });
  }

  void onGetDevices(List<dynamic> devices) {
    Iterable<SimpleDialogOption> options = devices.map((device) {
      return SimpleDialogOption(
        child: Text(device.keys.first),
        onPressed: () {
          selectDevice(device.values.first);
        },
      );
    });

    // set up the SimpleDialog
    SimpleDialog dialog = SimpleDialog(
      title: const Text('Choose a device'),
      children: options.toList(),
    );

    // show the dialog
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  selectDevice(String deviceAddress) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
    BTController.connect(deviceAddress);
  }

  @override
  Widget build(BuildContext context) {
    Color color = ledState ? Colors.deepPurpleAccent : Colors.white24;
    TextTheme theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                onPressed: () {
                  // Navigator.pushNamed(context, Page_1.routeName);
                  BTController.transmit("A");
                },
                child: Text("Heart rate")),
            RaisedButton(
                onPressed: () {
                  // Navigator.pushNamed(context, Page_1.routeName);
                  BTController.transmit("B");
                },
                child: Text("Temperature")),
            RaisedButton(
                onPressed: () {
                  // Navigator.pushNamed(context, Page_1.routeName);
                  BTController.transmit("C");
                },
                child: Text("Oximeter")),
            RaisedButton(
                onPressed: () {
                  // Navigator.pushNamed(context, Page_1.routeName);
                  BTController.transmit("D");
                },
                child: Text("Blood Pressure")),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(sensorValue,
                  style: TextStyle(fontSize: 35.0, color: Colors.white)),
            )
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: color,
        onPressed: switchLed,
        tooltip: 'Increment',
        child: Icon(Icons.power_settings_new),
      ),
    );
  }
}

class Page_1 extends StatefulWidget {
  // Page_1({Key key, this.title}) : super(key: key);
  static const String routeName = "/Page_1";
  @override
  data_page cresteState() {
    return new data_page();
  }

  @override
  State<StatefulWidget> createState() {}
}

class data_page extends State<Page_1> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("Other functionality"),
            ),
            body: Column(children: <Widget>[
              RaisedButton(
                  onPressed: () {
                    BTController.transmit("A");
                  },
                  child: Text("Heart rate"))
            ])));
  }
}
