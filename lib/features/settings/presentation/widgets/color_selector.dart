import 'package:flutter/material.dart';

class ColorSelector extends StatefulWidget {
  const ColorSelector({super.key});

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

final List _colors = [
  [Colors.teal[200], Colors.teal[300], Colors.teal[600]],
  [Colors.blue[200], Colors.blue[300], Colors.blue[600]],
  [Colors.red[200], Colors.red[300], Colors.red[600]],
  [Colors.yellow[200], Colors.yellow[300], Colors.yellow[600]],
  [Colors.green[200], Colors.green[300], Colors.green[600]],
  [Colors.purple[200], Colors.purple[300], Colors.purple[600]],
  [Colors.orange[200], Colors.orange[300], Colors.orange[600]],
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
