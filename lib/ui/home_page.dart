import 'package:android_libusb/provider/provider.dart';
import 'package:android_libusb/settings/key_store.dart';
import 'package:android_libusb/widget/color_picker_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onStateChange: _onStateChanged,
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  void _onStateChanged(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      final storage = ref.read(sharedPreferencesProvider);
      await storage.setString(borderColorKey, ref.read(borderColorProvider).value.toRadixString(16).padLeft(8, '0'));
      await storage.setString(tempColorKey, ref.read(tempColorProvider).value.toRadixString(16).padLeft(8, '0'));
      await storage.setString(humColorKey, ref.read(humColorProvider).value.toRadixString(16).padLeft(8, '0'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tempValue = ref.watch(tempValueProvider);
    final humValue = ref.watch(humValueProvider);
    final borderColor = ref.watch(borderColorProvider);
    final tempColor = ref.watch(tempColorProvider);
    final humColor = ref.watch(humColorProvider);

    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Spacer(),
              Container(
                width: 140,
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  children: [
                    Text(
                      tempValue,
                      style: TextStyle(color: tempColor, fontSize: 20),
                    ),
                    Text(
                      humValue,
                      style: TextStyle(color: humColor, fontSize: 20),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Divider(),
              const SizedBox(height: 10),
              const Text("Цвет рамки"),
              const SizedBox(height: 20),
              colorPickerWidget(borderColorProvider),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 10),
              const Text("Цвет значения температуры"),
              const SizedBox(height: 20),
              colorPickerWidget(tempColorProvider),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 10),
              const Text("Цвет значения влажности"),
              const SizedBox(height: 20),
              colorPickerWidget(humColorProvider),
              const SizedBox(height: 15),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
