import 'package:crud_test/data/services/firestore_todolist_crud.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class TodoListSelectionChips extends StatefulWidget {
  final ValueChanged<Set<String>> onChanged;

  const TodoListSelectionChips({super.key, required this.onChanged});

  @override
  State<TodoListSelectionChips> createState() => _TodoListSelectionChipsState();
}

class _TodoListSelectionChipsState extends State<TodoListSelectionChips> {
  List<String> _todoLists = [];
  List<String> _todoListID = [];
  final Set<String> _selectedTodoLists = {};
  final Set<String> selectedTodoListID = {};
  bool _allSelected = false;

  StreamSubscription? _subscription; // Track the stream subscription

  void _getTodoLists() {
    // Assign the subscription to _subscription
    _subscription =
        FirestoreTodolistCRUD().getTodolistsStream().listen((event) {
      if (!mounted) return; // Check if widget is still mounted
      setState(() {
        _todoLists = event.docs.map((e) => e['title'].toString()).toList();
        _todoListID = event.docs.map((e) => e.id.toString()).toList();
        // Update selected lists based on current data
        _selectedTodoLists
          ..clear()
          ..addAll(_todoLists);
        selectedTodoListID
          ..clear()
          ..addAll(_todoListID);
        widget.onChanged(selectedTodoListID);
        _allSelected = _todoLists.isNotEmpty &&
            _todoLists.length == _selectedTodoLists.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getTodoLists();
  }

  @override
  void dispose() {
    _subscription
        ?.cancel(); // Cancel the subscription when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('All'),
              selected: _allSelected,
              elevation: 1,
              onSelected: (bool selected) {
                setState(() {
                  _allSelected = selected;
                  if (selected) {
                    _selectedTodoLists.addAll(_todoLists);
                    selectedTodoListID.addAll(_todoListID);
                    widget.onChanged(selectedTodoListID);
                  } else {
                    _selectedTodoLists.clear();
                    selectedTodoListID.clear();
                    widget.onChanged(selectedTodoListID);
                  }
                });
              },
            ),
            ..._todoLists.map((list) {
              return FilterChip(
                label: Text(list),
                elevation: 1,
                selected: _selectedTodoLists.contains(list),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      _selectedTodoLists.add(list);
                      selectedTodoListID
                          .add(_todoListID[_todoLists.indexOf(list)]);
                    } else {
                      _selectedTodoLists.remove(list);
                      selectedTodoListID
                          .remove(_todoListID[_todoLists.indexOf(list)]);
                    }
                    _allSelected =
                        _selectedTodoLists.length == _todoLists.length;
                  });
                  widget.onChanged(selectedTodoListID);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
