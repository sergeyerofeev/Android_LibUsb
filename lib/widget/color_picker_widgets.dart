import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hsv_color_pickers/hsv_color_pickers.dart';

Widget colorPickerWidget(AutoDisposeStateProvider<Color> provider) {
  return Consumer(
    builder: (_, ref, __) {
      return HuePicker(
        initialColor: HSVColor.fromColor(ref.read(provider)),
        thumbOverlayColor: Colors.green.withOpacity(0.3),
        trackHeight: 15,
        thumbShape: const HueSliderThumbShape(
          color: Colors.white,
          strokeWidth: 4,
          filled: false,
          showBorder: true,
          borderColor: Colors.blueGrey,
        ),
        onChanged: (HSVColor color) {
          ref.read(provider.notifier).state = color.toColor();
        },
      );
    },
  );
}
