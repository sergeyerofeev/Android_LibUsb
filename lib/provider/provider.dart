import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((_) => throw UnimplementedError());

// Провайдеры значений температуры и влажности
final tempValueProvider = StateProvider.autoDispose<String>((_) => "-?-");
final humValueProvider = StateProvider.autoDispose<String>((_) => "-?-");

// Провайдеры цветов рамки, значения температуры, значения влажности
final borderColorProvider = StateProvider.autoDispose<Color>((_) => throw UnimplementedError());
final tempColorProvider = StateProvider.autoDispose<Color>((_) => throw UnimplementedError());
final humColorProvider = StateProvider.autoDispose<Color>((_) => throw UnimplementedError());
