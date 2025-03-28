import 'package:crud_test/data/services/firestore_todo_crud.dart';
import 'package:flutter/material.dart';

class AgendaTodos extends StatefulWidget {
  final DateTime date;
  final int daysTillDeadline;

  const AgendaTodos(
      {super.key, required this.date, required this.daysTillDeadline});

  @override
  State<AgendaTodos> createState() => _AgendaTodosState();
}

class _AgendaTodosState extends State<AgendaTodos> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirestoreTodoCRUD().getTodosStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Text(snapshot.data!.docs[index]['title']);
                });
          } else {
            return CircularProgressIndicator();
          }
        }
    );
  }
}
