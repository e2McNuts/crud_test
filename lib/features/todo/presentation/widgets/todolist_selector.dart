import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_test/data/services/firestore_todolist_crud.dart';
import 'package:crud_test/features/settings/presentation/pages/manage_todolists_page.dart';
import 'package:flutter/material.dart';

class TodolistSelector extends StatefulWidget {
  final String selected;
  final ValueChanged<List> onSelected;

  const TodolistSelector(
      {super.key, required this.selected, required this.onSelected});

  @override
  State<TodolistSelector> createState() => _TodolistSelectorState();
}

class _TodolistSelectorState extends State<TodolistSelector> {
  final ExpansionTileController controller = ExpansionTileController();

  late List _todoLists = [];

  void _fetchTodoLists() async {
    FirestoreTodolistCRUD().getTodolistsStream().listen((QuerySnapshot event) {
      final List newList = event.docs.map((doc) {
        return [doc.id.toString(), doc['title'].toString(), doc['color']];
      }).toList();

      setState(() {
        _todoLists = newList;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTodoLists();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showMenu(
              context: context,
              position: RelativeRect.fromLTRB(0, 0, 0, 0),
              items: [
                for (List list in _todoLists)
                  PopupMenuItem(
                    child: Text(list[1]),
                    onTap: () {
                      widget.onSelected(list);
                    },
                  ),
                PopupMenuItem(child: PopupMenuDivider()),
                PopupMenuItem(
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context)=> ManageTodolistsPage()));
                    },
                    child: Text('Manage Todolists'))
              ]);
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.selected.isEmpty
                ? 'Select Todolist'
                : _todoLists
                    .firstWhere((todo) => todo[0] == widget.selected)[1]),
            SizedBox(width: 8),
            Icon(Icons.arrow_drop_down)
          ],
        ));
  }
}
