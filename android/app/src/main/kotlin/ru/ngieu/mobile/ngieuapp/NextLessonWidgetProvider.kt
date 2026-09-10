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

    protected fun bindRows(
        context: Context,
        views: RemoteViews,
        prefix: String,
        rowIds: IntArray,
    ): Boolean {
        var hasLessons = false
        rowIds.forEachIndexed { index, id ->
            val time = text(context, "${prefix}_${index}_time")
            val subject = text(context, "${prefix}_${index}_subject")
            val room = text(context, "${prefix}_${index}_room")
            val details = listOf(time, subject, room)
                .filter { it.isNotBlank() }
                .joinToString("  •  ")
            views.setTextViewText(id, details)
            views.setViewVisibility(id, if (subject.isBlank()) View.GONE else View.VISIBLE)
            if (subject.isNotBlank()) hasLessons = true
        }
        return hasLessons
    }

    protected fun bindNextLesson(
        context: Context,
        views: RemoteViews,
        shortHeader: Boolean = false,
        startTimeOnly: Boolean = false,
    ) {
        val storedHeader = text(context, "widget_header")
        val storedSubject = text(context, "widget_subject")
        val storedTime = text(context, "widget_time")
        val storedRoom = text(context, "widget_room")
        val header = if (shortHeader) "ПАРА" else storedHeader.ifBlank { "РАСПИСАНИЕ" }
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
