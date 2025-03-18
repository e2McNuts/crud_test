import 'package:intl/intl.dart';

class DateFormatter {
  String deadlineFormat(int milliseconds) {
    return DateFormat('d.M.yyyy').format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
  }
}