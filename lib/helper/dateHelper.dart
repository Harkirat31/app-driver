DateTime getDateFromString(Map<String, dynamic> date) {
  DateTime d = DateTime.parse(date['_seconds']);
  return d;
}
