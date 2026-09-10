import SwiftUI
import WidgetKit

private let appGroup = "group.ru.ngieu.mobile.ngieuapp"
private let scheduleURL = URL(string: "ngieuapp:///schedule")

struct LessonRow: Identifiable {
    let id: Int
    let time: String
    let subject: String
    let room: String
    let start: Date?
    let end: Date?
}

struct ScheduleSnapshot {
    let header: String
    let fallbackSubject: String
    let fallbackTime: String
    let fallbackRoom: String
    let updatedDay: String
    let upcoming: [LessonRow]
    let today: [LessonRow]

    static let placeholder = ScheduleSnapshot(
        header: "СЛЕДУЮЩАЯ ПАРА",
        fallbackSubject: "Основы программирования",
        fallbackTime: "10:40–12:10",
        fallbackRoom: "Ауд. 205",
        updatedDay: "",
        upcoming: [
            LessonRow(
                id: 0,
                time: "10:40–12:10",
                subject: "Основы программирования",
                room: "Ауд. 205",
                start: nil,
                end: nil
            )
        ],
        today: []
    )

    func nextLesson(at date: Date) -> LessonRow? {
        upcoming.first { lesson in
            guard let end = lesson.end else { return true }
            return end > date
        }
    }

    func upcomingLessons(at date: Date) -> [LessonRow] {
        upcoming.filter { lesson in
            guard let end = lesson.end else { return true }
            return end > date
        }
    }

    func todayLessons(at date: Date) -> [LessonRow] {
        isCurrentDay(at: date) ? today : []
    }

    func isCurrentDay(at date: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date) == updatedDay
    }
}

struct ScheduleEntry: TimelineEntry {
    let date: Date
    let snapshot: ScheduleSnapshot
}

private func sharedDefaults() -> UserDefaults? {
    UserDefaults(suiteName: appGroup)
}

private func value(_ key: String) -> String {
    sharedDefaults()?.string(forKey: key) ?? ""
}

private func dateValue(_ key: String) -> Date? {
    guard let raw = sharedDefaults()?.object(forKey: key) else { return nil }
    let milliseconds: Double
    if let number = raw as? NSNumber {
        milliseconds = number.doubleValue
    } else if let string = raw as? String, let number = Double(string) {
        milliseconds = number
    } else {
        return nil
    }
    guard milliseconds > 0 else { return nil }
    return Date(timeIntervalSince1970: milliseconds / 1000)
}

private func rows(prefix: String, limit: Int, includeDates: Bool = false) -> [LessonRow] {
    (0..<limit).compactMap { index in
        let subject = value("\(prefix)_\(index)_subject")
        guard !subject.isEmpty else { return nil }
        return LessonRow(
            id: index,
            time: value("\(prefix)_\(index)_time"),
            subject: subject,
            room: value("\(prefix)_\(index)_room"),
            start: includeDates ? dateValue("\(prefix)_\(index)_start") : nil,
            end: includeDates ? dateValue("\(prefix)_\(index)_end") : nil
        )
    }
}

private func loadSnapshot() -> ScheduleSnapshot {
    ScheduleSnapshot(
        header: value("widget_header"),
        fallbackSubject: value("widget_subject"),
        fallbackTime: value("widget_time"),
        fallbackRoom: value("widget_room"),
        updatedDay: String(value("widget_updated_at").prefix(10)),
        upcoming: rows(prefix: "widget_upcoming", limit: 3, includeDates: true),
        today: rows(prefix: "widget_item", limit: 7)
    )
}

private func startTime(_ time: String) -> String {
    for separator in ["–", "—", "-"] {
        if let range = time.range(of: separator) {
            return String(time[..<range.lowerBound]).trimmingCharacters(in: .whitespaces)
        }
    }
    return time
}

