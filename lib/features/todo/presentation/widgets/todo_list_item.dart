import 'package:crud_test/data/models/todo_model.dart';
import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:crud_test/features/settings/presentation/widgets/todo_list_color.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_check.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_chips_wrap.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_detailed_view.dart';
import 'package:flutter/material.dart';

class TodoListItem extends StatefulWidget {
  final TodoModel data;

  const TodoListItem({super.key, required this.data});

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
    return GestureDetector(
        onDoubleTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoDetailedView(
                  data: widget.data,
                  colors: todoListColors,
                ),
              ),
            ),

        // LIST ITEM STYLE
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: 
            widget.data.isUrgent
            ?BorderSide(
              color: todoListColors[2],
              width: 5,
            )
            :BorderSide(color: Colors.transparent),
          ),
          color: todoListColors[0],
          clipBehavior: Clip.hardEdge,
          child: IntrinsicHeight(
            child: Row(
              children: [
                // CARD LEFT COLUMN
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title, Flag when urgent
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Text(
                              widget.data.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            widget.data.isUrgent
                                ? Icon(
                                    Icons.flag,
                                    color: todoListColors[2],
                                  )
                                : Container(),
                          ],
                        ),

                        // Description => display nothing when there is no description
                        widget.data.description == null
                            ? Container()
                            : Text(
                                widget.data.description!,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    height: 1.2,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),

                        // Deadline and Tags => display nothing when there is no deadline or tags
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TodoChipsWrap(
                            deadline: widget.data.deadline,
                            tags: widget.data.tags,
                            color: todoListColors[0],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Todo Check Panel
                GestureDetector(
                    onTap: _checkTodo,
                    onLongPress: _uncheckTodo,
                    child: TodoCheck(
                        colors: todoListColors, isDone: widget.data.isDone))
              ],
            ),
          ),
        ));
  }
}
