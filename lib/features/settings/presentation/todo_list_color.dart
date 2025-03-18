import 'package:crud_test/data/services/firestore_todolist_crud.dart';
import 'package:flutter/material.dart';

class TodoListColor {
  Future<Color> getTodoListColor(String todoListID) async {
    final snapshot = await FirestoreTodolistCRUD().getTodolistsStream().first;
    final doc = snapshot.docs.firstWhere((doc) => doc.id == todoListID);
    return Color(doc['color']);
  }
}
