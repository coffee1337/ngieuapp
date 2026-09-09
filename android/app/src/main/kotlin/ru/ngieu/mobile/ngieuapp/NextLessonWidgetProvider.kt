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
}

open class NextLessonSmallWidgetProvider : ScheduleWidgetProvider(
    R.layout.next_lesson_widget_small,
) {
    override fun bind(context: Context, views: RemoteViews) {
        views.setTextViewText(R.id.widget_header, text(context, "widget_header"))
        views.setTextViewText(R.id.widget_subject, text(context, "widget_subject"))
        views.setTextViewText(R.id.widget_time, text(context, "widget_time"))
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

/** Оставлен для уже добавленных виджетов предыдущей версии. */
class NextLessonWidgetProvider : NextLessonSmallWidgetProvider()
