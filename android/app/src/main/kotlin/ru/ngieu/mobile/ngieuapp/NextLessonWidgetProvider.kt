package ru.ngieu.mobile.ngieuapp

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.os.Bundle
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin

class NextLessonWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            updateWidget(context, appWidgetManager, widgetId)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle
    ) {
        updateWidget(context, appWidgetManager, appWidgetId)
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        widgetId: Int
    ) {
        val options = appWidgetManager.getAppWidgetOptions(widgetId)
        val layoutId = layoutForOptions(options)
        val views = RemoteViews(context.packageName, layoutId)
        val data = HomeWidgetPlugin.getData(context)

        val subject = data.getString("widget_subject", null) ?: "Нет данных"
        val time = data.getString("widget_time", null) ?: ""
        val room = data.getString("widget_room", null) ?: ""
        val header = data.getString("widget_header", null) ?: "СЛЕДУЮЩАЯ ПАРА"

        views.setTextViewText(R.id.widget_header, header)
        views.setTextViewText(R.id.widget_subject, subject)
        views.setTextViewText(R.id.widget_time, time)
        views.setTextViewText(R.id.widget_room, room)

        val launchIntent = HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java
        )
        views.setOnClickPendingIntent(R.id.widget_root, launchIntent)

        appWidgetManager.updateAppWidget(widgetId, views)
    }

    private fun layoutForOptions(options: Bundle): Int {
        val minWidth = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)
        val minHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT)

        return when {
            minHeight >= 160 || minWidth >= 300 -> R.layout.next_lesson_widget_large
            minWidth >= 220 -> R.layout.next_lesson_widget_medium
            else -> R.layout.next_lesson_widget_small
        }
    }
}
