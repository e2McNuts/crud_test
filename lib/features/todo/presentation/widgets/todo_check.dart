import 'package:flutter/material.dart';

class TodoCheck extends StatefulWidget {
  final bool isDone;
  final List<Color> colors;

  const TodoCheck({super.key, required this.colors, required this.isDone});

  @override
  State<TodoCheck> createState() => _TodoCheckState();
}

class _TodoCheckState extends State<TodoCheck> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: widget.isDone
          ?LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              HSLColor.fromColor(widget.colors[2]).withLightness(.2).toColor(),
              widget.colors[2]
            ],
            stops: [0, 0.1]
          )
          :LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              HSLColor.fromColor(widget.colors[1]).withLightness(.2).toColor(),
              widget.colors[1]
            ],
            stops: [0, 0.1]
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                widget.isDone
                    ? Icons.check_circle_outline_rounded
                    : Icons.circle_outlined,
                size: 36,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Color.fromARGB(115, 0, 0, 0),
                    blurRadius: 16,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
