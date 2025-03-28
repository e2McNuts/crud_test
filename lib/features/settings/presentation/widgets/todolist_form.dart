import 'package:crud_test/data/services/firestore_todolist_crud.dart';
import 'package:crud_test/data/shared_widgets/color_picker.dart';
import 'package:flutter/material.dart';

class TodolistForm extends StatefulWidget {
  final String? ListID;
  final String? ListName;
  final double? ListColor;

  const TodolistForm({super.key, this.ListID, this.ListName, this.ListColor});

  @override
  State<TodolistForm> createState() => _TodolistFormState();
}

class _TodolistFormState extends State<TodolistForm> {
  late TextEditingController _titleTextController = TextEditingController();
  late double _selectedColor =
      widget.ListColor == null ? 0.0 : widget.ListColor!;

  @override
  void initState() {
    super.initState();
    _titleTextController = TextEditingController(text: widget.ListName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.ListID == null ? 'Add Todolist' : 'Edit Todolist'),
          centerTitle: true,
          backgroundColor:
              HSLColor.fromAHSL(1, _selectedColor, 1, .5).toColor(),
          foregroundColor: Colors.white,
          actions: [
            ListenableBuilder(
                listenable: _titleTextController,
                builder: (BuildContext context, child) {
                  return IconButton(
                      onPressed: _titleTextController.text.isEmpty
                          ? null
                          : () {
                              if (widget.ListID == null) {
                                FirestoreTodolistCRUD().addTodolist({
                                  'title': _titleTextController.text,
                                  'color': _selectedColor
                                });
                                Navigator.pop(context);
                              } else {
                                FirestoreTodolistCRUD().updateTodolist(
                                    widget.ListID!, {
                                  'title': _titleTextController.text,
                                  'color': _selectedColor
                                });
                                Navigator.pop(context);
                              }
                            },
                      icon: Icon(Icons.check));
                })
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _titleTextController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
              ),
              SizedBox(height: 16),
              ColorPicker(
                onChanged: (newColor) => setState(() {
                  _selectedColor = newColor;
                }),
                initialColor: _selectedColor
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                              height: 80,
                              color:
                                  HSLColor.fromAHSL(1, _selectedColor, 1, .65)
                                      .toColor()),
                          Text(
                            'Light shade',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      )),
                  Flexible(
                      flex: 1,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                              height: 80,
                              color: HSLColor.fromAHSL(1, _selectedColor, 1, .5)
                                  .toColor()),
                          Text('Primary color',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))
                        ],
                      )),
                  Flexible(
                    flex: 1,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                            height: 80,
                            color: HSLColor.fromAHSL(1, _selectedColor, 1, .25)
                                .toColor()),
                        Text(
                          'Dark shade',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
