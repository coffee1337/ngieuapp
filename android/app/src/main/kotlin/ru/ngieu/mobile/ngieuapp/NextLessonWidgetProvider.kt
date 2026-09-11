package ru.ngieu.mobile.ngieuapp

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

data class WidgetRowIds(
    val container: Int,
    val time: Int,
    val subject: Int,
    val room: Int,
)

abstract class ScheduleWidgetProvider(
    private val layoutId: Int,
) : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, layoutId)
            bind(context, views)
            views.setOnClickPendingIntent(
                R.id.widget_root,
                HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
            )
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    protected abstract fun bind(context: Context, views: RemoteViews)

    protected fun text(context: Context, key: String): String =
        HomeWidgetPlugin.getData(context).getString(key, "") ?: ""

    protected fun timestamp(context: Context, key: String): Long {
        return when (val value = HomeWidgetPlugin.getData(context).all[key]) {
            is Number -> value.toLong()
            is String -> value.toLongOrNull() ?: 0L
            else -> 0L
        }
    }

    protected fun isWidgetDataFromToday(context: Context): Boolean {
        val updatedAt = text(context, "widget_updated_at")
        if (updatedAt.length < 10) return false
        val today = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
        return updatedAt.startsWith(today)
    }

    protected fun bindRows(
        context: Context,
        views: RemoteViews,
        prefix: String,
        rows: List<WidgetRowIds>,
    ): Boolean {
        var hasLessons = false
        rows.forEachIndexed { index, ids ->
            val end = timestamp(context, "${prefix}_${index}_end")
            val time = text(context, "${prefix}_${index}_time")
            val subject = text(context, "${prefix}_${index}_subject")
            val room = text(context, "${prefix}_${index}_room")
            val visible = subject.isNotBlank() && (end == 0L || end > System.currentTimeMillis())
            views.setViewVisibility(ids.container, if (visible) View.VISIBLE else View.GONE)
            views.setTextViewText(ids.time, time)
            views.setTextViewText(ids.subject, subject)
            val normalizedRoom = room.replace("Ауд. ", "").trim()
            views.setTextViewText(ids.room, normalizedRoom)
            views.setViewVisibility(
                ids.room,
                if (normalizedRoom.isBlank()) View.GONE else View.VISIBLE,
            )
            if (visible) hasLessons = true
        }
        return hasLessons
    }

    protected fun bindNextLesson(
        context: Context,
        views: RemoteViews,
        shortHeader: Boolean = false,
        startTimeOnly: Boolean = false,
        hideHeader: Boolean = false,
    ) {
        val now = System.currentTimeMillis()
        val nextIndex = (0 until 3).firstOrNull { index ->
            val subject = text(context, "widget_upcoming_${index}_subject")
            val end = timestamp(context, "widget_upcoming_${index}_end")
            subject.isNotBlank() && (end == 0L || end > now)
        }
        val allStoredLessonsExpired =
            nextIndex == null && timestamp(context, "widget_upcoming_count") > 0
        val storedHeader = if (nextIndex == null) text(context, "widget_header") else ""
        val storedSubject = when {
            nextIndex != null -> text(context, "widget_upcoming_${nextIndex}_subject")
            allStoredLessonsExpired -> "Пар больше нет"
            else -> text(context, "widget_subject")
        }
        val storedTime = when {
            nextIndex != null -> text(context, "widget_upcoming_${nextIndex}_time")
            allStoredLessonsExpired -> ""
            else -> text(context, "widget_time")
        }
        val storedRoom = when {
            nextIndex != null -> text(context, "widget_upcoming_${nextIndex}_room")
            allStoredLessonsExpired -> ""
            else -> text(context, "widget_room")
        }
        val start = nextIndex?.let { timestamp(context, "widget_upcoming_${it}_start") } ?: 0L
        val header = when {
            allStoredLessonsExpired -> "РАСПИСАНИЕ"
            start in 1..now -> "СЕЙЧАС"
            shortHeader -> "ПАРА"
            nextIndex != null -> "СЛЕДУЮЩАЯ ПАРА"
            else -> storedHeader.ifBlank { "РАСПИСАНИЕ" }
        }
        val time = if (startTimeOnly) {
            storedTime.substringBefore('—').substringBefore('–').trim()
        } else {
            storedTime
        }

        views.setTextViewText(R.id.widget_header, header)
        views.setViewVisibility(
            R.id.widget_header,
            if (hideHeader) View.GONE else View.VISIBLE,
        )
        views.setTextViewText(
            R.id.widget_subject,
            storedSubject.ifBlank { "Откройте приложение" },
        )
        views.setTextViewText(R.id.widget_time, time.ifBlank { "—" })
        views.setTextViewText(R.id.widget_room, storedRoom.replace("Ауд. ", "").trim())
        views.setViewVisibility(
            R.id.widget_room,
            if (storedRoom.isBlank()) View.GONE else View.VISIBLE,
        )
    }
}

