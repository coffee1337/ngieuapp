import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ngieuapp/app/features/news/domain/news_article.dart';
import 'package:ngieuapp/app/features/news/presentation/widgets/news_card.dart';
import 'package:ngieuapp/app/features/profile/domain/student_identity.dart';
import 'package:ngieuapp/app/features/profile/presentation/widgets/next_lesson_card.dart';
import 'package:ngieuapp/app/features/profile/presentation/widgets/profile_header.dart';
import 'package:ngieuapp/app/features/schedule/domain/actor.dart';
import 'package:ngieuapp/app/features/schedule/presentation/widgets/day_tabs.dart';
import 'package:ngieuapp/app/features/schedule/presentation/widgets/lesson_tile.dart';
import 'package:ngieuapp/app/theme/app_theme.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(() => initializeDateFormatting('ru_RU'));

  for (final dark in [false, true]) {
    testWidgets('Cards fit a narrow screen with large text, dark=$dark', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final lesson = makeLesson(
        subject: 'Информационные системы и технологии в управлении',
        classroom: '123, лаборатория информационных технологий',
        building: 'Учебный корпус № 2',
        teacherNames: const ['Александрова Александра Александровна'],
        isChange: true,
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: dark ? AppTheme.dark() : AppTheme.light(),
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    LessonTile(lesson: lesson),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ProfileHeader(
                        identity: const StudentIdentity(
                          actorId: 'group-1',
                          actorType: ActorType.studentGroup,
                          displayName: 'Информационные системы — ИТ-21',
                          departmentName: 'Институт информационных технологий',
                        ),
                        courseStats: const StatCard(label: 'Курс', value: '2'),
                        todayStats: const StatCard(
                          label: 'Сегодня пар',
                          value: '4',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: NextLessonCard(lesson: lesson),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('ЗАМЕНА'), findsOneWidget);
      expect(find.text(lesson.subject), findsNWidgets(2));
      final subject = tester.widget<Text>(find.text(lesson.subject).first);
      expect(subject.maxLines, isNull);
    });
  }

  testWidgets('News without images stays readable and opens on tap', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var opened = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: NewsCard(
              article: const NewsArticle(
                id: 1,
                title: 'День открытых дверей в университете',
                url: 'https://example.com/news/1',
                excerpt:
                    'Встреча с преподавателями и знакомство с институтами.',
                imageUrl: 'https://example.com/image.jpg',
              ),
              showImage: false,
              featured: true,
              onTap: () => opened = true,
            ),
          ),
        ),
      ),
    );
    expect(find.byType(Image), findsNothing);
    await tester.tap(find.text('Читать новость'));
    expect(opened, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Week days can be scrolled and selected with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    late TabController controller;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: DefaultTabController(
              length: 6,
              child: Builder(
                builder: (context) {
                  controller = DefaultTabController.of(context);
                  return DayTabs(
                    weekStart: DateTime(2026, 9, 7),
                    tabController: controller,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.ensureVisible(find.text('12'));
    await tester.tap(find.text('12'));
    await tester.pumpAndSettle();
    expect(controller.index, 5);
    expect(tester.takeException(), isNull);
  });
}
