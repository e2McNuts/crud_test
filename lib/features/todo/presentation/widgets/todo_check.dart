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
      color: widget.isDone ? widget.colors[2] : widget.colors[1],
      child: Row(
        children: [
          SizedBox(
            width: 16,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color.fromARGB(115, 0, 0, 0),
                    Color.fromARGB(25, 0, 0, 0),
                    Color.fromARGB(0, 0, 0, 0)
                  ],
                  stops: [0, 0.3, 0.8]
                )
              ),
            ),
          ),
          SizedBox(
            width: 48,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 14),
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
