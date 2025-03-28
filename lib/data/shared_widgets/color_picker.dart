import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final ValueChanged<double> onChanged;
  final double initialColor;

  const ColorPicker({super.key, required this.onChanged, required this.initialColor});

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late double _colorValue = 0.0;

  @override
  void initState() {
    super.initState();
    _colorValue = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return Container(
          height: 20,
          width: constraints.maxWidth,
          child: Stack(
            children: [
              Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      HSLColor.fromAHSL(1, 0, 1, .5).toColor(),
                      HSLColor.fromAHSL(1, 60, 1, .5).toColor(),
                      HSLColor.fromAHSL(1, 120, 1, .5).toColor(),
                      HSLColor.fromAHSL(1, 180, 1, .5).toColor(),
                      HSLColor.fromAHSL(1, 240, 1, .5).toColor(),
                      HSLColor.fromAHSL(1, 300, 1, .5).toColor(),
                      HSLColor.fromAHSL(1, 360, 1, .5).toColor(),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
              ),
              Slider(
                min: 0.0,
                max: 360.0,
                padding: EdgeInsets.symmetric(horizontal: 10),
                thumbColor: HSLColor.fromAHSL(1, _colorValue, 1, .5).toColor(),
                activeColor: Colors.transparent,
                inactiveColor: Colors.transparent,
                value: _colorValue,
                onChanged: (value) {
                  widget.onChanged(
                      num.parse(value.toStringAsFixed(2)).toDouble());
                  setState(() {
                    _colorValue = value;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
