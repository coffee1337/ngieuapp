package ru.ngieu.mobile.ngieuapp

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin

class NextLessonWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.next_lesson_widget)
            val data = HomeWidgetPlugin.getData(context)

            val subject = data.getString("widget_subject", null) ?: "Нет данных"
            val time = data.getString("widget_time", null) ?: ""
            val room = data.getString("widget_room", null) ?: ""
            val header = data.getString("widget_header", null) ?: "СЛЕДУЮЩАЯ ПАРА"

            views.setTextViewText(R.id.widget_header, header)
            views.setTextViewText(R.id.widget_subject, subject)
            views.setTextViewText(R.id.widget_time, time)
            views.setTextViewText(R.id.widget_room, room)

            // При клике — открыть приложение
            val launchIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java
            )
            views.setOnClickPendingIntent(R.id.widget_root, launchIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}