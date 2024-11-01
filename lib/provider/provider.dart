import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((_) => throw UnimplementedError());

// Провайдеры значений температуры и влажности
final tempValueProvider = StateProvider.autoDispose<String>((_) => "-?-");
final humValueProvider = StateProvider.autoDispose<String>((_) => "-?-");

// Провайдер цвета шрифта значения температуры
final tempColorProvider = StateProvider.autoDispose<Color>((_) => throw UnimplementedError());

// Провайдеры цвета шрифта значения влажности
final humColorProvider = StateProvider.autoDispose<Color>((_) => throw UnimplementedError());
