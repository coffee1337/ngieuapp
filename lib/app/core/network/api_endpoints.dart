class ApiEndpoints {
  ApiEndpoints._();

  // Schedule API
  static const scheduleBase = String.fromEnvironment(
    'SCHEDULE_BASE_URL',
    defaultValue: 'https://230352-2.vm.clodo.ru/api/v2/',
  );
  static const scheduleGet = 'Schedule/Get';
  static const departmentsGet = 'Departments/Get';
  static const studentsGet = 'Students/Get';
  static const teachersGet = 'Teachers/Get';

  // News (web site)
  static const newsBase = String.fromEnvironment(
    'NEWS_BASE_URL',
    defaultValue: 'https://ngieu.ru/',
  );
  static const newsListPath = 'ngieu-news/';

  // Learning LMS
  static const learningUrl = String.fromEnvironment(
    'LEARNING_URL',
    defaultValue: 'https://ngiei.mcdir.ru/',
  );
}
