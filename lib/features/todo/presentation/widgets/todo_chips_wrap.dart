import 'package:crud_test/features/settings/presentation/widgets/date_formatter.dart';
import 'package:crud_test/features/todo/presentation/widgets/todo_tag.dart';
import 'package:flutter/material.dart';

class TodoChipsWrap extends StatefulWidget {
  final int? deadline;
  final List? tags;
  final Color? color;

  const TodoChipsWrap({super.key, this.deadline, this.tags, this.color});

  @override
  State<TodoChipsWrap> createState() => _TodoChipsWrapState();
}

class _TodoChipsWrapState extends State<TodoChipsWrap> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if(widget.deadline != null || widget.tags != null)
      SizedBox(height: 16),
      Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Deadline
        if(widget.deadline != null)
          TodoTag(
            label: DateFormatter().deadlineFormat(widget.deadline!),
            color: Colors.white,
            backgroundColor: widget.color,
            shadowColor: Colors.black12,
            leading: Icons.event_available,
          ),

        // Tags
        if(widget.tags != null)
          for(var tag in widget.tags!)
            TodoTag(
              label: tag,
              color: Colors.white,
              backgroundColor: widget.color,
              shadowColor: Colors.black12,
              leading: Icons.sell,
            ),
      ],
    )]);
  }
}
