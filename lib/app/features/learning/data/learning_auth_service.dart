import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LearningAuthService {
  LearningAuthService();

  final _storage = const FlutterSecureStorage();

  Future<({String? login, String? password})> read() async => (
    login: await _storage.read(key: 'lms_login'),
    password: await _storage.read(key: 'lms_password'),
  );

  Future<void> save(String login, String password) async {
    await _storage.write(key: 'lms_login', value: login);
    await _storage.write(key: 'lms_password', value: password);
  }

  Future<void> clear() async => _storage.deleteAll();
}
