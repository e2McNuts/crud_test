import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:crud_test/data/services/firestore_todolist_crud.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class TodoInputForm extends StatefulWidget {
  const TodoInputForm({super.key});

  @override
  State<TodoInputForm> createState() => _TodoInputFormState();
}

class _TodoInputFormState extends State<TodoInputForm> {
  // Stream subscription management
  StreamSubscription? _todolistSubscription;
  
  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addTagController = TextEditingController();

  // State variables
  final List<String> _tags = [];
  int? _deadline;
  bool _isUrgent = false;
  List<String> _todoLists = [];
  List<String> _todoListsNames = [];
  List<int> _todoListColor = [];
  String _selectedTodolist = '';
  String _selectedTodolistName = '';
  Color _selectedTodolistColor = Colors.teal;

  @override
  void initState() {
    super.initState();
    _getTodoLists();
  }

  void _getTodoLists() {
    _todolistSubscription?.cancel();
    _todolistSubscription = FirestoreTodolistCRUD().getTodolistsStream().listen((event) {
      if (!mounted) return;
      setState(() {
        _todoLists = event.docs.map((e) => e.id).toList().cast<String>();
        _todoListsNames = event.docs.map((e) => e['title'].toString()).toList();
        _todoListColor = event.docs.map((e) => e['color'] as int).toList();
      });
    });
  }

  @override
  void dispose() {
    _todolistSubscription?.cancel();
    _titleController.dispose();
    _descriptionController.dispose();
    _addTagController.dispose();
    super.dispose();
  }

  Future<void> _addTag() async {
    final newTag = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add Tag'),
        content: TextField(
          controller: _addTagController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _addTagController.clear();
            },
            child: const Text('Dismiss'),
          ),
          TextButton(
            onPressed: () {
              if (_addTagController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tag cannot be empty')),
                );
              } else {
                Navigator.pop(context, _addTagController.text);
                _addTagController.clear();
              }
            },
            child: const Text('Add Tag'),
          ),
        ],
      ),
    );

    if (newTag != null && newTag.isNotEmpty) {
      setState(() => _tags.add(newTag));
    }
  }

  Future<void> _removeTag(String tag) async {
    setState(() => _tags.remove(tag));
  }

  Future<void> _selectDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().add(const Duration(days: -14)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (pickedDate != null) {
      setState(() => _deadline = pickedDate.millisecondsSinceEpoch);
    }
  }

  void _toggleUrgency() {
    setState(() => _isUrgent = !_isUrgent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            final renderBox = context.findRenderObject() as RenderBox;
            final position = renderBox.localToGlobal(Offset.zero);

            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                position.dx,
                position.dy,
                position.dx + renderBox.size.width,
                position.dy + renderBox.size.height,
              ),
              items: [
                for (var todolist in _todoListsNames)
                  PopupMenuItem(
                    onTap: () => setState(() {
                      final index = _todoListsNames.indexOf(todolist);
                      _selectedTodolist = _todoLists[index];
                      _selectedTodolistName = _todoListsNames[index];
                      _selectedTodolistColor = Color(_todoListColor[index]);
                    }),
                    child: Text(
                      todolist,
                      style: TextStyle(
                        color: Color(_todoListColor[_todoListsNames.indexOf(todolist)]),
                    ),
                  ),
                  )
              ],
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _selectedTodolist.isEmpty
                  ? const Text('Select todolist')
                  : Text(_selectedTodolistName),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: _isUrgent ? Colors.red[400] : _selectedTodolistColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _titleController,
            builder: (context, value, child) => IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                if (value.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Title cannot be empty')),
                  );
                } else if (_selectedTodolist.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Select a todolist')),
                  );
                } else {
                  FirestoreTodoCRUD().addTodo({
                    'title': _titleController.text,
                    'todoList': _selectedTodolist,
                    'description': _descriptionController.text,
                    'deadline': _deadline,
                    'isDone': false,
                    'tags': _tags,
                    'isUrgent': _isUrgent,
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Todo added')),
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              minLines: 1,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              runSpacing: -4,
              spacing: 4,
              children: [
                ActionChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_month),
                      _deadline == null
                          ? const Text(' add deadline')
                          : Text(DateFormat('d.M.yyyy').format(
                              DateTime.fromMillisecondsSinceEpoch(_deadline!))),
                    ],
                  ),
                  onPressed: _selectDeadline,
                ),
                ActionChip(
                  backgroundColor: _isUrgent ? Colors.red[600] : null,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.flag,
                        color: _isUrgent ? Colors.white : Colors.black,
                      ),
                      Text(
                        'Urgent',
                        style: TextStyle(
                          color: _isUrgent ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  onPressed: _toggleUrgency,
                ),
                ..._tags.map((tag) => Chip(
                  label: Text(tag),
                  onDeleted: () => _removeTag(tag),
                )),
                ActionChip(
                  label: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.new_label),
                      Text('add tag'),
                    ],
                  ),
                  onPressed: _addTag,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}