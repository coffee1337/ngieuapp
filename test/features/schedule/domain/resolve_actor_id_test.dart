import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/schedule/domain/actor.dart';
import 'package:ngieuapp/app/features/schedule/domain/resolve_actor_id.dart';

void main() {
  const currentTeacher = Actor(
    id: '343',
    departmentId: 9,
    name: 'Абувалов М. А.',
    type: ActorType.teacher,
  );

  test('keeps an id that still exists', () {
    final resolved = resolveActorId(
      savedId: currentTeacher.id,
      savedName: currentTeacher.name,
      savedType: currentTeacher.type,
      savedDepartmentId: currentTeacher.departmentId,
      currentActors: const [currentTeacher],
    );

    expect(resolved, currentTeacher);
  });

  test('repairs a legacy technical schedule title using its current id', () {
    final resolved = resolveActorId(
      savedId: currentTeacher.id,
      savedName: 'Расписание ${currentTeacher.id}',
      savedType: currentTeacher.type,
      savedDepartmentId: currentTeacher.departmentId,
      currentActors: const [currentTeacher],
    );

    expect(resolved, currentTeacher);
  });

  test('does not trust a reused id without saved actor details', () {
    final resolved = resolveActorId(
      savedId: currentTeacher.id,
      savedName: null,
      savedType: null,
      savedDepartmentId: null,
      currentActors: const [currentTeacher],
    );

    expect(resolved, isNull);
  });

  test('migrates a changed id by normalized name and actor type', () {
    final resolved = resolveActorId(
      savedId: 'old-teacher-id',
      savedName: 'Абувалов М.А.',
      savedType: ActorType.teacher,
      savedDepartmentId: 9,
      currentActors: const [currentTeacher],
    );

    expect(resolved, currentTeacher);
  });

  test('rejects a reused id and migrates to the matching teacher', () {
    const reusedId = Actor(
      id: '101',
      departmentId: 15,
      name: 'Кучин Н. Н.',
      type: ActorType.teacher,
    );
    const currentShlykova = Actor(
      id: '246',
      departmentId: 1,
      name: 'Шлыкова Л. В.',
      type: ActorType.teacher,
    );
    final resolved = resolveActorId(
      savedId: '101',
      savedName: 'Шлыкова Л.В.',
      savedType: ActorType.teacher,
      savedDepartmentId: 1,
      currentActors: const [reusedId, currentShlykova],
    );

    expect(resolved, currentShlykova);
  });

  test('uses department to disambiguate duplicate names', () {
    const otherDepartment = Actor(
      id: 'another-id',
      departmentId: 2,
      name: 'Абувалов М. А.',
      type: ActorType.teacher,
    );
    final resolved = resolveActorId(
      savedId: 'old-teacher-id',
      savedName: 'Абувалов М. А.',
      savedType: ActorType.teacher,
      savedDepartmentId: 9,
      currentActors: const [currentTeacher, otherDepartment],
    );

    expect(resolved, currentTeacher);
  });

  test('does not guess when name and department are ambiguous', () {
    const duplicate = Actor(
      id: 'duplicate-id',
      departmentId: 9,
      name: 'Абувалов М. А.',
      type: ActorType.teacher,
    );
    final resolved = resolveActorId(
      savedId: 'old-teacher-id',
      savedName: 'Абувалов М. А.',
      savedType: ActorType.teacher,
      savedDepartmentId: 9,
      currentActors: const [currentTeacher, duplicate],
    );

    expect(resolved, isNull);
  });
}
