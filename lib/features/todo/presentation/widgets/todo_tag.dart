import 'package:flutter/material.dart';

class TodoTag extends StatefulWidget {
  final String label;
  final Color? color;
  final Color? backgroundColor;
  final Color? shadowColor;
  final IconData? leading;

  const TodoTag({
    super.key,
    required this.label,
    this.color,
    this.backgroundColor,
    this.shadowColor,
    this.leading,
  });

  @override
  State<TodoTag> createState() => _TodoTagState();
}

class _TodoTagState extends State<TodoTag> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: widget.shadowColor!,
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 0))
          ]),
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            widget.leading != null
                ? Padding( 
                  padding: EdgeInsets.only(right: 4),
                  child:Icon(
                    widget.leading,
                    color: widget.color,
                    size: 16,
                  ))
                : Container(),
            Text(
              widget.label,
              style: TextStyle(color: widget.color, fontSize: 16),
            ),
          ])),
    );
  }
}
