import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ngieuapp/app/features/schedule/data/favorite_actors_local_datasource.dart';
import 'package:ngieuapp/app/features/schedule/domain/actor.dart';
import 'package:ngieuapp/app/features/schedule/domain/favorite_actor.dart';

void main() {
  late Directory tempDir;
  late FavoriteActorsLocalDataSource sut;

  const group = FavoriteActor(
    id: 'group-1',
    name: 'Б-22 ИСТ',
    type: ActorType.studentGroup,
    departmentId: 11,
    departmentName: 'Информационные системы и технологии',
  );

  const teacher = FavoriteActor(
    id: 'teacher-1',
    name: 'Иванов И.И.',
    type: ActorType.teacher,
    departmentId: 8,
    departmentName: 'Математика и вычислительная техника',
  );

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('favorite_actors_test_');
    Hive.init(tempDir.path);
    sut = FavoriteActorsLocalDataSource();
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('stores favorite student groups and teachers locally', () async {
    await sut.addFavoriteActor(group);
    await sut.addFavoriteActor(teacher);

    expect(await sut.getFavorites(), [group, teacher]);
  });

  test('sets first favorite actor as active actor', () async {
    await sut.addFavoriteActor(group);

    expect(await sut.getActiveActorId(), group.id);
  });

  test('replaces favorite actor with the same id', () async {
    await sut.addFavoriteActor(group);
    await sut.addFavoriteActor(group.copyWith(name: 'Б-22 ИСТ обновлено'));

    expect(await sut.getFavorites(), [
      group.copyWith(name: 'Б-22 ИСТ обновлено'),
    ]);
  });

  test('migrates a favorite and active actor to a new id', () async {
    await sut.addFavoriteActor(teacher);
    await sut.setActiveActor(teacher.id);
    final updated = teacher.copyWith(id: 'teacher-current');

    await sut.replaceFavoriteActorId(teacher.id, updated);

    expect(await sut.getFavorites(), [updated]);
    expect(await sut.getActiveActorId(), updated.id);
    expect(await sut.getActiveActorDetails(), updated);
  });

  test('stores and clears active actor id', () async {
    await sut.setActiveActor(group.id);

    expect(await sut.getActiveActorId(), group.id);

    await sut.setActiveActor(null);

    expect(await sut.getActiveActorId(), isNull);
    expect(await sut.getActiveActorDetails(), isNull);
  });

  test('stores active actor details for future id migration', () async {
    await sut.setActiveActorDetails(teacher);

    expect(await sut.getActiveActorId(), teacher.id);
    expect(await sut.getActiveActorDetails(), teacher);
  });

  test(
    'removes favorite actor and clears active actor when it matches',
    () async {
      await sut.addFavoriteActor(group);
      await sut.addFavoriteActor(teacher);
      await sut.setActiveActor(group.id);

      await sut.removeFavoriteActor(group.id);

      expect(await sut.getFavorites(), [teacher]);
      expect(await sut.getActiveActorId(), isNull);
    },
  );

  test('rejects unsupported actor types', () async {
    const department = FavoriteActor(
      id: 'department-1',
      name: 'Кафедра',
      type: ActorType.department,
      departmentId: 8,
      departmentName: 'Математика и вычислительная техника',
    );

    expect(
      () => sut.addFavoriteActor(department),
      throwsA(isA<ArgumentError>()),
    );
  });
}
