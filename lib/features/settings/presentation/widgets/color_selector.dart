import 'package:flutter/material.dart';

class ColorSelector extends StatefulWidget {
  const ColorSelector({super.key});

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

final List _colors = [
  [Colors.pink[300], Colors.pink[600], Colors.pink[800]],
  [Colors.purple[300], Colors.purple[600], Colors.purple[800]],
  [Colors.indigo[300], Colors.indigo[600], Colors.indigo[800]],
  [Colors.lightBlue[300], Colors.lightBlue[600], Colors.lightBlue[800]],
  [Colors.teal[300], Colors.teal[600], Colors.teal[800]],
  [Colors.green[300], Colors.green[600], Colors.green[800]],
  [Colors.lime[300], Colors.lime[600], Colors.lime[800]],
  [Colors.amber[300], Colors.amber[600], Colors.amber[800]],
  [Colors.deepOrange[300], Colors.deepOrange[600], Colors.deepOrange[800]]
];

List selectedColor = _colors[0];

class _ColorSelectorState extends State<ColorSelector> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (List color in _colors)
          IconButton(
            onPressed: () {
              setState(() {
                selectedColor = color;
              });
            },
            color: color[1],
            icon: Icon(Icons.palette_outlined),
            isSelected: selectedColor == color,
            selectedIcon: Icon(Icons.palette),
          )
      ],
    );
  }
}
