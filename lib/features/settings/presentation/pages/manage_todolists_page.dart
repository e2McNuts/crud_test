import 'package:crud_test/features/settings/presentation/widgets/get_todolist_data.dart';
import 'package:crud_test/features/settings/presentation/widgets/todolist_form.dart';
import 'package:flutter/material.dart';

class ManageTodolistsPage extends StatefulWidget {
  const ManageTodolistsPage({super.key});

  @override
  State<ManageTodolistsPage> createState() => _ManageTodolistsPageState();
}

class _ManageTodolistsPageState extends State<ManageTodolistsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('Manage Todolists'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Todolists:',
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                          onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => TodolistForm())),
                          icon: Icon(Icons.format_list_bulleted_add))
                    ],
                  ),
                  Divider(
                    height: 0,
                  ),
                  GetTodolistData()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
