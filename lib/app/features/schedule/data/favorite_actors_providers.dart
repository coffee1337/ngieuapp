import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngieuapp/app/features/schedule/data/favorite_actors_local_datasource.dart';
import 'package:ngieuapp/app/features/schedule/domain/favorite_actor.dart';

final favoriteActorsLocalDataSourceProvider =
    Provider<FavoriteActorsLocalDataSource>((ref) {
      return FavoriteActorsLocalDataSource();
    });

final favoriteActorsProvider = FutureProvider<List<FavoriteActor>>((ref) {
  return ref.watch(favoriteActorsLocalDataSourceProvider).getFavorites();
});

final activeFavoriteActorIdProvider = FutureProvider<String?>((ref) {
  return ref.watch(favoriteActorsLocalDataSourceProvider).getActiveActorId();
});
