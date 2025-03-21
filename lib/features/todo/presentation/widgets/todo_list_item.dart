import 'dart:math';

import 'package:crud_test/data/models/todo_model.dart';
import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:crud_test/features/settings/presentation/widgets/todo_list_color.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_check.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_chips_wrap.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_detailed_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoListItem extends StatefulWidget {
  final TodoModel data;
  final Set<String> selectedTodoListID;

  const TodoListItem(
      {super.key, required this.data, required this.selectedTodoListID});

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  // GET COLORS FOR LIST ITEM
  late List<Color> todoListColors;
  void _loadColors() async {
    final result = await TodoListColor().getTodoListColor(widget.data.todoList);
    setState(() {
      if (!widget.data.isUrgent) {
        todoListColors[0] =
            HSLColor.fromColor(result).withLightness(.7).toColor();
        todoListColors[1] =
            HSLColor.fromColor(result).withLightness(.8).toColor();
        todoListColors[2] =
            HSLColor.fromColor(result).withLightness(.5).toColor();
      } else {
        todoListColors[0] =
            HSLColor.fromColor(Colors.red).withLightness(.7).toColor();
        todoListColors[1] =
            HSLColor.fromColor(Colors.red).withLightness(.8).toColor();
        todoListColors[2] =
            HSLColor.fromColor(Colors.red).withLightness(.5).toColor();
      }
    });
  }

  // Todo Checking, Unchecking
  void _checkTodo() {
    if (widget.data.isDone == false) {
      FirestoreTodoCRUD().updateTodo(widget.data.docID, {
        'isDone': !widget.data.isDone,
      });
    }
  }

  void _uncheckTodo() {
    if (widget.data.isDone == true) {
      FirestoreTodoCRUD().updateTodo(widget.data.docID, {
        'isDone': !widget.data.isDone,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadColors();
    todoListColors = [Colors.grey, Colors.grey, Colors.grey];
  }

  @override
  Widget build(BuildContext context) {
    // SHOW DETAIL VIEW ON DOUBLE TAP
    return widget.selectedTodoListID.contains(widget.data.todoList)
        ? Container(
          color: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IntrinsicHeight(child: Flexible(flex: 1, child: Row(
                
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [Text(widget.data.title),]),
                  SizedBox(width: 16, child: Container(color: Colors.yellow,),)
                ],
              ),),),
              SizedBox(height: 40, width: 40, child: Container(color: Colors.red,),)
            ],
          ),
        )
        : Container();
  }
}
