import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTodolistCRUD {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getTodolistsStream() {
    return _firestore.collection('todoLists').snapshots();
  }

  Future<void> deleteTodolist(String docID) {
    return _firestore.collection('todoLists').doc(docID).delete();
  }

  Future<void> updateTodolist(String docID, Map<String, dynamic> data) {
    return _firestore.collection('todoLists').doc(docID).update(data);
  }

  Future<void> addTodolist(Map<String, dynamic> data) {
    return _firestore.collection('todoLists').add(data);
  }
}