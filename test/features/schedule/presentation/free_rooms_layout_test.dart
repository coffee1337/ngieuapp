import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:ngieuapp/app/features/schedule/domain/classroom_availability.dart';
import 'package:ngieuapp/app/features/schedule/presentation/free_rooms/background_loader_notifier.dart';
import 'package:ngieuapp/app/features/schedule/presentation/free_rooms/filter_panel.dart';
import 'package:ngieuapp/app/features/schedule/presentation/free_rooms/room_card.dart';
import 'package:ngieuapp/app/theme/app_theme.dart';

void main() {
  testWidgets('free-room controls fit a narrow phone without overflow', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    final now = DateTime(2026, 9, 9);
    final room = ClassroomAvailability(
      classroom: '206Б',
      building: '',
      freeFrom: DateTime(2026, 9, 9, 10),
      freeUntil: DateTime(2026, 9, 9, 12),
      freeDuration: const Duration(hours: 2),
      institute: 'Информационные технологии и системы связи',
      floor: 2,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 640),
              textScaler: TextScaler.linear(1.25),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FreeRoomsFilterPanel(
                    semantic: AppSemanticColors.light,
                    dateFmt: DateFormat('dd.MM.yyyy'),
                    date: now,
                    from: const TimeOfDay(hour: 10, minute: 0),
                    to: const TimeOfDay(hour: 12, minute: 0),
                    minDurationMinutes: 45,
                    instituteFilter: null,
                    loader: const BackgroundLoaderState(
                      isLoading: false,
                      loaded: 1,
                      total: 1,
                      lastRunTime: null,
                      shouldAutoLoad: true,
                    ),
                    onPickDate: () {},
                    onPickTimeFrom: () {},
                    onPickTimeTo: () {},
                    onDurationPicked: (_) {},
                    onInstitutePicked: (_) {},
                    onSearch: () {},
                    onLoadSchedule: () {},
                    shortInstitute: (value) => value,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: RoomCard(room: room),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
