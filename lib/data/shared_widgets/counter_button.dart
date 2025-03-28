import 'package:flutter/material.dart';

class CounterButton extends StatefulWidget {
  final ValueChanged<int> onChanged;
  final int initialValue;

  const CounterButton(
      {super.key, required this.onChanged, required this.initialValue});

  @override
  State<CounterButton> createState() => _CounterButtonState();
}

class _CounterButtonState extends State<CounterButton> {
  late int counter;

  @override
  void initState() {
    super.initState();
    counter = widget.initialValue;
  }

  void _increment() {
    setState(() {
      counter++;
    });
    widget.onChanged(counter);
  }

  void _decrement() {
    setState(() {
      counter--;
    });
    widget.onChanged(counter);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[100]
          ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _decrement,
              child: Padding(padding: EdgeInsets.all(8), child: Icon(Icons.remove)),
            ),
            VerticalDivider(color: Colors.black, thickness: 1, width: 0,),
            Padding(padding: EdgeInsets.all(8), child: Text(counter.toString())),
            VerticalDivider(color: Colors.black, thickness: 1, width: 0,),
            GestureDetector(
              onTap: _increment,
              child: Padding(padding: EdgeInsets.all(8), child: Icon(Icons.add)),
            )
          ],
        ),
      ),
    );
  }
}
