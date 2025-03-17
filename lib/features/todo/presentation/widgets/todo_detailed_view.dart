import 'package:crud_test/data/models/todo_model.dart';
import 'package:crud_test/data/services/firestore_todolist_crud.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_edit_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoDetailedView extends StatefulWidget {
  final TodoModel data;

  const TodoDetailedView({super.key, required this.data});

  @override
  State<TodoDetailedView> createState() => _TodoDetailedViewState();
}

class _TodoDetailedViewState extends State<TodoDetailedView> {
  @override
  void initState() {
    super.initState();
    _getTodoListName();
    _getTodoListColor();
    _todoListName;
    _todoListColor;
  }

  String _todoListName = '';
  Color _todoListColor = Colors.teal;

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

  void _getTodoListColor() async {
    FirestoreTodolistCRUD().getTodolistsStream().listen((event) {
      for (var docs in event.docs) {
        if (docs.id == widget.data.todoList) {
          setState(() {
            _todoListColor = Color(docs['color']);
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
        title: Text('@$_todoListName'),
        centerTitle: true,
        backgroundColor:
            widget.data.isUrgent ? Colors.red[400] : _todoListColor,
        foregroundColor: Colors.white,
        actions: [
          // EDIT BUTTON
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoEditForm(data: widget.data),
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
            Text(
              widget.data.title,
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),

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
            Wrap(spacing: 4, runSpacing: -4, children: [
              // Deadline
              if (widget.data.deadline != null)
                Chip(
                  label: Text(DateFormat('d.M.yyyy')
                      .format(DateTime.fromMillisecondsSinceEpoch(
                          widget.data.deadline!))
                      .toString()),
                ),

              // Tags
              if (widget.data.tags != null)
                for (var tag in widget.data.tags!) Chip(label: Text(tag)),
            ]),
          ],
        ),
      ),
    );
  }
}
