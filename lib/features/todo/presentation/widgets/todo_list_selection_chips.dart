import 'package:crud_test/data/services/firestore_todolist_crud.dart';
import 'package:flutter/material.dart';

class TodoListSelectionChips extends StatefulWidget {
  const TodoListSelectionChips({super.key});

  @override
  State<TodoListSelectionChips> createState() => _TodoListSelectionChipsState();
}

class _TodoListSelectionChipsState extends State<TodoListSelectionChips> {
  late List<String> _todoLists = [];
  late List<String> _todoListID = [];
  late final Set<String> _selectedTodoLists = {};
  late Set<String> selectedTodoListID = {};
  late bool _allSelected;

  void _getTodoLists() async {
    FirestoreTodolistCRUD().getTodolistsStream().listen((event) {
      setState(() {
        _todoLists = event.docs.map((e) => e['title'].toString()).toList();
        _todoListID = event.docs.map((e) => e.id.toString()).toList();
        _selectedTodoLists.addAll(_todoLists);
        selectedTodoListID.addAll(_todoListID);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _todoLists;
    _todoListID;
    _selectedTodoLists;
    selectedTodoListID;
    _getTodoLists();
    _allSelected = _todoLists.length == _selectedTodoLists.length;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(spacing: 6, children: [
            FilterChip(
                label: Text('All'),
                selected: _allSelected,
                onSelected: (bool selected) {
                  setState(() {
                    if (_allSelected) {
                      _selectedTodoLists.clear();
                      _allSelected = false;
                    } else {
                      _selectedTodoLists.clear();
                      _selectedTodoLists.addAll(_todoLists);
                      _allSelected = true;
                    }
                  });
                }),
            for (String list in _todoLists)
              FilterChip(
                label: Text(list),
                selected: _selectedTodoLists.contains(list),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      _selectedTodoLists.add(list);
                    } else {
                      _selectedTodoLists.remove(list);
                    }

                    if (_selectedTodoLists.length == _todoLists.length) {
                      _allSelected = true;
                    } else {
                      _allSelected = false;
                    }
                  });
                },
              ),
          ]),
        ));
  }
}
