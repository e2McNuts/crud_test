import 'package:crud_test/features/todo/presentation/widgets/todo_edit_form.dart';
import 'package:flutter/material.dart';

class TodoDetailedView extends StatefulWidget {
  final String docID;
  final String title;
  final String? description;
  final int? deadline;
  final bool isDone;
  final bool isUrgent;

  const TodoDetailedView({super.key, required this.docID, required this.title, this.description, this.deadline, required this.isDone, required this.isUrgent});

  @override
  State<TodoDetailedView> createState() => _TodoDetailedViewState();
}

class _TodoDetailedViewState extends State<TodoDetailedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[500],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TodoEditForm(docID: widget.docID, title: widget.title, description: widget.description, deadline: widget.deadline, isUrgent: widget.isUrgent),
        ),
      ), 
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        children: [
          Text(widget.title),
          Text(widget.description!),
          Text(widget.deadline.toString()),
          Text(widget.isUrgent.toString()),
          Text(widget.docID),
        ],
      ),
    );
  }
}