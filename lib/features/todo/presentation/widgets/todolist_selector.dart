import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_test/data/services/firestore_todolist_crud.dart';
import 'package:crud_test/features/settings/presentation/pages/manage_todolists_page.dart';
import 'package:flutter/material.dart';

class TodolistSelector extends StatefulWidget {
  final String selected;
  final ValueChanged<List> onSelected;

  const TodolistSelector(
      {super.key, required this.selected, required this.onSelected});

  @override
  State<TodolistSelector> createState() => _TodolistSelectorState();
}

class _TodolistSelectorState extends State<TodolistSelector> {
  final ExpansionTileController controller = ExpansionTileController();
  final GlobalKey _gestureKey = GlobalKey(); // Add GlobalKey

  late List _todoLists = [];

  void _fetchTodoLists() async {
    FirestoreTodolistCRUD().getTodolistsStream().listen((QuerySnapshot event) {
      final List newList = event.docs.map((doc) {
        return [doc.id.toString(), doc['title'].toString(), doc['color']];
      }).toList();

      setState(() {
        _todoLists = newList;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTodoLists();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          final RenderBox renderBox =
              _gestureKey.currentContext!.findRenderObject() as RenderBox;
          final Offset centerBottom = renderBox.localToGlobal(
              Offset(renderBox.size.width / 2, renderBox.size.height));
          final Rect anchor =
              Rect.fromCenter(center: centerBottom, width: 1, height: 1);
          final RelativeRect position = RelativeRect.fromRect(
            anchor,
            Offset.zero & MediaQuery.of(context).size,
          );

          showMenu(
              context: context,
              position: position,
              items: [
                for (List list in _todoLists)
                  PopupMenuItem(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(list[1]),
                          Icon(
                            Icons.circle,
                            color: HSLColor.fromAHSL(1, list[2], 1, .5).toColor(),
                          )
                        ]),
                    onTap: () {
                      widget.onSelected(list);
                    },
                  ),
                const PopupMenuItem(height: 0, child: Divider()),
                PopupMenuItem(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManageTodolistsPage()));
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Manage Todolists'),
                          Icon(Icons.settings, color: Colors.grey[700])
                        ]))
              ]);
        },
        child: Container(
            key: _gestureKey, // Assign the GlobalKey here
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.selected.isEmpty
                      ? 'Select Todolist'
                      : _todoLists.isNotEmpty
                          ? _todoLists.firstWhere(
                              (todo) => todo[0] == widget.selected,
                              orElse: () => ['', 'Unknown', null])[1]
                          : 'Unknown',
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_drop_down)
              ],
            )));
  }
}