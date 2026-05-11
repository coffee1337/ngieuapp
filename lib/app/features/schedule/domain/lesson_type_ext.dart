import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';

extension LessonTypeX on LessonType {
  String get label => switch (this) {
        LessonType.lecture => 'Лекция',
        LessonType.practice => 'Практика',
        LessonType.lab => 'Лаб.',
        LessonType.exam => 'Экзамен',
        LessonType.consultation => 'Консультация',
        LessonType.event => 'Событие',
        LessonType.unknown => 'Занятие',
      };

  String get shortLabel => switch (this) {
        LessonType.lecture => 'Лек',
        LessonType.practice => 'Пр',
        LessonType.lab => 'Лаб',
        LessonType.exam => 'Экз',
        LessonType.consultation => 'Конс',
        LessonType.event => 'Соб',
        LessonType.unknown => 'Зан',
      };
}
