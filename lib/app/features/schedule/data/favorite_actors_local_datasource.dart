import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:ngieuapp/app/core/cache/hive_boxes.dart';
import 'package:ngieuapp/app/features/schedule/domain/favorite_actor.dart';

class FavoriteActorsLocalDataSource {
  static const _favoritesKey = 'favorite_actors';
  static const _activeActorIdKey = 'active_actor_id';

  Future<List<FavoriteActor>> getFavorites() async {
    final box = await Hive.openBox<String>(HiveBoxes.favoriteActors);
    final raw = box.get(_favoritesKey);
    if (raw == null) return const [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(FavoriteActor.fromJson)
          .where((actor) => actor.id.isNotEmpty && actor.isSupported)
          .toList();
    } on Object {
      return const [];
    }
  }

  Future<String?> getActiveActorId() async {
    final box = await Hive.openBox<String>(HiveBoxes.favoriteActors);
    return box.get(_activeActorIdKey);
  }

  Future<void> addFavoriteActor(FavoriteActor actor) async {
    _ensureSupported(actor);
    final favorites = await getFavorites();
    final updated = [
      for (final favorite in favorites)
        if (favorite.id != actor.id) favorite,
      actor,
    ];
    await _saveFavorites(updated);
  }

  Future<void> removeFavoriteActor(String actorId) async {
    final favorites = await getFavorites();
    await _saveFavorites(
      favorites.where((favorite) => favorite.id != actorId).toList(),
    );

    if (await getActiveActorId() == actorId) {
      await setActiveActor(null);
    }
  }

  Future<void> setActiveActor(String? actorId) async {
    final box = await Hive.openBox<String>(HiveBoxes.favoriteActors);
    if (actorId == null || actorId.isEmpty) {
      await box.delete(_activeActorIdKey);
      return;
    }
    await box.put(_activeActorIdKey, actorId);
  }

  Future<void> _saveFavorites(List<FavoriteActor> favorites) async {
    final box = await Hive.openBox<String>(HiveBoxes.favoriteActors);
    await box.put(
      _favoritesKey,
      jsonEncode(favorites.map((actor) => actor.toJson()).toList()),
    );
  }

  void _ensureSupported(FavoriteActor actor) {
    if (!actor.isSupported) {
      throw ArgumentError.value(actor.type, 'type', 'Unsupported actor type');
    }
  }
}
