import 'package:crud_test/data/services/firestore_todolist_crud.dart';
import 'package:flutter/material.dart';
import '../../../../data/models/todo_list_model.dart';

class TodoListSettings extends StatefulWidget {
  const TodoListSettings({super.key});

  @override
  State<TodoListSettings> createState() => _TodoListSettingsState();
}

class _TodoListSettingsState extends State<TodoListSettings> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Manage TodoLists', style: TextStyle(fontSize: 18),),
              IconButton(onPressed: () {}, icon: Icon(Icons.playlist_add),)
            ],
          ),
      
          StreamBuilder(
            stream: FirestoreTodolistCRUD().getTodolistsStream(), 
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('noTodoListsFound');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final TodoListModel data = TodoListModel(
                      todoListID: snapshot.data!.docs[index].id,
                      title: snapshot.data!.docs[index]['title'],
                    );
                    return Text(data.title);
                  }
                );
              }
            }
          )
        ],
    );    
  }
}
