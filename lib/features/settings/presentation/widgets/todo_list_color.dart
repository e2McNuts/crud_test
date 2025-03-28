import 'package:crud_test/data/services/firestore_todolist_crud.dart';

class TodoListColor {
  Future<double> getTodoListColor(String todoListID) async {
    final snapshot = await FirestoreTodolistCRUD().getTodolistsStream().first;
    final doc = snapshot.docs.firstWhere((doc) => doc.id == todoListID);
    return doc['color'];
  }
}
