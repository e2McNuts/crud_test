import 'package:crud_test/data/models/todo_model.dart';
import 'package:crud_test/data/services/firestore_todolist_crud.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_chips_wrap.dart';
import 'package:crud_test/features/todo/presentation/pages/todo_form.dart';
import 'package:flutter/material.dart';

class TodoDetailedView extends StatefulWidget {
  final TodoModel data;
  final List<Color> colors;

  const TodoDetailedView({super.key, required this.data, required this.colors});

  @override
  State<TodoDetailedView> createState() => _TodoDetailedViewState();
}

class _TodoDetailedViewState extends State<TodoDetailedView> {
  @override
  void initState() {
    super.initState();
    _getTodoListName();
    _todoListName;
  }

  String _todoListName = '';

  void _getTodoListName() async {
    FirestoreTodolistCRUD().getTodolistsStream().listen((event) {
      for (var docs in event.docs) {
        if (docs.id == widget.data.todoList) {
          setState(() {
            _todoListName = docs['title'].toString();
          });
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // APPBAR Showing title, inheriting color from data
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.description),
            SizedBox(width: 8),
            Text(_todoListName),
          ],
        ),
        centerTitle: true,
        backgroundColor: widget.colors[0],
        foregroundColor: Colors.white,
        actions: [
          // EDIT BUTTON
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoForm(data: widget.data, colors: widget.colors,),
              ),
            ),
            icon: Icon(Icons.edit),
          ),
        ],
      ),

      // BODY Showing Todo data
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: Text(
                    widget.data.title,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  widget.data.isUrgent
                      ? Icon(Icons.flag, color: widget.colors[2])
                      : Container(),
                ]),

            Divider(
              color: Colors.black,
              height: 16,
            ),

            // Description
            Text(
              widget.data.description!,
              style: TextStyle(
                height: 1.2,
                fontSize: 16,
                color: Colors.black,
              ),
            ),

            SizedBox(
              height: 16,
            ),

            // Deadline and Tags
            TodoChipsWrap(
              deadline: widget.data.deadline,
              tags: widget.data.tags,
              color: widget.colors[0],
            )
          ],
        ),
      ),
    );
  }
}
