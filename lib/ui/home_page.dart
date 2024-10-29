import 'package:android_libusb/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hsv_color_pickers/hsv_color_pickers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _controller = HueController(HSVColor.fromColor(Colors.green));
  @override
  Widget build(BuildContext context) {
    Color _color = Colors.green;

    final tempValue = ref.watch(temValueProvider);
    final humValue = ref.watch(humValueProvider);

    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 140,
                decoration: BoxDecoration(
                  border: Border.all(color: _color, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  children: [
                    Text(tempValue),
                    Text(humValue),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 10),
              const Text("Цвет значения температуры"),
              const SizedBox(height: 20),
              HuePicker(
                initialColor: HSVColor.fromColor(_color),
                thumbOverlayColor: Colors.green.withOpacity(0.3),
                trackHeight: 15,
                thumbShape:
                    const HueSliderThumbShape(color: Colors.white, strokeWidth: 4, filled: false, showBorder: true, borderColor: Colors.blueGrey),
                onChanged: (HSVColor color) {
                  setState(() {
                    _color = color.toColor();
                  });
                },
              ),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 10),
              const Text("Цвет значения влажности"),
              const SizedBox(height: 20),
              HuePicker(
                initialColor: HSVColor.fromColor(_color),
                thumbOverlayColor: Colors.green.withOpacity(0.3),
                trackHeight: 15,
                thumbShape:
                    const HueSliderThumbShape(color: Colors.white, strokeWidth: 4, filled: false, showBorder: true, borderColor: Colors.blueGrey),
                onChanged: (HSVColor color) {
                  setState(() {
                    _color = color.toColor();
                  });
                },
              ),
              const SizedBox(height: 15),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
