import 'package:flutter_riverpod/flutter_riverpod.dart';

final temValueProvider = StateProvider.autoDispose<String>((_) => "-?-");
final humValueProvider = StateProvider.autoDispose<String>((_) => "-?-");
