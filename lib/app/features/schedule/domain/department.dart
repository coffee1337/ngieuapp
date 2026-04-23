class Department {
  const Department({required this.id, required this.name});
  final int id;
  final String name;
}

/// Захардкоженный словарь кафедр НГИЭУ.
/// В будущем можно подтягивать через API /api/v2/Departments/Get?isStudent=false
class Departments {
  Departments._();

  static const _all = <Department>[
    Department(id: 1, name: 'Организация и менеджмент'),
    Department(id: 2, name: 'Бухгалтерский учёт, анализ и аудит'),
    Department(id: 3, name: 'Экономика и автоматизация бизнес-процессов'),
    Department(id: 4, name: 'Гуманитарные науки'),
    Department(id: 8, name: 'Математика и вычислительная техника'),
    Department(id: 10, name: 'Электрификация и автоматизация'),
    Department(id: 11, name: 'Информационные системы и технологии'),
    Department(id: 13, name: 'Инфокоммуникационные технологии и системы связи'),
    Department(id: 17, name: 'Охрана труда и безопасность жизнедеятельности'),
    Department(id: 18, name: 'Физическая культура'),
    Department(id: 19, name: 'Технические системы и технологии'),
  ];

  static final Map<int, Department> _byId = {
    for (final d in _all) d.id: d,
  };

  static List<Department> all() => List.unmodifiable(_all);

  static String nameOf(int id) => _byId[id]?.name ?? 'Кафедра №$id';
}