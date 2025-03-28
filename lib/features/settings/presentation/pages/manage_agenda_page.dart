import 'package:crud_test/data/shared_widgets/counter_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageAgendaPage extends StatefulWidget {
  const ManageAgendaPage({super.key});

  @override
  State<ManageAgendaPage> createState() => _ManageAgendaPageState();
}

class _ManageAgendaPageState extends State<ManageAgendaPage> {
  late int daysBeforeDeadLine;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      daysBeforeDeadLine = prefs.getInt('daysBeforeDeadLine') ?? 1;
    });
  }

  Future<void> _updateDays(int newValue) async {
    await prefs.setInt('daysBeforeDeadLine', newValue);
    setState(() {
      daysBeforeDeadLine = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('Manage Agenda'),
      ),
      body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Todo Days till Deadline',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                spacing: 4,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      flex: 1,
                      child: Text(
                          'Determines when a Todo first shows up on your Agenda.',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          )),
                  CounterButton(
                    initialValue: daysBeforeDeadLine,
                    onChanged: (value) => _updateDays(value),
                  )
                ],
              )
            ],
          )),
    );
  }
}
