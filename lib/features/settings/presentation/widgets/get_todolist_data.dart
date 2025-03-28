import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:crud_test/data/services/firestore_todolist_crud.dart';
import 'package:crud_test/features/settings/presentation/widgets/todo_list_item_count.dart';
import 'package:crud_test/features/settings/presentation/widgets/todolist_form.dart';
import 'package:flutter/material.dart';

class GetTodolistData extends StatefulWidget {
  const GetTodolistData({super.key});

  @override
  State<GetTodolistData> createState() => _GetTodolistDataState();
}

class _GetTodolistDataState extends State<GetTodolistData> {
  void _deleteTodoList(String todolistID) {
    FirestoreTodolistCRUD().deleteTodolist(todolistID);
    FirestoreTodoCRUD().getTodosStream().listen((event) {
      for (var element in event.docs) {
        if (element['todoList'] == todolistID) {
          FirestoreTodoCRUD().deleteTodo(element.id);
        }
      }
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Stream getTodolistsStream = FirestoreTodolistCRUD().getTodolistsStream();

    return StreamBuilder(
        stream: getTodolistsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            List todolistItems = snapshot.data.docs.map((doc) {
              return {
                'listID': doc.id,
                'title': doc['title'],
                'color': doc['color'],
              };
            }).toList();
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: todolistItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.circle,
                            color: HSLColor.fromAHSL(1, todolistItems[index]['color'], 1, .5).toColor()),
                        SizedBox(width: 8),
                        Text(todolistItems[index]['title'])
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> TodolistForm(ListID: todolistItems[index]['listID'], ListName: todolistItems[index]['title'], ListColor: todolistItems[index]['color'],))),
                        icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: todolistItems.length <= 1
                                ? null
                                : () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                'Delete ${todolistItems[index]['title']}?'),
                                            content: TodoListItemCount(
                                                todolistID: todolistItems[index]
                                                    ['listID']),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Cancel')),
                                              TextButton(
                                                  onPressed: () =>
                                                      _deleteTodoList(
                                                          todolistItems[index]
                                                              ['listID']),
                                                  child: Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ))
                                            ],
                                          );
                                        });
                                  },
                            icon: Icon(Icons.delete))
                      ],
                    )
                  ],
                );
              },
            );
          }
        });
  }
}
