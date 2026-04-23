import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/student_identity.dart';
import 'profile_local_datasource.dart';

final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  return ProfileLocalDataSource();
});

final studentIdentityProvider =
    FutureProvider<StudentIdentity?>((ref) {
  return ref.watch(profileLocalDataSourceProvider).load();
});