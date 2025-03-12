import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_detailed_view.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TodoListItem extends StatefulWidget {
  final String docID;
  final String title;
  final String? description;
  final int? deadline;
  final bool isDone;
  final bool isUrgent;

  const TodoListItem(
      {super.key,
      required this.docID,
      required this.title,
      this.description,
      this.deadline,
      required this.isDone,
      required this.isUrgent});

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TodoDetailedView(
              docID: widget.docID,
              title: widget.title,
              description: widget.description,
              deadline: widget.deadline,
              isDone: widget.isDone,
              isUrgent: widget.isUrgent),
        ),
      ),
      child: Card(
        color: widget.isUrgent ? Colors.red[200] : Colors.teal[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      widget.isUrgent ? Icon(Icons.flag, color: Colors.red,) : Container(),
                    ],
                  ),
                  widget.description == ''
                    ? Container()
                    : Text(
                      widget.description!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white
                      ),
                    ),
                  if (widget.deadline != null)
                    Chip(label: Text(DateFormat('d.M.yyyy').format(DateTime.fromMillisecondsSinceEpoch(widget.deadline!)).toString())),
                ],
              ),
              Checkbox(value: widget.isDone, onChanged: (bool? value) {
                FirestoreTodoCRUD().updateTodo(widget.docID, {
                  'isDone': value,
                });
              }),
            ],
          ),
        ),
      ),
    );
  }
}
