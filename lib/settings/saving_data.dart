import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../provider/provider.dart';
import 'key_store.dart';

void savingData(WidgetRef ref) async {
  // Получаем из провайдеров последнее изменение
  final currentTempColor = ref.read(tempColorProvider).value.toRadixString(16).padLeft(8, '0');
  final currentHumColor = ref.read(humColorProvider).value.toRadixString(16).padLeft(8, '0');

  // Сохраняем текущие цвета шрифтов для использования в приложении
  final storage = ref.read(sharedPreferencesProvider);
  await storage.setString(tempColorKey, currentTempColor);
  await storage.setString(humColorKey, currentHumColor);

  // Сохраняем текущие цвета для использования в home screen
  await HomeWidget.saveWidgetData<String>(tempColorKey, "#$currentTempColor");
  await HomeWidget.saveWidgetData<String>(humColorKey, "#$currentHumColor");
  await HomeWidget.updateWidget(androidName: "HomeScreenWidget", qualifiedAndroidName: "com.example.android_libusb.HomeScreenWidget");
}
