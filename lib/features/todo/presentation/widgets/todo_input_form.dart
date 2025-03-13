import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoInputForm extends StatefulWidget {
  const TodoInputForm({super.key});

  @override
  State<TodoInputForm> createState() => _TodoInputFormState();
}

final firestoreTodoCRUD = FirestoreTodoCRUD();

class _TodoInputFormState extends State<TodoInputForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addTagController = TextEditingController();

  final List<String> _tags = [];

  int? _deadline;
  Future<void> _selectDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().add(const Duration(days: -14)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    setState(() {
      _deadline = pickedDate?.millisecondsSinceEpoch.toInt();
    });
  }

  bool _isUrgent = false;
  void _toggleUrgency() {
    setState(() {
      _isUrgent = !_isUrgent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('todolist'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[500],
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close),
        ),
        actions: [
          IconButton(
            onPressed: _titleController.text.isEmpty
                ? () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Title cannot be empty')))
                : () {
                    firestoreTodoCRUD.addTodo({
                      'title': _titleController.text,
                      'description': _descriptionController.text,
                      'deadline': _deadline,
                      'isDone': false,
                      'tags': _tags,
                      'isUrgent': _isUrgent,
                      'timestamp': DateTime.now().millisecondsSinceEpoch,
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Todo added')));
                  },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              controller: _descriptionController,
              minLines: 1,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: [
                ActionChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_month),
                      _deadline == null
                          ? Text(' add deadline')
                          : Text(DateFormat('d.M.yyyy')
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  _deadline!))
                              .toString()),
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
                  onPressed: () => _toggleUrgency(),
                ),
                for (var tag in _tags) Chip(label: Text(tag)),
                ActionChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.new_label),
                      Text('add tag'),
                    ],
                  ),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Add Tag'),
                          content: TextField(
                            controller: _addTagController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () { 
                                  Navigator.pop(context);
                                  _addTagController.clear();
                                },
                                child: Text('Dismiss')),
                            TextButton(
                                onPressed: () {
                                  _tags.add(_addTagController.text);
                                  Navigator.pop(context);
                                  _addTagController.clear();
                                },
                                child: Text('Add Tag'))
                          ],
                        );
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
