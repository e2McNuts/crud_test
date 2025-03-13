import 'package:crud_test/data/models/todo_model.dart';
import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_detailed_view.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TodoListItem extends StatefulWidget {
  final TodoModel data;

  const TodoListItem({super.key, required this.data});

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  @override
  Widget build(BuildContext context) {

    // SHOW DETAIL VIEW ON DOUBLE TAP
    return GestureDetector(
      onDoubleTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TodoDetailedView(data: widget.data),
        ),
      ),

      // LIST ITEM STYLE
      child: Card(

        // Card Color, red when urgent, teal when not -> soon to be replaced with color inherited from TodoListModel
        color: widget.data.isUrgent ? Colors.red[200] : Colors.teal[200],

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IntrinsicHeight(
            child: Row(
              children: [

                // CARD LEFT COLUMN
                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Title, Flag when urgent
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.data.title,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          widget.data.isUrgent
                          ? Icon(
                            Icons.flag,
                            color: Colors.red,
                          )
                          : Container(),
                        ],
                      ),

                      // Description
                      widget.data.description == null
                      ? Container()
                      : Text(
                        widget.data.description!,
                        style:
                          TextStyle(fontSize: 16, color: Colors.white),
                      ),

                      // Deadline and Tags
                      Wrap(spacing: 4, runSpacing: -4, children: [

                        //deadline
                        if (widget.data.deadline != null)
                          Chip(
                            label: Text(DateFormat('d.M.yyyy')
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    widget.data.deadline!))
                                .toString()),
                          ),

                        // tags
                        if (widget.data.tags != null)
                          for (var tag in widget.data.tags!) Chip(label: Text(tag)),
                      ]),
                    ],
                  ),
                ),

                VerticalDivider(
                  color: Colors.white54,
                  width: 32,
                ),

                // CARD RIGHT COLUMN
                Checkbox(
                  value: widget.data.isDone,
                  side: BorderSide(
                    color: Colors.white,
                  ),
                  checkColor: Colors.white,
                  activeColor: Colors.white54,
                  onChanged: (bool? value) {
                    FirestoreTodoCRUD().updateTodo(widget.data.docID, {
                      'isDone': value,
                    });
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
