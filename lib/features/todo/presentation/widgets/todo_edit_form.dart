import 'package:crud_test/data/models/todo_model.dart';
import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoEditForm extends StatefulWidget {
  final TodoModel data;

  const TodoEditForm({super.key, required this.data});

  @override
  State<TodoEditForm> createState() => _TodoEditFormState();
}

class _TodoEditFormState extends State<TodoEditForm> {
  
  // TextInput Controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final TextEditingController _addTagController = TextEditingController();


  // Handling of Tags
  late List<String> _tags;

  _addTag() async {
    final newTag = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _addTagController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixText: '#',
                hintText: 'Add Tag'
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _addTagController.clear();
              },
              child: Text('Dismiss', style: TextStyle(color: Colors.red),)
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
              child: Text('Add Tag', style: TextStyle(color: Colors.black),)
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


  // Handling Deadlines
  late int? _deadline;

  // Deadline Selector converting to DateTime to Timestamp int
  Future<void> _selectDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.data.deadline == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(widget.data.deadline!),
      firstDate: DateTime.now().add(const Duration(days: -14)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    setState(() {
      _deadline = pickedDate?.millisecondsSinceEpoch.toInt();
    });
  }

  // Handling Urgency
  late bool _isUrgent;

  void _toggleUrgency() {
    setState(() {
      _isUrgent = !_isUrgent;
    });
  }


  // Write existing data to controllers
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.data.title);
    _descriptionController = TextEditingController(text: widget.data.description);
    _deadline = widget.data.deadline;
    _isUrgent = widget.data.isUrgent;
    _tags = widget.data.tags?.cast<String>().toList() ?? [];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // APPBAR showing title and save button
      appBar: AppBar(
        title: Text('TodoListSelection'),
        centerTitle: true,
        // Background color should be inherited from previous data
        backgroundColor: _isUrgent ? Colors.red[400] : Colors.teal[400],
        foregroundColor: Colors.white,
        
        // Cancel Button
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close),
        ),

        // Save Button | UPDATING TO FIREBASE
        actions: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _titleController,
            builder: (context, value, child) {
              return IconButton(
                onPressed: value.text.isEmpty
                  ? () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Title cannot be empty')))
                  : () {
                    FirestoreTodoCRUD().updateTodo(
                      widget.data.docID,
                      {
                        'title': _titleController.text,
                        'description': _descriptionController.text,
                        'deadline': _deadline,
                        'tags': widget.data.tags,
                        'isUrgent': _isUrgent,                  
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                      }
                    );
                      Navigator.pop(context);
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

      // BODY Editing Input Form
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              height: 16,
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
              height: 16,
            ),

            // Action Chips
            Wrap(
              runSpacing: -4,
              spacing: 4,
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
                          .toString()),
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
            Divider(
              height: 32,
            ),

            // Delete Button
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Delete ${widget.data.title}?'),
                  content: Text('Do you really want to delete this todo? (${widget.data.title})'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Dismiss', style: TextStyle(color: Colors.black),),
                    ),
                    TextButton(
                      onPressed: () {
                        FirestoreTodoCRUD()
                          .deleteTodo(widget.data.docID);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('Delete', style: TextStyle(color: Colors.red),),
                    )
                  ],
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  Text('Delete Todo', style: TextStyle(color: Colors.red),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
