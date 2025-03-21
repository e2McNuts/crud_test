import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:crud_test/features/todo/presentation/widgets/todolist_selector.dart';
import 'package:flutter/material.dart';
import 'package:crud_test/data/models/todo_model.dart';
import 'package:intl/intl.dart';

class TodoForm extends StatefulWidget {
  final TodoModel? data;
  final List<Color>? colors;

  const TodoForm({super.key, this.data, this.colors});

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late String _selectedTodoList;
  late Color _selectedColor;

  late int? _deadline;

  Future<void> _selectDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().add(const Duration(days: -14)),
        lastDate: DateTime.now().add(const Duration(days: 365 * 10)));
    if (pickedDate != null) {
      setState(() {
        _deadline = pickedDate.millisecondsSinceEpoch;
      });
    }
  }

  late bool _isUrgent;

  void _toggleUrgency() {
    setState(() {
      _isUrgent = !_isUrgent;
    });
  }

  late List<String> _tags;
  final TextEditingController _addTagControlller = TextEditingController();

  _addTag() async {
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1220100479.
    final newTag = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: _addTagControlller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefix: Icon(Icons.sell),
                    hintText: 'Add Tag',
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _addTagControlller.clear();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    )),
                TextButton(
                    onPressed: () {
                      if (_addTagControlller.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Tag cant be empty')));
                      } else {
                        Navigator.pop(context, _addTagControlller.text);
                        _addTagControlller.clear();
                      }
                    },
                    child: Text('Add Tag'))
              ]);
        });
    if (newTag != null && newTag.isNotEmpty) {
      setState(() {
        _tags.add(newTag);
      });
    }
  }

  Future<void> _removeTag(String tag) async {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.data?.title);
    _descriptionController =
        TextEditingController(text: widget.data?.description);
    _selectedTodoList = widget.data?.todoList ?? '';
    _deadline = widget.data?.deadline;
    _isUrgent = widget.data?.isUrgent ?? false;
    _tags = widget.data?.tags?.cast<String>().toList() ?? [];
    _selectedColor = widget.colors == null ? Colors.blue : widget.colors![0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          clipBehavior: Clip.none,
          foregroundColor: Colors.white,
          backgroundColor: _isUrgent ? Colors.red[400] : _selectedColor,
          title: TodolistSelector(
            selected: _selectedTodoList,
            onSelected: (newSelectedId) {
              setState(() {
                _selectedTodoList = newSelectedId[0]; // Update the selected ID
                _selectedColor = Color(newSelectedId[2]);
              });
            },
          ),
          centerTitle: true,
          actions: [
            ValueListenableBuilder<TextEditingValue>(
                valueListenable: _titleController,
                builder: (context, value, child) => IconButton(
                    onPressed: value.text.isEmpty || _selectedTodoList.isEmpty
                        ? null
                        : () {
                            if (widget.data == null) {
                              FirestoreTodoCRUD().addTodo({
                                'title': _titleController.text,
                                'todoList': _selectedTodoList,
                                'description': _descriptionController.text,
                                'deadline': _deadline,
                                'isDone': false,
                                'tags': _tags,
                                'isUrgent': _isUrgent,
                                'timestamp':
                                    DateTime.now().millisecondsSinceEpoch,
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Todo (${_titleController.text}) added!')));
                            } else {
                              FirestoreTodoCRUD()
                                  .updateTodo(widget.data!.docID, {
                                'title': _titleController.text,
                                'todoList': _selectedTodoList,
                                'description': _descriptionController.text,
                                'deadline': _deadline,
                                'tags': _tags,
                                'isUrgent': _isUrgent,
                                'timestamp':
                                    DateTime.now().millisecondsSinceEpoch,
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Todo (${_titleController.text}) updated!')));
                            }
                          },
                    icon: Icon(Icons.check)))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Wrap(spacing: 4, runSpacing: -4, children: [
              ActionChip(
                label: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.calendar_month),
                  SizedBox(width: 4),
                  _deadline == null
                      ? Text('add deadline')
                      : Text(DateFormat('d.M.yyyy').format(
                          DateTime.fromMillisecondsSinceEpoch(_deadline!)))
                ]),
                onPressed: _selectDeadline,
              ),
              ActionChip(
                  backgroundColor: _isUrgent ? Colors.red : null,
                  label: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      Icons.flag,
                      color: _isUrgent ? Colors.white : Colors.black,
                    ),
                    Text(
                      'Urgent',
                      style: TextStyle(
                          color: _isUrgent ? Colors.white : Colors.black),
                    ),
                  ]),
                  onPressed: _toggleUrgency),
              for (String tag in _tags)
                Chip(label: Text(tag), onDeleted: () => _removeTag(tag)),
              ActionChip(
                label: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.new_label),
                  SizedBox(width: 4),
                  Text('add tag')
                ]),
                onPressed: _addTag,
              )
            ]),
            widget.data == null
                ? Container()
                : Column(
                    children: [
                      Divider(height: 36),
                      ElevatedButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete ${widget.data!.title}?'),
                                  content: Text(
                                      'Do you really want to delete this todo? (${widget.data!.title})'),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.black),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          FirestoreTodoCRUD()
                                              .deleteTodo(widget.data!.docID);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ))
                                  ],
                                );
                              }),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              Text(
                                'Delete Todo',
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ))
                    ],
                  ),
          ]),
        ));
  }
}
