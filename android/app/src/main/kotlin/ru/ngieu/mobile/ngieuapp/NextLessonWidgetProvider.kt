package ru.ngieu.mobile.ngieuapp

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin

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
        val data = HomeWidgetPlugin.getData(context)
        return try {
            data.getLong(key, 0L)
        } catch (_: ClassCastException) {
            data.getString(key, "0")?.toLongOrNull() ?: 0L
        }
    }

    protected fun bindRows(
        context: Context,
        views: RemoteViews,
        prefix: String,
        rowIds: IntArray,
    ): Boolean {
        var hasLessons = false
        rowIds.forEachIndexed { index, id ->
            val end = timestamp(context, "${prefix}_${index}_end")
            val time = text(context, "${prefix}_${index}_time")
            val subject = text(context, "${prefix}_${index}_subject")
            val room = text(context, "${prefix}_${index}_room")
            val details = listOf(time, subject, room)
                .filter { it.isNotBlank() }
                .joinToString("  •  ")
            views.setTextViewText(id, details)
            val visible = subject.isNotBlank() && (end == 0L || end > System.currentTimeMillis())
            views.setViewVisibility(id, if (visible) View.VISIBLE else View.GONE)
            if (visible) hasLessons = true
        }
        return hasLessons
    }

    protected fun bindNextLesson(
        context: Context,
        views: RemoteViews,
        shortHeader: Boolean = false,
        startTimeOnly: Boolean = false,
    ) {
        val now = System.currentTimeMillis()
        val nextIndex = (0 until 3).firstOrNull { index ->
            val subject = text(context, "widget_upcoming_${index}_subject")
            val end = timestamp(context, "widget_upcoming_${index}_end")
            subject.isNotBlank() && (end == 0L || end > now)
        }
        val storedHeader = if (nextIndex == null) text(context, "widget_header") else ""
        val storedSubject = nextIndex?.let { text(context, "widget_upcoming_${it}_subject") }
            ?: text(context, "widget_subject")
        val storedTime = nextIndex?.let { text(context, "widget_upcoming_${it}_time") }
            ?: text(context, "widget_time")
        val storedRoom = nextIndex?.let { text(context, "widget_upcoming_${it}_room") }
            ?: text(context, "widget_room")
        val start = nextIndex?.let { timestamp(context, "widget_upcoming_${it}_start") } ?: 0L
        val header = when {
            shortHeader -> "ПАРА"
            start in 1..now -> "СЕЙЧАС"
            nextIndex != null -> "СЛЕДУЮЩАЯ ПАРА"
            else -> storedHeader.ifBlank { "РАСПИСАНИЕ" }
        }
        val time = if (startTimeOnly) {
            storedTime.substringBefore('—').substringBefore('–').trim()
        } else {
            storedTime
        }

        views.setTextViewText(R.id.widget_header, header)
        views.setTextViewText(
            R.id.widget_subject,
            storedSubject.ifBlank { "Откройте приложение" },
        )
        views.setTextViewText(R.id.widget_time, time)
        views.setTextViewText(R.id.widget_room, storedRoom.replace("Ауд. ", ""))
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
        bindNextLesson(context, views)
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
            intArrayOf(R.id.widget_item_0, R.id.widget_item_1, R.id.widget_item_2),
        )
        views.setViewVisibility(R.id.widget_empty, if (hasLessons) View.GONE else View.VISIBLE)
    }
}

class TodayScheduleWidgetProvider : ScheduleWidgetProvider(
    R.layout.next_lesson_widget_large,
) {
    override fun bind(context: Context, views: RemoteViews) {
        val hasLessons = bindRows(
            context,
            views,
            "widget_item",
            intArrayOf(
                R.id.widget_item_0,
                R.id.widget_item_1,
                R.id.widget_item_2,
                R.id.widget_item_3,
                R.id.widget_item_4,
                R.id.widget_item_5,
                R.id.widget_item_6,
            ),
        )
        views.setViewVisibility(R.id.widget_empty, if (hasLessons) View.GONE else View.VISIBLE)
    }
}
