class Department {
  const Department({required this.id, required this.name});

  factory Department.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return Department(
      id: rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '') ?? 0,
      name: (json['name'] ?? '').toString(),
    );
  }

  final int id;
  final String name;
}

/// Резервные названия кафедр для офлайн-режима.
/// Основной список загружается через Departments/Get?isStudent=false.
class Departments {
  Departments._();

  static const _all = <Department>[
    Department(id: 2, name: 'Бухгалтерский учёт, анализ и аудит'),
    Department(id: 4, name: 'Гуманитарные науки'),
    Department(id: 10, name: 'Инфокоммуникационные технологии и системы связи'),
    Department(id: 9, name: 'Информационные системы и технологии'),
    Department(id: 11, name: 'Кафедра сервиса'),
    Department(
      id: 12,
      name:
          'Кафедра технического обслуживания, организации перевозок и управления на транспорте',
    ),
    Department(id: 7, name: 'Математика и вычислительная техника'),
    Department(id: 1, name: 'Организация и менеджмент'),
    Department(id: 13, name: 'Охрана труда и безопасность жизнедеятельности'),
    Department(id: 6, name: 'Технические и биологические системы'),
    Department(id: 15, name: 'Технические системы и технологии'),
    Department(id: 5, name: 'Технический сервис'),
    Department(id: 14, name: 'Физическая культура'),
    Department(id: 3, name: 'Экономика и автоматизация бизнес-процессов'),
    Department(id: 8, name: 'Электрификация и автоматизация'),
  ];

  static final Map<int, Department> _byId = {for (final d in _all) d.id: d};

  static List<Department> all() => List.unmodifiable(_all);

  static String nameOf(int id) => _byId[id]?.name ?? 'Кафедра №$id';
}

/// Резервные названия институтов для офлайн-режима.
/// Основной список загружается через Departments/Get?isStudent=true.
class Institutes {
  Institutes._();

  static const _all = <Department>[
    Department(id: 1, name: 'Инженерный институт'),
    Department(id: 5, name: 'Институт транспорта, сервиса и туризма'),
    Department(id: 2, name: 'Информационные технологии и системы связи'),
    Department(id: 4, name: 'Педагогика и дополнительное образование'),
    Department(id: 3, name: 'Экономика и управление'),
  ];

  static final Map<int, Department> _byId = {for (final d in _all) d.id: d};

  static String nameOf(int id) => _byId[id]?.name ?? 'Институт №$id';
}
