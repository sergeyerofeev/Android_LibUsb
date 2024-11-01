package com.example.android_libusb

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Color
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider


class HomeScreenWidget : HomeWidgetProvider() {
    private var oldTempValue = "-?-"
    private var oldHumValue = "-?-"
    private var oldTempColor = "#FFFF0000"
    private var oldHumColor = "#FF0000FF"

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.home_screen_widget).apply {
                // Проверяем и устанавливаем значение, цвет и размер шрифта температуры
                val newTempValue = widgetData.getString("TEMP_VALUE", "-?-") as String
                if (oldTempValue != newTempValue) {
                    setTextViewText(R.id.textview_temp, newTempValue)
                    oldTempValue = newTempValue
                }
                val newTempColor = widgetData.getString("TEMP_COLOR", "#FFFF0000") as String
                if (oldTempColor != newTempColor) {
                    setTextColor(R.id.textview_temp, Color.parseColor(newTempColor))
                    oldTempColor = newTempColor
                }


                // Проверяем и устанавливаем значение, цвет и размер шрифта влажности
                val newHumValue = widgetData.getString("HUM_VALUE", "-?-") as String
                if (oldHumValue != newHumValue) {
                    setTextViewText(R.id.textview_hum, newHumValue)
                    oldHumValue = newHumValue
                }
                val newHumColor = widgetData.getString("HUM_COLOR", "#FF0000FF") as String
                if (oldHumColor != newHumColor) {
                    setTextColor(R.id.textview_hum, Color.parseColor(newHumColor))
                    oldHumColor = newHumColor
                }
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}