import 'package:crud_test/features/todo/presentation/widgets/todo_edit_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoDetailedView extends StatefulWidget {
  final String docID;
  final String title;
  final String? description;
  final int? deadline;
  final List<String>? tags;
  final bool isDone;
  final bool isUrgent;

  const TodoDetailedView(
      {super.key,
      required this.docID,
      required this.title,
      this.description,
      this.deadline,
      this.tags,
      required this.isDone,
      required this.isUrgent});

  @override
  State<TodoDetailedView> createState() => _TodoDetailedViewState();
}

class _TodoDetailedViewState extends State<TodoDetailedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isUrgent ? Colors.red[100] : Colors.teal[100],
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: widget.isUrgent ? Colors.red[400] : Colors.teal[400],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoEditForm(
                    docID: widget.docID,
                    title: widget.title,
                    description: widget.description,
                    deadline: widget.deadline,
                    isUrgent: widget.isUrgent),
              ),
            ),
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.description!),
            SizedBox(
              height: 16,
            ),
            Wrap(children: [
              Chip(
                label: Text(DateFormat('d.M.yyyy')
                    .format(
                        DateTime.fromMillisecondsSinceEpoch(widget.deadline!))
                    .toString()),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
