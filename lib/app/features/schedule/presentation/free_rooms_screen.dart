@riverpod
Future<List<ClassroomAvailability>> freeRooms(
  FreeRoomsRef ref,
  DateTime date,
  TimeOfDay from,
  TimeOfDay to,
) {
  final uc = ref.read(findFreeClassroomsProvider);
  return uc.call(date: date, from: from, to: to);
}