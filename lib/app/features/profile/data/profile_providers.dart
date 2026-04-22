import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/student_identity.dart';
import 'profile_local_datasource.dart';

part 'profile_providers.g.dart';

@Riverpod(keepAlive: true)
ProfileLocalDataSource profileLocalDataSource(ProfileLocalDataSourceRef ref) {
  return ProfileLocalDataSource();
}

@riverpod
Future<StudentIdentity?> studentIdentity(StudentIdentityRef ref) {
  return ref.watch(profileLocalDataSourceProvider).load();
}