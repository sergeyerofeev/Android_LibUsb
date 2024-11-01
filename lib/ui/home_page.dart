import 'package:android_libusb/provider/provider.dart';
import 'package:android_libusb/settings/saving_data.dart';
import 'package:android_libusb/widget/color_picker_widget.dart';
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
      // Сохраняем текущие цвета
      savingData(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tempValue = ref.watch(tempValueProvider);
    final humValue = ref.watch(humValueProvider);

    final tempColor = ref.watch(tempColorProvider);
    final humColor = ref.watch(humColorProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        // Сохраняем текущие цвета
        savingData(ref);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(left: 20.0, bottom: 0.0, right: 20.0, top: 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Spacer(),
                Container(
                  width: 140,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Text(
                        tempValue,
                        style: TextStyle(color: tempColor, fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        humValue,
                        style: TextStyle(color: humColor, fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Divider(),
                const SizedBox(height: 5.0),
                const Text("Цвет шрифта значения температуры"),
                const SizedBox(height: 25.0),
                colorPickerWidget(tempColorProvider),
                const SizedBox(height: 20.0),
                const Divider(),
                const SizedBox(height: 5.0),
                const Text("Цвет шрифта значения влажности"),
                const SizedBox(height: 25.0),
                colorPickerWidget(humColorProvider),
                const SizedBox(height: 20.0),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
