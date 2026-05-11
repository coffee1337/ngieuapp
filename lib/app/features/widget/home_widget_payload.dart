import 'package:ngieuapp/app/features/widget/home_widget_keys.dart';

enum HomeWidgetType {
  nextLesson,
  todaySchedule,
  tomorrowSchedule,
  groupSummary,
  changes,
}

enum HomeWidgetSize { small, medium, large }

class HomeWidgetItem {
  const HomeWidgetItem({
    required this.time,
    required this.subject,
    this.room = '',
  });

  final String time;
  final String subject;
  final String room;
}

class HomeWidgetPayload {
  const HomeWidgetPayload({
    required this.type,
    required this.size,
    required this.header,
    required this.subject,
    required this.time,
    required this.room,
    required this.updatedAt,
    this.group = '',
    this.items = const [],
    this.emptyTitle = '',
    this.emptyMessage = '',
  });

  factory HomeWidgetPayload.nextLesson({
    required String header,
    required String subject,
    required String time,
    required DateTime updatedAt,
    HomeWidgetSize size = HomeWidgetSize.medium,
    String room = '',
    String group = '',
  }) {
    return HomeWidgetPayload(
      type: HomeWidgetType.nextLesson,
      size: size,
      header: header,
      subject: subject,
      time: time,
      room: room,
      group: group,
      updatedAt: updatedAt,
    );
  }

  factory HomeWidgetPayload.empty({
    required String header,
    required String title,
    required DateTime updatedAt,
    HomeWidgetType type = HomeWidgetType.nextLesson,
    HomeWidgetSize size = HomeWidgetSize.medium,
    String message = '',
    String group = '',
  }) {
    return HomeWidgetPayload(
      type: type,
      size: size,
      header: header,
      subject: title,
      time: '',
      room: '',
      group: group,
      updatedAt: updatedAt,
      emptyTitle: title,
      emptyMessage: message,
    );
  }

  final HomeWidgetType type;
  final HomeWidgetSize size;
  final String header;
  final String subject;
  final String time;
  final String room;
  final String group;
  final DateTime updatedAt;
  final List<HomeWidgetItem> items;
  final String emptyTitle;
  final String emptyMessage;

  Map<String, Object?> toWidgetData() {
    final item0 = items.elementAtOrNull(0);
    final item1 = items.elementAtOrNull(1);
    final item2 = items.elementAtOrNull(2);

    return {
      HomeWidgetKeys.header: header,
      HomeWidgetKeys.subject: subject,
      HomeWidgetKeys.time: time,
      HomeWidgetKeys.room: room,
      HomeWidgetKeys.type: type.name,
      HomeWidgetKeys.size: size.name,
      HomeWidgetKeys.updatedAt: updatedAt.toIso8601String(),
      HomeWidgetKeys.group: group,
      HomeWidgetKeys.emptyTitle: emptyTitle,
      HomeWidgetKeys.emptyMessage: emptyMessage,
      HomeWidgetKeys.itemsCount: items.length,
      HomeWidgetKeys.item0Time: item0?.time ?? '',
      HomeWidgetKeys.item0Subject: item0?.subject ?? '',
      HomeWidgetKeys.item0Room: item0?.room ?? '',
      HomeWidgetKeys.item1Time: item1?.time ?? '',
      HomeWidgetKeys.item1Subject: item1?.subject ?? '',
      HomeWidgetKeys.item1Room: item1?.room ?? '',
      HomeWidgetKeys.item2Time: item2?.time ?? '',
      HomeWidgetKeys.item2Subject: item2?.subject ?? '',
      HomeWidgetKeys.item2Room: item2?.room ?? '',
    };
  }
}
