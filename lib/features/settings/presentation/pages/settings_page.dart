import 'package:crud_test/features/settings/presentation/pages/manage_agenda_page.dart';
import 'package:crud_test/features/settings/presentation/pages/manage_todolists_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('Settings')
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Manage Todolists'),
            trailing: Icon(Icons.arrow_forward_rounded),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ManageTodolistsPage())),
          ),
          ListTile(
            title: Text('Manage Agenda'),
            trailing: Icon(Icons.arrow_forward_rounded),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ManageAgendaPage())),
          )
        ],
      ),
    );
  }
}