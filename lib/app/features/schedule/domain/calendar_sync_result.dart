class CalendarSyncResult {
  const CalendarSyncResult({
    required this.created,
    required this.updated,
    required this.removed,
  });

  final int created;
  final int updated;
  final int removed;

  int get total => created + updated;
}

class CalendarSyncException implements Exception {
  const CalendarSyncException(this.message);

  final String message;

  @override
  String toString() => message;
}
