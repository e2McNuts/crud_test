class TodoModel {
  final String docID;
  final String todoList;
  final String title;
  final String? description;
  final int? deadline;
  final List<dynamic>? tags;
  final bool isDone;
  final bool isUrgent;

  TodoModel({
    required this.docID,
    required this.todoList,
    required this.title,
    this.description,
    this.deadline,
    this.tags,
    required this.isDone,
    required this.isUrgent,
  });
}