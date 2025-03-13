
import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_detailed_view.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TodoListItem extends StatefulWidget {
  final String docID;
  final String title;
  final String? description;
  final int? deadline;
  final List<String>? tags;
  final bool isDone;
  final bool isUrgent;

  const TodoListItem(
      {super.key,
      required this.docID,
      required this.title,
      this.description,
      this.deadline,
      this.tags,
      required this.isDone,
      required this.isUrgent});

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TodoDetailedView(
              docID: widget.docID,
              title: widget.title,
              description: widget.description,
              deadline: widget.deadline,
              tags: widget.tags,
              isDone: widget.isDone,
              isUrgent: widget.isUrgent),
        ),
      ),
      child: Card(
        color: widget.isUrgent ? Colors.red[200] : Colors.teal[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          widget.isUrgent
                              ? Icon(
                                  Icons.flag,
                                  color: Colors.red,
                                )
                              : Container(),
                        ],
                      ),
                        widget.description == ''
                            ? Container()
                            : Text(
                                widget.description!,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              Wrap(children: [
                        if (widget.deadline != null)
                          Chip(
                            label: Text(DateFormat('d.M.yyyy')
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    widget.deadline!))
                                .toString()),
                          ),
                        widget.tags == null
                          ?Container()
                          :ListView.builder(itemCount: widget.tags!.length, itemBuilder: (BuildContext context, int index) => ListTile(
                            title: Text(widget.tags![index].toString()),
                          ))
                      ]),
                    ],
                  ),
                ),
                VerticalDivider(
                  color: Colors.white54,
                  width: 32,
                ),
                Checkbox(
                    value: widget.isDone,
                    side: BorderSide(
                      color: Colors.white,
                    ),
                    checkColor: Colors.white,
                    activeColor: Colors.white54,
                    onChanged: (bool? value) {
                      FirestoreTodoCRUD().updateTodo(widget.docID, {
                        'isDone': value,
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
