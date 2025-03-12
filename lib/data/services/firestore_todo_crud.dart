import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTodoCRUD {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getTodosStream() {
    return _firestore.collection('todos').snapshots();
  }

  Future<void> deleteTodo(String docID) {
    return _firestore.collection('todos').doc(docID).delete();
  }

  Future<void> updateTodo(String docID, Map<String, dynamic> data) {
    return _firestore.collection('todos').doc(docID).update(data);
  }

  Future<void> addTodo(Map<String, dynamic> data) {
    return _firestore.collection('todos').add(data);
  }
}