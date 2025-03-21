import 'package:crud_test/data/models/todo_model.dart';
import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:crud_test/features/settings/presentation/widgets/todo_list_color.dart';
import 'package:crud_test/features/todo/presentation/pages/todo_form.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_check.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_detailed_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';

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
  void _toggleTodo() {
    if (widget.data.isDone == false) {
      FirestoreTodoCRUD().updateTodo(widget.data.docID, {
        'isDone': !widget.data.isDone,
      });
    } else {
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
        ? GestureDetector(
            onLongPress: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TodoDetailedView(
                        data: widget.data, colors: todoListColors))),
            child: Card(
                clipBehavior: Clip.hardEdge,
                child: SwipeActionCell(
                  key: ValueKey(widget.data.docID),
                  trailingActions: <SwipeAction>[
                    SwipeAction(
                      nestedAction: SwipeNestedAction(title: "Confirm"),
                      title: "Delete",
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      onTap: (CompletionHandler handler) async {
                        await handler(true);
                        FirestoreTodoCRUD().deleteTodo(widget.data.docID);
                      },
                      color: Colors.red,
                    ),
                    SwipeAction(
                        title: "Edit",
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onTap: (CompletionHandler handler) async {
                          handler(false);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TodoDetailedView(
                                      data: widget.data,
                                      colors: todoListColors)));
                        },
                        color: widget.data.isDone
                            ? todoListColors[2]
                            : todoListColors[1]),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.data.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                )))
        : Container();
  }
}
