import 'package:ngieuapp/app/features/schedule/domain/actor.dart';

Actor? resolveActorId({
  required String savedId,
  required String? savedName,
  required ActorType? savedType,
  required int? savedDepartmentId,
  required List<Actor> currentActors,
}) {
  if (savedName == null || savedType == null) return null;
  final normalizedName = _normalizeActorName(savedName);
  if (normalizedName.isEmpty) return null;

  for (final actor in currentActors) {
    if (actor.id == savedId &&
        actor.type == savedType &&
        _normalizeActorName(actor.name) == normalizedName) {
      return actor;
    }
  }

  final matches = currentActors
      .where(
        (actor) =>
            actor.type == savedType &&
            _normalizeActorName(actor.name) == normalizedName,
      )
      .toList(growable: false);
  if (matches.length == 1) return matches.single;

  final sameDepartment = matches
      .where((actor) => actor.departmentId == savedDepartmentId)
      .toList(growable: false);
  return sameDepartment.length == 1 ? sameDepartment.single : null;
}

String _normalizeActorName(String value) =>
    value.toLowerCase().replaceAll(RegExp(r'[^0-9a-zа-яё]'), '');
