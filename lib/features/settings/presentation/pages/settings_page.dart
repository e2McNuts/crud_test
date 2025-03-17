import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:crud_test/data/services/firestore_todolist_crud.dart';
import 'package:crud_test/features/settings/presentation/widgets/color_selector.dart';
import 'package:crud_test/features/settings/presentation/widgets/todo_list_item_count.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _todolistNameController = TextEditingController();

  void _deleteTodolist(String todolistID) {
    FirestoreTodolistCRUD().deleteTodolist(todolistID);
    FirestoreTodoCRUD().getTodosStream().listen((event) {
      for (var element in event.docs) {
        if (element['todoList'] == todolistID) {
          FirestoreTodoCRUD().deleteTodo(element.id);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Manage Todolists'),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text('Add new Todolist'),
                                  content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _todolistNameController,
                                          decoration: InputDecoration(
                                            hintText: 'Todolist name',
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        ColorSelector()
                                      ]),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancel')),
                                    ValueListenableBuilder(
                                        valueListenable:
                                            _todolistNameController,
                                        builder: (context, value, child) {
                                          return TextButton(
                                              onPressed: value.text.isEmpty
                                                  ? () => ScaffoldMessenger.of(
                                                          context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Todolist name cannot be empty!')))
                                                  : () {
                                                      FirestoreTodolistCRUD()
                                                          .addTodolist({
                                                        'title':
                                                            _todolistNameController
                                                                .text,
                                                        'color': selectedColor[0].value,
                                                      });
                                                      Navigator.pop(context);
                                                      _todolistNameController
                                                          .clear();
                                                    },
                                              child: Text('Add'));
                                        })
                                  ],
                                ));
                      },
                      icon: Icon(Icons.playlist_add))
                ]),
            Divider(),
            StreamBuilder(
                stream: FirestoreTodolistCRUD().getTodolistsStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(snapshot.data!.docs[index]['title']),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.edit,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: snapshot.data!.docs.length > 1
                                          ? () => showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Delete ${snapshot.data!.docs[index]['title']}?'),
                                                  content: Wrap(children: [
                                                    Text(
                                                        '${snapshot.data!.docs[index]['title']} '),
                                                    TodoListItemCount(
                                                      todolistID: snapshot
                                                          .data!.docs[index].id,
                                                    ),
                                                  ]),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          _deleteTodolist(
                                                              snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Delete'))
                                                  ],
                                                );
                                              })
                                          : null,
                                      icon: Icon(Icons.delete),
                                    )
                                  ],
                                )
                              ]);
                        });
                  } else {
                    return Text('nodata');
                  }
                })
          ],
        ),
      )),
    );
  }
}
