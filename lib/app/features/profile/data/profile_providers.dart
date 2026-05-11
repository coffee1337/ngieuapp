import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngieuapp/app/features/profile/data/profile_local_datasource.dart';
import 'package:ngieuapp/app/features/profile/domain/student_identity.dart';

final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  return ProfileLocalDataSource();
});

final studentIdentityProvider = FutureProvider<StudentIdentity?>((ref) {
  return ref.watch(profileLocalDataSourceProvider).load();
});