private func roomNumber(_ room: String) -> String {
    room.replacingOccurrences(of: "Ауд. ", with: "")
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

private func lessonStatus(_ lesson: LessonRow?, at date: Date, fallback: String) -> String {
    guard let lesson else { return fallback.isEmpty ? "РАСПИСАНИЕ" : fallback }
    if let start = lesson.start, let end = lesson.end, start <= date, date < end {
        return "СЕЙЧАС"
    }
    return "СЛЕДУЮЩАЯ ПАРА"
}

private func scheduleStatus(_ snapshot: ScheduleSnapshot, at date: Date) -> String {
    let lesson = snapshot.nextLesson(at: date)
    if lesson == nil && !snapshot.upcoming.isEmpty {
        return "РАСПИСАНИЕ"
    }
    return lessonStatus(lesson, at: date, fallback: snapshot.header)
}

private func lessonDetails(
    _ snapshot: ScheduleSnapshot,
    at date: Date
) -> (lesson: LessonRow?, subject: String, time: String, room: String) {
    if let lesson = snapshot.nextLesson(at: date) {
        return (lesson, lesson.subject, lesson.time, lesson.room)
    }
    if !snapshot.upcoming.isEmpty {
        return (nil, "Пар больше нет", "", "")
    }
    return (
        nil,
        snapshot.fallbackSubject,
        snapshot.fallbackTime,
        snapshot.fallbackRoom
    )
}

struct ScheduleProvider: TimelineProvider {
    func placeholder(in context: Context) -> ScheduleEntry {
        ScheduleEntry(date: Date(), snapshot: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (ScheduleEntry) -> Void) {
        let snapshot = context.isPreview ? ScheduleSnapshot.placeholder : loadSnapshot()
        completion(ScheduleEntry(date: Date(), snapshot: snapshot))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ScheduleEntry>) -> Void) {
        let now = Date()
        let snapshot = loadSnapshot()
        let horizon = now.addingTimeInterval(24 * 60 * 60)
        let transitions = snapshot.upcoming
            .flatMap { [$0.start, $0.end] }
            .compactMap { $0 }
            .filter { now < $0 && $0 < horizon }
        let nextMidnight = Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: Calendar.current.startOfDay(for: now)
        )
        let dates = [now] + Array(Set(transitions + [nextMidnight].compactMap { $0 })).sorted()
        let entries = dates.map { ScheduleEntry(date: $0, snapshot: snapshot) }
        completion(
            Timeline(
                entries: entries,
                policy: .after(now.addingTimeInterval(30 * 60))
            )
        )
    }
}

private let brandGradient = LinearGradient(
    colors: [
        Color(red: 0.07, green: 0.09, blue: 0.15),
        Color(red: 0.36, green: 0.05, blue: 0.24),
        Color(red: 0.62, green: 0.0, blue: 0.24)
    ],
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

private struct StatusLabel: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .tracking(0.7)
            .foregroundColor(.white.opacity(0.82))
            .lineLimit(1)
    }
}

struct NextLessonView: View {
    let entry: ScheduleEntry

    var body: some View {
        let details = lessonDetails(entry.snapshot, at: entry.date)

        VStack(alignment: .leading, spacing: 5) {
            StatusLabel(
                text: scheduleStatus(entry.snapshot, at: entry.date)
            )
            Text(startTime(details.time).isEmpty ? "—" : startTime(details.time))
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundColor(.white)
                .lineLimit(1)
            Spacer(minLength: 0)
            Text(details.subject.isEmpty ? "Откройте приложение" : details.subject)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.82)
            if !details.room.isEmpty {
                Text(details.room)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.82))
                    .lineLimit(1)
            }
        }
        .padding(15)
        .scheduleWidgetBackground()
        .widgetURL(scheduleURL)
    }
}

struct WideNextLessonView: View {
    let entry: ScheduleEntry

    var body: some View {
        let details = lessonDetails(entry.snapshot, at: entry.date)

        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 5) {
                StatusLabel(
                    text: scheduleStatus(entry.snapshot, at: entry.date)
                )
                Text(startTime(details.time).isEmpty ? "—" : startTime(details.time))
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(width: 92, alignment: .leading)

            Rectangle()
                .fill(.white.opacity(0.2))
                .frame(width: 1)

            VStack(alignment: .leading, spacing: 5) {
                Text(details.subject.isEmpty ? "Откройте приложение" : details.subject)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                if !details.room.isEmpty {
                    Label(details.room, systemImage: "door.left.hand.closed")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.82))
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(15)
        .scheduleWidgetBackground()
        .widgetURL(scheduleURL)
    }
}

private struct RowsView: View {
    let title: String
    let lessons: [LessonRow]
    let large: Bool
    let emptyTitle: String
    let emptySubtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            StatusLabel(text: title)
                .padding(.bottom, large ? 8 : 6)
            if lessons.isEmpty {
                Spacer()
                Text(emptyTitle)
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.white)
                if !emptySubtitle.isEmpty {
                    Text(emptySubtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.72))
                        .lineLimit(2)
                }
                Spacer()
            } else {
                ForEach(lessons) { lesson in
                    HStack(spacing: 8) {
                        Text(lesson.time)
                            .font(.system(size: large ? 12 : 11, weight: .bold, design: .rounded))
                            .monospacedDigit()
                            .frame(width: large ? 84 : 78, alignment: .leading)
                        Text(lesson.subject)
                            .font(.system(size: large ? 13 : 12, weight: .semibold))
                            .lineLimit(1)
                        Spacer(minLength: 3)
                        if !lesson.room.isEmpty {
                            Text(roomNumber(lesson.room))
                                .font(.system(size: large ? 12 : 11, weight: .semibold))
                                .foregroundColor(.white.opacity(0.82))
                                .lineLimit(1)
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 9)
                            .fill(Color.white.opacity(0.1))
                    )
                    .padding(.top, 5)
                }
            }
        }
        .padding(large ? 15 : 13)
        .scheduleWidgetBackground()
        .widgetURL(scheduleURL)
    }
}

@available(iOSApplicationExtension 16.0, *)
private struct LockScreenScheduleView: View {
    @Environment(\.widgetFamily) private var family
    let entry: ScheduleEntry

