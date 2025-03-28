import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_test/features/habits/presentation/pages/habit_page.dart';
import 'package:crud_test/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/todo/presentation/pages/todo_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;

  final screens = [TodoListPage(), HabitPage(), SettingsPage()];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() {
            this.index = index;
          }),
          destinations: [
            NavigationDestination(icon: Icon(Icons.list), label: 'Todos'),
            NavigationDestination(
                icon: Icon(Icons.track_changes), label: 'Habits'),
            NavigationDestination(icon: Icon(Icons.settings), label: 'Settings')
          ],
        ),
        body: screens[index],
      ),
    );
  }
}
