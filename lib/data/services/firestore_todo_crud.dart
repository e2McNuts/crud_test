import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTodoCRUD {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String todo = 'todos';

  Stream<QuerySnapshot> getTodosStream() {
    return _firestore.collection(todo).snapshots();
  }

  Future<void> deleteTodo(String docID) {
    return _firestore.collection(todo).doc(docID).delete();
  }

  Future<void> updateTodo(String docID, Map<String, dynamic> data) { 
    return _firestore.collection(todo).doc(docID).update(data);
  }

  Future<void> addTodo(Map<String, dynamic> data) {
    return _firestore.collection(todo).add(data);
  }
}