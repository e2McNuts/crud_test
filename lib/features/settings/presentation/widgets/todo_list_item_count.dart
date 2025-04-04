import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoListItemCount extends StatefulWidget {
  final String todolistID;

  const TodoListItemCount({super.key, required this.todolistID});

  @override
  State<TodoListItemCount> createState() => _TodoListItemCountState();
}

class _TodoListItemCountState extends State<TodoListItemCount> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> countStream = FirebaseFirestore.instance
        .collection('todos')
        .where('todoList', isEqualTo: widget.todolistID)
        .snapshots();

    return StreamBuilder(
        stream: countStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('still counting...');
          }

          final int itemCount = snapshot.data!.docs.length;

          if (itemCount == 1) {
            return Text('There is ${itemCount.toString()} Todo left. Are you sure to delete them?');
          } else if (itemCount > 1) {
            return Text('There are ${itemCount.toString()} Todos left. Are you sure to delete them?');
          } else {
            return Text('is empty.');
          }
        });
  }
}
