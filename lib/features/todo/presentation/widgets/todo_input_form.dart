import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoInputForm extends StatefulWidget {
  const TodoInputForm({super.key});

  @override
  State<TodoInputForm> createState() => _TodoInputFormState();
}

class _TodoInputFormState extends State<TodoInputForm> {

  // TextInput Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addTagController = TextEditingController();


  // Handling of Tags
  final List<String> _tags = [];

  _addTag() async {
    final newTag = await showDialog<String>(
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
              child: Text('Dismiss')
            ),
            TextButton(
              onPressed: () {
                if (_addTagController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tag cannot be empty'))
                  );
                } else {
                  Navigator.pop(context, _addTagController.text);
                  _addTagController.clear();
                }
              },
              child: Text('Add Tag')
            )
          ],
        );
      },
    );

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


  // Handling of Deadline
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


  // Handling of Urgency
  bool _isUrgent = false;

  void _toggleUrgency() {
    setState(() {
      _isUrgent = !_isUrgent;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // APPBAR showing TodoList, save and cancel button
      appBar: AppBar(
        title: Text('TodoListSelection'),// Still to be implemented
        centerTitle: true,
        // color is standard or red for urgent -> changing with the TodoList
        backgroundColor: _isUrgent == false ?Colors.blue[400] :Colors.red[400],
        foregroundColor: Colors.white,

        // Cancel Button
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close),
        ),

        // Save Button
        actions: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _titleController,
            builder: (context, value, child) {
              return IconButton(
                onPressed: value.text.isEmpty
                  ? () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Title cannot be empty')))
                  : () {
                    FirestoreTodoCRUD().addTodo({
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
              );
            },
          ),
        ],
      ),

      // Input Form
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Title TextField
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

            // Description TextField
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

            // Deadline, Urgency and Tags
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: [

                // Deadline
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
                            .toString()
                        ),
                    ],
                  ),
                  onPressed: _selectDeadline,
                ),

                // Urgency
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

                // Tags
                for (var tag in _tags) Chip(label: Text(tag), onDeleted: () => _removeTag(tag)),

                // Add Tag
                ActionChip(
                  label: Row(
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
