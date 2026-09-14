import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngieuapp/app/features/profile/data/profile_providers.dart';
import 'package:ngieuapp/app/features/profile/domain/student_identity.dart';
import 'package:ngieuapp/app/features/schedule/data/favorite_actors_providers.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';
import 'package:ngieuapp/app/features/schedule/domain/actor.dart';
import 'package:ngieuapp/app/features/schedule/domain/favorite_actor.dart';
import 'package:ngieuapp/app/features/schedule/domain/resolve_actor_id.dart';

final resolvedActiveActorProvider = FutureProvider<Actor?>((ref) async {
  final activeId = await ref.watch(activeFavoriteActorIdProvider.future);
  if (activeId == null || activeId.isEmpty) return null;

  final groupsFuture = ref.watch(studentGroupsProvider.future);
  final teachersFuture = ref.watch(teachersProvider.future);
  final groups = await groupsFuture;
  final teachers = await teachersFuture;
  final currentActors = [...groups, ...teachers];

  final localFavorites = ref.read(favoriteActorsLocalDataSourceProvider);
  final savedActiveActor = await localFavorites.getActiveActorDetails();
  final favorites = await localFavorites.getFavorites();
  FavoriteActor? savedFavorite;
  for (final favorite in favorites) {
    if (favorite.id == activeId) {
      savedFavorite = favorite;
      break;
    }
  }

  final profileSource = ref.read(profileLocalDataSourceProvider);
  final identity = await profileSource.load();
  final savedName =
      savedActiveActor?.name ??
      savedFavorite?.name ??
      (identity?.actorId == activeId ? identity?.displayName : null);
  final savedType =
      savedActiveActor?.type ??
      savedFavorite?.type ??
      (identity?.actorId == activeId ? identity?.actorType : null);
  final savedDepartmentId =
      savedActiveActor?.departmentId ??
      savedFavorite?.departmentId ??
      (identity?.actorId == activeId ? identity?.departmentId : null);
  final resolved = resolveActorId(
    savedId: activeId,
    savedName: savedName,
    savedType: savedType,
    savedDepartmentId: savedDepartmentId,
    currentActors: currentActors,
  );

  if (resolved == null) {
    await localFavorites.setActiveActor(null);
    return null;
  }
  if (savedFavorite != null) {
    await localFavorites.replaceFavoriteActorId(
      activeId,
      savedFavorite.copyWith(
        id: resolved.id,
        name: resolved.name,
        departmentId: resolved.departmentId,
      ),
    );
  } else {
    final details = savedActiveActor;
    if (details != null) {
      await localFavorites.setActiveActorDetails(
        details.copyWith(
          id: resolved.id,
          name: resolved.name,
          departmentId: resolved.departmentId,
        ),
      );
    } else {
      await localFavorites.setActiveActor(resolved.id);
    }
  }

  final savedIdentity = identity;
  if (savedIdentity == null) {
    await profileSource.save(
      StudentIdentity(
        actorId: resolved.id,
        displayName: resolved.name,
        actorType: resolved.type,
        departmentName:
            savedActiveActor?.departmentName ??
            savedFavorite?.departmentName ??
            '',
        groupName: resolved.type == ActorType.studentGroup
            ? resolved.name
            : null,
        fullName: resolved.type == ActorType.teacher ? resolved.name : null,
        departmentId: resolved.departmentId,
      ),
    );
    ref.invalidate(studentIdentityProvider);
  } else if (savedIdentity.actorId == activeId) {
    await profileSource.save(
      savedIdentity.copyWith(
        actorId: resolved.id,
        displayName: resolved.name,
        groupName: resolved.type == ActorType.studentGroup
            ? resolved.name
            : savedIdentity.groupName,
        departmentId: resolved.departmentId,
      ),
    );
    ref.invalidate(studentIdentityProvider);
  }
  ref.invalidate(favoriteActorsProvider);
  return resolved;
});
