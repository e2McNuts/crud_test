import 'package:crud_test/data/models/todo_model.dart';
import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:crud_test/data/services/firestore_todolist_crud.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_detailed_view.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TodoListItem extends StatefulWidget {
  final TodoModel data;

  const TodoListItem({super.key, required this.data});

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  Color _todoListColor = Colors.teal;
  Color _todListColorLight = Colors.teal;
  Color _todListColorDark = Colors.teal;

  void _getTodoListColor() async {
    FirestoreTodolistCRUD().getTodolistsStream().listen((event) {
      for (var docs in event.docs) {
        if (docs.id == widget.data.todoList) {
          setState(() {
            _todoListColor = Color(docs['color']);
            _todListColorLight = HSLColor.fromColor(Color(docs['color']))
                .withLightness(.85)
                .toColor();
            _todListColorDark = HSLColor.fromColor(Color(docs['color']))
                .withLightness(.4)
                .toColor();
          });
          break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getTodoListColor();
    _todoListColor;
    _todListColorLight;
    _todListColorDark;
  }

  @override
  Widget build(BuildContext context) {
    // SHOW DETAIL VIEW ON DOUBLE TAP
    return GestureDetector(
        onDoubleTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoDetailedView(data: widget.data),
              ),
            ),

        // LIST ITEM STYLE
        child: Card(
          // Card Color, red when urgent, teal when not -> soon to be replaced with color inherited from TodoListModel
          color: widget.data.isUrgent ? Colors.red[200] : _todoListColor,
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
                            Text(
                              widget.data.title,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            widget.data.isUrgent
                                ? Icon(
                                    Icons.flag,
                                    color: Colors.red,
                                  )
                                : Container(),
                          ],
                        ),

                        // Description
                        widget.data.description == null
                            ? Container()
                            : Text(
                                widget.data.description!,
                                style: TextStyle(
                                    height: 1.2,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),

                        // Deadline and Tags
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Wrap(spacing: 4, runSpacing: -4, children: [
                            //deadline
                            if (widget.data.deadline != null)
                              Chip(
                                label: Text(DateFormat('d.M.yyyy')
                                    .format(DateTime.fromMillisecondsSinceEpoch(
                                        widget.data.deadline!))
                                    .toString()),
                              ),

                            // tags
                            if (widget.data.tags != null)
                              for (var tag in widget.data.tags!)
                                Chip(label: Text('#$tag')),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),

                GestureDetector(
                    onTap: () {
                      if (widget.data.isDone == false) {
                        FirestoreTodoCRUD().updateTodo(widget.data.docID, {
                          'isDone': !widget.data.isDone,
                        });
                      }
                    },
                    onLongPress: () {
                      if (widget.data.isDone == true) {
                        FirestoreTodoCRUD().updateTodo(widget.data.docID, {
                          'isDone': !widget.data.isDone,
                        });
                      }
                    },
                    child: Container(
                        color: widget.data.isUrgent
                            ? (widget.data.isDone
                                ? Colors.red[600]
                                : Colors.red[300])
                            : (widget.data.isDone
                                ? _todListColorDark
                                : _todListColorLight),
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
                                      Color(0x00000000)
                                    ])),
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      widget.data.isDone
                                          ? Icons.check_circle_outline_rounded
                                          : Icons.circle_outlined,
                                      size: 36,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                            color: Color.fromARGB(115, 0, 0, 0),
                                            blurRadius: 16.0)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )))
              ],
            ),
          ),
        ));
  }
}
