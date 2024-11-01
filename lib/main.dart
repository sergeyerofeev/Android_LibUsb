import 'package:android_libusb/settings/key_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/provider.dart';
import 'ui/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  // Извлекаем из хранилища установленные значения цветов
  final tempColor = sharedPreferences.getString(tempColorKey) ?? "FFFF0000";
  final humColor = sharedPreferences.getString(humColorKey) ?? "FF0000FF";

  runApp(ProviderScope(
    overrides: [
      // Устанавливаем новые объекты
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      tempColorProvider.overrideWith((_) => Color(int.parse(tempColor, radix: 16))),
      humColorProvider.overrideWith((_) => Color(int.parse(humColor, radix: 16))),
    ],
    child: const MyApp(),
  ));
}