    private var lesson: LessonRow? {
        lessonDetails(entry.snapshot, at: entry.date).lesson
    }

    private var subject: String {
        lessonDetails(entry.snapshot, at: entry.date).subject
    }

    private var time: String {
        startTime(lessonDetails(entry.snapshot, at: entry.date).time)
    }

    private var room: String {
        roomNumber(lessonDetails(entry.snapshot, at: entry.date).room)
    }

    private var inlineDetail: String {
        let detail = [time, subject, room].filter { !$0.isEmpty }.joined(separator: " · ")
        return detail.isEmpty ? "Расписание НГИЭУ" : detail
    }

    @ViewBuilder
    var body: some View {
        switch family {
        case .accessoryInline:
            ViewThatFits {
                Label(inlineDetail, systemImage: "graduationcap.fill")
                Label("\(time) · \(subject)", systemImage: "graduationcap.fill")
                Label(time.isEmpty ? "Расписание НГИЭУ" : time, systemImage: "graduationcap.fill")
            }
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: 0) {
                    Image(systemName: "graduationcap.fill")
                        .font(.caption2.weight(.bold))
                        .widgetAccentable()
                    Text(time.isEmpty ? "—" : time)
                        .font(.headline.weight(.bold))
                        .monospacedDigit()
                        .minimumScaleFactor(0.75)
                    if !room.isEmpty {
                        Text(room)
                            .font(.caption2.weight(.semibold))
                            .lineLimit(1)
                    }
                }
            }
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 5) {
                    Image(systemName: "graduationcap.fill")
                        .widgetAccentable()
                    Text(scheduleStatus(entry.snapshot, at: entry.date))
                    .font(.caption.weight(.bold))
                    Spacer(minLength: 2)
                    Text(time.isEmpty ? "—" : time)
                        .font(.headline.weight(.bold))
                        .monospacedDigit()
                }
                Text(subject.isEmpty ? "Откройте приложение" : subject)
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .privacySensitive()
                if !room.isEmpty {
                    Text("Аудитория \(room)")
                        .font(.caption)
                        .lineLimit(1)
                }
            }
        default:
            EmptyView()
        }
    }
}

struct NextLessonWidget: Widget {
    let kind = "NextLessonWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ScheduleProvider()) { entry in
            NextLessonView(entry: entry)
        }
        .configurationDisplayName("Следующая пара")
        .description("Время, предмет и аудитория крупным текстом")
        .supportedFamilies([.systemSmall])
    }
}

struct WideNextLessonWidget: Widget {
    let kind = "WideNextLessonWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ScheduleProvider()) { entry in
            WideNextLessonView(entry: entry)
        }
        .configurationDisplayName("Следующая пара — широко")
        .description("Читаемая карточка ближайшего занятия")
        .supportedFamilies([.systemMedium])
    }
}

struct UpcomingLessonsWidget: Widget {
    let kind = "UpcomingLessonsWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ScheduleProvider()) { entry in
            RowsView(
                title: "БЛИЖАЙШИЕ ПАРЫ",
                lessons: entry.snapshot.upcomingLessons(at: entry.date),
                large: false,
                emptyTitle: "Занятий впереди нет",
                emptySubtitle: ""
            )
        }
        .configurationDisplayName("Ближайшие пары")
        .description("Три занятия с отдельными временем и аудиторией")
        .supportedFamilies([.systemMedium])
    }
}

struct TodayScheduleWidget: Widget {
    let kind = "TodayScheduleWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ScheduleProvider()) { entry in
            RowsView(
                title: "РАСПИСАНИЕ НА СЕГОДНЯ",
                lessons: entry.snapshot.todayLessons(at: entry.date),
                large: true,
                emptyTitle: entry.snapshot.isCurrentDay(at: entry.date)
                    ? "Сегодня пар нет"
                    : "Нужно обновить расписание",
                emptySubtitle: entry.snapshot.isCurrentDay(at: entry.date)
                    ? ""
                    : "Откройте приложение, чтобы получить новый день"
            )
        }
        .configurationDisplayName("Расписание на сегодня")
        .description("Полное расписание дня без склеенных строк")
        .supportedFamilies([.systemLarge])
    }
}

@available(iOSApplicationExtension 16.0, *)
struct LockScreenScheduleWidget: Widget {
    let kind = "LockScreenScheduleWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ScheduleProvider()) { entry in
            LockScreenScheduleView(entry: entry)
                .widgetURL(scheduleURL)
        }
        .configurationDisplayName("Пара на экране блокировки")
        .description("Следующая пара в трёх форматах экрана блокировки")
        .supportedFamilies([.accessoryInline, .accessoryCircular, .accessoryRectangular])
    }
}

@main
struct NgieuWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        NextLessonWidget()
        WideNextLessonWidget()
        UpcomingLessonsWidget()
        TodayScheduleWidget()
        if #available(iOSApplicationExtension 16.0, *) {
            LockScreenScheduleWidget()
        }
    }
}
