import SwiftUI
import WidgetKit

private let appGroup = "group.ru.ngieu.mobile.ngieuapp"

struct ScheduleEntry: TimelineEntry {
    let date: Date
}

struct ScheduleProvider: TimelineProvider {
    func placeholder(in context: Context) -> ScheduleEntry { ScheduleEntry(date: Date()) }

    func getSnapshot(in context: Context, completion: @escaping (ScheduleEntry) -> Void) {
        completion(ScheduleEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ScheduleEntry>) -> Void) {
        let entry = ScheduleEntry(date: Date())
        completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(30 * 60))))
    }
}

private struct LessonRow: Identifiable {
    let id: Int
    let time: String
    let subject: String
    let room: String
}

private func value(_ key: String) -> String {
    UserDefaults(suiteName: appGroup)?.string(forKey: key) ?? ""
}

private func rows(prefix: String, limit: Int) -> [LessonRow] {
    (0..<limit).compactMap { index in
        let subject = value("\(prefix)_\(index)_subject")
        guard !subject.isEmpty else { return nil }
        return LessonRow(
            id: index,
            time: value("\(prefix)_\(index)_time"),
            subject: subject,
            room: value("\(prefix)_\(index)_room")
        )
    }
}

private let brandGradient = LinearGradient(
    colors: [Color(red: 0.0, green: 0.13, blue: 0.38), Color(red: 0.62, green: 0.0, blue: 0.24)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

private extension View {
    @ViewBuilder
    func scheduleWidgetBackground() -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            containerBackground(for: .widget) { brandGradient }
        } else {
            background(brandGradient)
        }
    }
}

struct NextLessonView: View {
    var entry: ScheduleEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(value("widget_header").isEmpty ? "СЛЕДУЮЩАЯ ПАРА" : value("widget_header"))
                .font(.caption2.weight(.bold))
                .tracking(0.8)
                .foregroundColor(.white.opacity(0.82))
            Spacer(minLength: 0)
            Text(value("widget_subject").isEmpty ? "Откройте приложение" : value("widget_subject"))
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(3)
            Text(value("widget_time"))
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(15)
        .scheduleWidgetBackground()
        .widgetURL(URL(string: "ngieuapp:///schedule"))
    }
}

private struct RowsView: View {
    let title: String
    let lessons: [LessonRow]
    let fontSize: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption2.weight(.bold))
                .tracking(0.8)
                .foregroundColor(.white.opacity(0.82))
                .padding(.bottom, 6)
            if lessons.isEmpty {
                Spacer()
                Text("Нет занятий")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            } else {
                ForEach(lessons) { lesson in
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(lesson.time)
                            .font(.system(size: fontSize, weight: .bold, design: .rounded))
                            .frame(width: 78, alignment: .leading)
                        Text(lesson.subject)
                            .font(.system(size: fontSize, weight: .semibold))
                            .lineLimit(1)
                        Spacer(minLength: 4)
                        if !lesson.room.isEmpty {
                            Text(lesson.room.replacingOccurrences(of: "Ауд. ", with: ""))
                                .font(.system(size: fontSize - 1, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxHeight: .infinity)
                }
            }
        }
        .padding(15)
        .scheduleWidgetBackground()
        .widgetURL(URL(string: "ngieuapp:///schedule"))
    }
}

struct NextLessonWidget: Widget {
    let kind = "NextLessonWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ScheduleProvider()) { entry in
            NextLessonView(entry: entry)
        }
        .configurationDisplayName("Следующая пара")
        .description("Компактный виджет ближайшей пары")
        .supportedFamilies([.systemSmall])
    }
}

struct UpcomingLessonsWidget: Widget {
    let kind = "UpcomingLessonsWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ScheduleProvider()) { _ in
            RowsView(title: "БЛИЖАЙШИЕ ПАРЫ", lessons: rows(prefix: "widget_upcoming", limit: 3), fontSize: 13)
        }
        .configurationDisplayName("Ближайшие пары")
        .description("Три ближайших занятия")
        .supportedFamilies([.systemMedium])
    }
}

struct TodayScheduleWidget: Widget {
    let kind = "TodayScheduleWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ScheduleProvider()) { _ in
            RowsView(title: "РАСПИСАНИЕ НА СЕГОДНЯ", lessons: rows(prefix: "widget_item", limit: 7), fontSize: 13)
        }
        .configurationDisplayName("Расписание на сегодня")
        .description("Все занятия дня без мелкого шрифта")
        .supportedFamilies([.systemLarge])
    }
}

@main
struct NgieuWidgetBundle: WidgetBundle {
    var body: some Widget {
        NextLessonWidget()
        UpcomingLessonsWidget()
        TodayScheduleWidget()
    }
}
