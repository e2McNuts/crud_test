import 'package:crud_test/data/services/firestore_todolist_crud.dart';
import 'package:crud_test/features/settings/presentation/widgets/color_selector.dart';
import 'package:crud_test/features/settings/presentation/widgets/get_todolist_data.dart';
import 'package:flutter/material.dart';

class ManageTodolistsPage extends StatefulWidget {
  const ManageTodolistsPage({super.key});

  @override
  State<ManageTodolistsPage> createState() => _ManageTodolistsPageState();
}

class _ManageTodolistsPageState extends State<ManageTodolistsPage> {

  late TextEditingController _todolistNameController;

  void _addTodolist() {
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.close)),
                  Text('New Todolist', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  ValueListenableBuilder(
                    valueListenable: _todolistNameController, 
                    builder: (context, value, child) {
                      return IconButton(
                        onPressed: value.text.isEmpty
                          ?()=> ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Todolist needs a name')))
                          :() {
                            FirestoreTodolistCRUD().addTodolist({
                              'title': _todolistNameController.text,
                              'color': selectedColor[0].value,
                            });
                            Navigator.pop(context);
                            _todolistNameController.clear();
                          }, 
                        icon: Icon(Icons.check)
                      );
                    }
                  )
                ]
              ),
              TextField(
                controller: _todolistNameController,
                decoration: InputDecoration(
                  hintText: 'Todolist',
                ),
              ),
              new ColorSelector(),
            ],
          ),
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    _todolistNameController = TextEditingController();
  }

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
                      Text('Your Todolists:', style: TextStyle(fontSize: 18),),
                      IconButton(onPressed: _addTodolist, icon: Icon(Icons.format_list_bulleted_add))
                    ],
                  ),
                  Divider(height: 0,),
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