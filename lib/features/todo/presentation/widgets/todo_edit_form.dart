import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoEditForm extends StatefulWidget {
  final String docID;
  final String title;
  final String? description;
  final int? deadline;
  final bool isUrgent;

  const TodoEditForm(
      {super.key,
      required this.docID,
      required this.title,
      this.description,
      this.deadline,
      required this.isUrgent});

  @override
  State<TodoEditForm> createState() => _TodoEditFormState();
}

class _TodoEditFormState extends State<TodoEditForm> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late int? _deadline;
  late bool _isUrgent;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _deadline = widget.deadline;
    _isUrgent = widget.isUrgent;
  }

  Future<void> _selectDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.deadline == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(widget.deadline!),
      firstDate: DateTime.now().add(const Duration(days: -14)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    setState(() {
      _deadline = pickedDate?.millisecondsSinceEpoch.toInt();
    });
  }

  void _toggleUrgency() {
    setState(() {
      _isUrgent = !_isUrgent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[500],
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close),
        ),
        actions: [
          IconButton(
              onPressed: () {
                FirestoreTodoCRUD().updateTodo(widget.docID, {
                  'title': _titleController.text,
                  'description': _descriptionController.text,
                  'deadline': _deadline,
                  'isUrgent': _isUrgent,
                  'timestamp': DateTime.now().millisecondsSinceEpoch,
                });
                Navigator.pop(context);
                Navigator.pop(context);
              },
              icon: Icon(Icons.save))
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
                ActionChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.new_label),
                      Text('add tag'),
                    ],
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            Divider(
              height: 32,
            ),
            ElevatedButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'Do you really want to delete this todo? (${widget.title})'),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Dismiss'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      FirestoreTodoCRUD()
                                          .deleteTodo(widget.docID);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Text('Delete'),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete),
                  Text('Delete Todo'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
