import 'package:crud_test/data/services/epoch_converter.dart';
import 'package:crud_test/features/agenda/presentation/widgets/agenda_todos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late SharedPreferences prefs;
  int _daysBeforeDeadline = 1;

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _daysBeforeDeadline = prefs.getInt('daysBeforeDeadLine') ?? 1;
    });
  }

  final PageController _pageController = PageController(
      initialPage: EpochConverter.daysSinceEpoch(DateTime.now()));
  late int _currentPage = EpochConverter.daysSinceEpoch(DateTime.now());

  void _nextPage() {
    _pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _previousPage() {
    _pageController.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  Future<void> _setPage() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now().add(Duration(days: 365 * 10)));
    await _pageController.animateToPage(
        EpochConverter.daysSinceEpoch(pickedDate!) + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: _previousPage, icon: Icon(Icons.chevron_left)),
            GestureDetector(
              onTap: _setPage,
              child: Text(DateFormat('d.M.yyyy').format(EpochConverter.dateFromDaysSinceEpoch(_currentPage))),
            ),
            IconButton(onPressed: _nextPage, icon: Icon(Icons.chevron_right))
          ],
        ),
      ),
      body: PageView.builder(
          controller: _pageController,
          itemBuilder: (contex, index) {
            return ListView(
              key: PageStorageKey(_currentPage),
              children: [
                ExpansionTile(
                  key: PageStorageKey('todos${_currentPage.toString()}'),
                  title: Text('Todos'),
                  children: [
                    AgendaTodos(
                        date:
                            EpochConverter.dateFromDaysSinceEpoch(_currentPage),
                        daysTillDeadline: _daysBeforeDeadline,)
                  ],
                ),
                ExpansionTile(
                    key: PageStorageKey('habits${_currentPage.toString()}'),
                    title: Text('Habits')),
                ExpansionTile(
                    key: PageStorageKey('calendar${_currentPage.toString()}'),
                    title: Text('Calendar'))
              ],
            );
          }),
    );
  }
}
