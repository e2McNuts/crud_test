import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_input_form.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_list_item.dart';
import 'package:flutter/material.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Todos'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen[500],
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TodoInputForm(),
              ),
            );
          },
          backgroundColor: Colors.lightGreen[500],
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
        ),
        body: Expanded(
          child: StreamBuilder(
              stream: FirestoreTodoCRUD().getTodosStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text(
                    'No Data...',
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      return TodoListItem(docID: doc.id, title: doc['title'], description: doc['description'], deadline: doc['deadline'], isDone: doc['isDone'], isUrgent: doc['isUrgent']);
                    },
                  );
                }
              }),
        ));
  }
}
