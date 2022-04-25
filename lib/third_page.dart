import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  @override
  void initState() {
    _getDevices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Blue Thermal Printer'),
      ),
      body: ListView(
        children: [
          DropdownButtonFormField<BluetoothDevice>(
            items: _devices
                .map((e) => DropdownMenuItem(
                      child: Text(e.name!),
                      value: e,
                    ))
                .toList(),
            onChanged: (device) {
              setState(() {
                _device = device;
                _connected = true;
              });
              _connect();
            },
            value: _device,
            isExpanded: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: "Pilih Printer",
              fillColor: Colors.blue[200],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _getDevices();
            },
            child: const Text('Refresh'),
          ),
          ElevatedButton(
            onPressed: _connected ? _tesPrint : null,
            child: const Text('TesPrint'),
          ),
        ],
      ),
    );
  }

  _getDevices() async {
    try {
      _devices = await bluetooth.getBondedDevices();
      setState(() {});
    } on PlatformException {}
  }

  void _connect() {
    // if (_device == null) {
    //   show('No device selected.');
    // } else {
    bluetooth.isConnected.then((isConnected) {
      bluetooth.connect(_device!).catchError((error) {
        // setState(() => _pressed = false);
      });
      // setState(() => _pressed = true);
    });
  }

  void _tesPrint() async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    bluetooth.isConnected.then((isConnected) {
      if (isConnected != null) {
        bluetooth.printNewLine();
        bluetooth.printCustom("HEADER", 3, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        //bluetooth.printImageBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
        bluetooth.printLeftRight("LEFT", "RIGHT", 0);
        bluetooth.printLeftRight("LEFT", "RIGHT", 1);
        bluetooth.printLeftRight("LEFT", "RIGHT", 1, format: "%-15s %15s %n");
        bluetooth.printNewLine();
        bluetooth.printLeftRight("LEFT", "RIGHT", 2);
        bluetooth.printLeftRight("LEFT", "RIGHT", 3);
        bluetooth.printLeftRight("LEFT", "RIGHT", 4);
        bluetooth.printNewLine();
        bluetooth.print3Column("Col1", "Col2", "Col3", 1);
        bluetooth.print3Column("Col1", "Col2", "Col3", 1,
            format: "%-10s %10s %10s %n");
        bluetooth.printNewLine();
        bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 1);
        bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 1,
            format: "%-8s %7s %7s %7s %n");
        bluetooth.printNewLine();
        String testString = " čĆžŽšŠ-H-ščđ";
        bluetooth.printCustom(testString, 1, 1, charset: "windows-1250");
        bluetooth.printLeftRight("Številka:", "18000001", 1,
            charset: "windows-1250");
        bluetooth.printCustom("Body left", 1, 0);
        bluetooth.printCustom("Body right", 0, 2);
        bluetooth.printNewLine();
        bluetooth.printCustom("Thank You", 2, 1);
        bluetooth.printNewLine();
        bluetooth.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
  }
}