/** Широкий компактный виджет 2x1. */
open class NextLessonWidgetProvider : ScheduleWidgetProvider(
    R.layout.next_lesson_widget_wide,
) {
    override fun bind(context: Context, views: RemoteViews) {
        bindNextLesson(
            context,
            views,
            shortHeader = true,
            startTimeOnly = true,
        )
    }
}

/** Минимальный виджет 1x1: время, предмет и аудитория. */
class NextLessonSquareWidgetProvider : ScheduleWidgetProvider(
    R.layout.next_lesson_widget_square,
) {
    override fun bind(context: Context, views: RemoteViews) {
        bindNextLesson(
            context,
            views,
            shortHeader = true,
            startTimeOnly = true,
            hideHeader = true,
        )
    }
}

/** Вертикальный компактный виджет 1x2. */
class NextLessonTallWidgetProvider : ScheduleWidgetProvider(
    R.layout.next_lesson_widget_tall,
) {
    override fun bind(context: Context, views: RemoteViews) {
        bindNextLesson(
            context,
            views,
            shortHeader = true,
            startTimeOnly = true,
        )
    }
}

class UpcomingLessonsWidgetProvider : ScheduleWidgetProvider(
    R.layout.next_lesson_widget_medium,
) {
    override fun bind(context: Context, views: RemoteViews) {
        val hasLessons = bindRows(
            context,
            views,
            "widget_upcoming",
            listOf(
                WidgetRowIds(
                    R.id.widget_row_0,
                    R.id.widget_item_0_time,
                    R.id.widget_item_0_subject,
                    R.id.widget_item_0_room,
                ),
                WidgetRowIds(
                    R.id.widget_row_1,
                    R.id.widget_item_1_time,
                    R.id.widget_item_1_subject,
                    R.id.widget_item_1_room,
                ),
                WidgetRowIds(
                    R.id.widget_row_2,
                    R.id.widget_item_2_time,
                    R.id.widget_item_2_subject,
                    R.id.widget_item_2_room,
                ),
            ),
        )
        views.setViewVisibility(R.id.widget_empty, if (hasLessons) View.GONE else View.VISIBLE)
    }
}

class TodayScheduleWidgetProvider : ScheduleWidgetProvider(
    R.layout.next_lesson_widget_large,
) {
    override fun bind(context: Context, views: RemoteViews) {
        if (!isWidgetDataFromToday(context)) {
            intArrayOf(
                R.id.widget_row_0,
                R.id.widget_row_1,
                R.id.widget_row_2,
                R.id.widget_row_3,
                R.id.widget_row_4,
                R.id.widget_row_5,
                R.id.widget_row_6,
            ).forEach { rowId ->
                views.setViewVisibility(rowId, View.GONE)
            }
            views.setTextViewText(R.id.widget_empty, "Откройте приложение для обновления")
            views.setViewVisibility(R.id.widget_empty, View.VISIBLE)
            return
        }
        val hasLessons = bindRows(
            context,
            views,
            "widget_item",
            listOf(
                WidgetRowIds(
                    R.id.widget_row_0,
                    R.id.widget_item_0_time,
                    R.id.widget_item_0_subject,
                    R.id.widget_item_0_room,
                ),
                WidgetRowIds(
                    R.id.widget_row_1,
                    R.id.widget_item_1_time,
                    R.id.widget_item_1_subject,
                    R.id.widget_item_1_room,
                ),
                WidgetRowIds(
                    R.id.widget_row_2,
                    R.id.widget_item_2_time,
                    R.id.widget_item_2_subject,
                    R.id.widget_item_2_room,
                ),
                WidgetRowIds(
                    R.id.widget_row_3,
                    R.id.widget_item_3_time,
                    R.id.widget_item_3_subject,
                    R.id.widget_item_3_room,
                ),
                WidgetRowIds(
                    R.id.widget_row_4,
                    R.id.widget_item_4_time,
                    R.id.widget_item_4_subject,
                    R.id.widget_item_4_room,
                ),
                WidgetRowIds(
                    R.id.widget_row_5,
                    R.id.widget_item_5_time,
                    R.id.widget_item_5_subject,
                    R.id.widget_item_5_room,
                ),
                WidgetRowIds(
                    R.id.widget_row_6,
                    R.id.widget_item_6_time,
                    R.id.widget_item_6_subject,
                    R.id.widget_item_6_room,
                ),
            ),
        )
        views.setViewVisibility(R.id.widget_empty, if (hasLessons) View.GONE else View.VISIBLE)
    }
}
