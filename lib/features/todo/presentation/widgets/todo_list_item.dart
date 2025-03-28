import 'package:crud_test/data/models/todo_model.dart';
import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:crud_test/features/settings/presentation/widgets/todo_list_color.dart';
import 'package:crud_test/features/todo/presentation/pages/todo_form.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_check.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_chips_wrap.dart';
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
        todoListColors[0] = HSLColor.fromAHSL(1, result, 1, .7).toColor();
        todoListColors[1] = HSLColor.fromAHSL(1, result, 1, .8).toColor();
        todoListColors[2] = HSLColor.fromAHSL(1, result, 1, .5).toColor();
      } else {
        todoListColors[0] = Colors.red.shade300;
        todoListColors[1] = Colors.red.shade800;
        todoListColors[2] = Colors.red.shade600;
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
                        color: HSLColor.fromColor(todoListColors[0])
                            .withLightness(.4)
                            .toColor(),
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
                                    builder: (context) => TodoForm(
                                        data: widget.data,
                                        colors: todoListColors)));
                          },
                          color: widget.data.isDone
                              ? todoListColors[2]
                              : todoListColors[1]),
                    ],
                    child: IntrinsicHeight(
                        child: Row(mainAxisSize: MainAxisSize.max, children: [
                      Expanded(
                          child: Container(
                              color: todoListColors[0],
                              child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.data.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        if (widget.data.description != '')
                                          Text(
                                            widget.data.description!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white),
                                          ),
                                        TodoChipsWrap(
                                          color: todoListColors[0],
                                          deadline: widget.data.deadline,
                                          tags: widget.data.tags,
                                        )
                                      ])))),
                      GestureDetector(
                          onTap: _toggleTodo,
                          child: TodoCheck(
                              colors: todoListColors,
                              isDone: widget.data.isDone))
                    ])))))
        : Container();
  }
}
