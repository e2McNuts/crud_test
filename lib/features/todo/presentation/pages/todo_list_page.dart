import 'package:crud_test/data/models/todo_model.dart';
import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:crud_test/features/todo/presentation/pages/todo_form.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_list_item.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_list_selection_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  late Set<String> _selectedTodoListID;

  @override
  void initState() {
    super.initState();
    _selectedTodoListID = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // FAB ADD TODOS
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TodoForm(),
              ),
            );
          },
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue[400],
          child: Icon(Icons.add),
        ),

        // BODY, LIST OF TODOS
        body: Column(children: [
          TodoListSelectionChips(
            onChanged: (value) => setState(() {
              _selectedTodoListID = value;
            }),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: StreamBuilder(
                  stream: FirestoreTodoCRUD().getTodosStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      //Loading or no data in TodoList -> To be implemented loadingIndicator and noDataIndicator
                      return SpinKitFadingCube(
                        color: Colors.blue[300],
                      );
                    } else {
                      // Build the list of todos with TodoListItem
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          // parsing the server data to TodoModel
                          final TodoModel data = TodoModel(
                            docID: snapshot.data!.docs[index].id,
                            todoList: snapshot.data!.docs[index]['todoList'],
                            title: snapshot.data!.docs[index]['title'],
                            description: snapshot.data!.docs[index]
                                ['description'],
                            deadline: snapshot.data!.docs[index]['deadline'],
                            tags: snapshot.data!.docs[index]['tags'],
                            isDone: snapshot.data!.docs[index]['isDone'],
                            isUrgent: snapshot.data!.docs[index]['isUrgent'],
                          );
                          // returning data as TodoListItem
                          return TodoListItem(data: data, selectedTodoListID: _selectedTodoListID,);
                        },
                      );
                    }
                  }),
            ),
          ),
        ]));
  }
}
