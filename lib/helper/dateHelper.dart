DateTime getDateFromString(Map<String, dynamic> date) {
  int seconds = date['_seconds'] as int;
  DateTime utcDate =
      DateTime.fromMillisecondsSinceEpoch(seconds * 1000).toUtc();
  return utcDate;
}
