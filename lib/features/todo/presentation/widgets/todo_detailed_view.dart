import 'package:crud_test/data/models/todo_model.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
        widget.data.isUrgent ? Colors.red[100] : Colors.teal[100],
      
      // APPBAR Showing title, inheriting color from data
      appBar: AppBar(
        title: Text('@${widget.data.todoList}'),
        centerTitle: true,
        backgroundColor:
          widget.data.isUrgent ? Colors.red[400] : Colors.teal[400],
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
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            Divider(
              color: Colors.white,
              height: 16,
            ),

            // Description
            Text(
              widget.data.description!,
              style: TextStyle(
                height: 1.2,
                fontSize: 16,
                color: Colors.white,
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
