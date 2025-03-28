class EpochConverter {
  
  static int daysSinceEpoch(DateTime date) {
    final utcDate = date.toUtc();
    final epoch = DateTime.utc(1970, 1, 1);
    return utcDate.difference(epoch).inDays;
  }

  static DateTime dateFromDaysSinceEpoch(int days) {
    return DateTime.utc(1970,1,1).add(Duration(days: days));
  }
}
