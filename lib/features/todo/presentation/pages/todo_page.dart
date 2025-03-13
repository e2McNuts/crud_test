import 'package:crud_test/data/models/todo_model.dart';
import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_input_form.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_list_item.dart';
import 'package:flutter/material.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // FAB ADD TODOS
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TodoInputForm(),
            ),
          );
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[400],
        child: Icon(Icons.add),
      ),

      // BODY, LIST OF TODOS
      body: Expanded(
        child: StreamBuilder(
          stream: FirestoreTodoCRUD().getTodosStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              //Loading or no data in TodoList -> To be implemented loadingIndicator and noDataIndicator
              return Text('No Data...');
            } else {
              // Build the list of todos with TodoListItem
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  // parsing the server data to TodoModel
                  final TodoModel data = TodoModel(
                    docID: snapshot.data!.docs[index].id,
                    title: snapshot.data!.docs[index]['title'],
                    description: snapshot.data!.docs[index]['description'],
                    deadline: snapshot.data!.docs[index]['deadline'],
                    tags: snapshot.data!.docs[index]['tags'],
                    isDone: snapshot.data!.docs[index]['isDone'],
                    isUrgent: snapshot.data!.docs[index]['isUrgent'],
                  );
                  // returning data as TodoListItem
                  return TodoListItem(data: data);
                },
              );
            }
          }
        ),
      )
    );
  }
}
