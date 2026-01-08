
import 'package:flutter/material.dart';
import 'Login.dart';
class tools extends StatefulWidget {
  const tools({super.key});

  @override

  State<tools> createState() => _tollsState();
}

class _tollsState extends State<tools> {
  bool _switchVal = false;
  bool _checkBoxVal = true;
  double _sliderVal1 = 0.5;
  double _sliderVal2 = 50.0;
  int _radioVal = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
          children: <Widget>[
      const Text("Switch"),
      Center(
        child: Switch(

          onChanged: (bool value) {
            print(value);
            setState(() => _switchVal = value);
          },
          value: _switchVal,
        )
      ),
      const Text("Disabled Switch"),
      const Center(
        child: Switch(
          onChanged: null,
          value: true,
        ),
      ),
      const Divider(),
      const Text("Checkbox"),
      Checkbox(
        onChanged: (bool? value) {
          if (value != null) {
            setState(() => _checkBoxVal = value);
          }
        },
        value: _checkBoxVal,

    ),
    const Text("Disabled Checkbox"),
    const Checkbox(tristate: true, onChanged: null, value: null),
    const Divider(
    thickness: 6,
    indent: 20,
    color: Colors.black12,
    endIndent: 20,
    ),

    Slider(
    onChanged: (double value) {
    setState(() => this._sliderVal1 = value);
    if (value == 1)
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("data")));
    }
    ,
    value: _sliderVal1,
    ),
    const Text("Slider"),

    Slider(
    value:_sliderVal2,
    max: 100.0,
    divisions: 5,
    label: '${_sliderVal2.round()}',
    onChanged: (double value) {
    setState(() => _sliderVal2 = value);
    },
    ),
    const Divider(),
    const Text("Linear"),
    const LinearProgressIndicator(),
    const Divider(),
    const Text("Circular"),
    const Center(child: CircularProgressIndicator()),
    const Divider(),
    const Text("Radio"),
    Row(
    children: [0, 1, 2, 3]
        .map(
    (int index) => Radio<int>(
    value: index,
    groupValue: this._radioVal,

    onChanged: (int? value) {
    if (value != null) {
    setState(() => this._radioVal = value);
    }
    },
    )
    )
        .toList(),
    ),
    const Divider(),
    ]),
    );
  }
}
