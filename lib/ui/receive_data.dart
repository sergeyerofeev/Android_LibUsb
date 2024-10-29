import 'dart:async';
import 'dart:ffi';

import 'package:android_libusb/provider/provider.dart';
import 'package:android_libusb/ui/home_page.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:libusb_android/libusb_android.dart';
import 'package:libusb_android_helper/libusb_android_helper.dart';

import '../settings/extension.dart';

class ReceiveData extends ConsumerStatefulWidget {
  const ReceiveData({super.key});

  @override
  ConsumerState<ReceiveData> createState() => _ReceiveDataState();
}

class _ReceiveDataState extends ConsumerState<ReceiveData> {
  final libUsb = LibusbAndroidBindings(DynamicLibrary.open('liblibusb_android.so'));
  Timer? _timer;
  UsbDevice? _device;
  final _interfaceNumber = 0;

  final Pointer<Pointer<libusb_context>> _libusbContext = calloc<Pointer<libusb_context>>();
  final Pointer<Pointer<libusb_device_handle>> _devHandle = calloc<Pointer<libusb_device_handle>>();
  final Pointer<Int> _transferred = calloc<Int>(1);
  final Pointer<UnsignedChar> _buffer = calloc<UnsignedChar>(6);

  @override
  void initState() {
    super.initState();
    initUsb();
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    if (libUsb.libusb_release_interface(_devHandle.value, _interfaceNumber) == 0) {
      // Устройство присоединено и работает
      if (libUsb.libusb_kernel_driver_active(_devHandle.value, _interfaceNumber) == 0) {
        // Передаём управление usb, драйверу ядра
        libUsb.libusb_attach_kernel_driver(_devHandle.value, _interfaceNumber);
      }
    }

    _device = null;

    libUsb.libusb_close(_devHandle.value);
    libUsb.libusb_exit(_libusbContext.value);

    calloc.free(_buffer);
    calloc.free(_transferred);
    calloc.free(_devHandle);
    calloc.free(_libusbContext);

    super.dispose();
  }

  Future<void> initUsb() async {
    initLibUsb();

    await getUsbDevice();

    LibusbAndroidHelper.usbEventStream?.listen((event) async {
      try {
        if (event.action == UsbAction.usbDeviceAttached) {
          if (await event.device.hasPermission()) {
            _device = event.device;
            await _openDeviceAndRead();
          }
        } else if (event.action == UsbAction.usbDeviceDetached) {
          _device = null;
        }
      } catch (e) {
        _device = null;
      }
    });
  }

  void initLibUsb() {
    if (libUsb.libusb_set_option(_libusbContext.value, libusb_option.LIBUSB_OPTION_NO_DEVICE_DISCOVERY) < 0) {
      throw StateError('Не удалось установить параметр libusb');
    }

    if (libUsb.libusb_init(_libusbContext) < 0) {
      throw StateError('Не удалось инициализировать libusb');
    }
  }

  Future<void> getUsbDevice() async {
    try {
      // Получаем список подключенных USB устройств
      List<UsbDevice>? devices = await LibusbAndroidHelper.listDevices();
      if (devices != null && devices.isNotEmpty) {
        // Первое устройство в списке всегда будет соответствовать заданному в device_filter.xml
        _device = devices.first;
        await _openDeviceAndRead();
      }
    } catch (e) {
      _device = null;
    }
  }

  Future<void> _openDeviceAndRead() async {
    bool bResult = await _device!.open();
    if (bResult) {
      int result = libUsb.libusb_wrap_sys_device(_libusbContext.value, _device!.handle, _devHandle);
      if (result != 0) {
        throw StateError('Error libusb_wrap_sys_device');
      }

      if (libUsb.libusb_kernel_driver_active(_devHandle.value, _interfaceNumber) == 1) {
        if (libUsb.libusb_detach_kernel_driver(_devHandle.value, _interfaceNumber) != 0) {
          throw StateError('Error Kernel Driver Detached!');
        }
      }

      if (libUsb.libusb_claim_interface(_devHandle.value, _interfaceNumber) != 0) {
        throw StateError('Error libusb_claim_interface result!');
      }

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (libUsb.libusb_interrupt_transfer(_devHandle.value, 0x81, _buffer, 6, _transferred, 200) == 0) {
          if (_transferred.value == 6) {
            // Влажность
            int rawh = _buffer[0] << 16 | _buffer[1] << 8 | _buffer[2];
            // Температура
            int rawt = _buffer[3] << 16 | _buffer[4] << 8 | _buffer[5];
            final tempValue = rawt.toTemperature();
            final humValue = rawh.toHumidity();
            // Устанавливаем данные в провайдеры
            ref.read(temValueProvider.notifier).state = tempValue;
            ref.read(humValueProvider.notifier).state = humValue;
            // Устанавливаем данные для передачи в HomeScreenWidget
            await HomeWidget.saveWidgetData<String>("temperature", tempValue);
            await HomeWidget.saveWidgetData<String>("humidity", humValue);
            await HomeWidget.updateWidget(androidName: "HomeScreenWidget", qualifiedAndroidName: "com.example.android_libusb.HomeScreenWidget");
          }
        } else {
          await HomeWidget.saveWidgetData<String>("temperature", "-?-");
          await HomeWidget.saveWidgetData<String>("humidity", "-?-");
          timer.cancel();
          if (libUsb.libusb_release_interface(_devHandle.value, _interfaceNumber) == 0) {
            // Устройство присоединено и работает
            if (libUsb.libusb_kernel_driver_active(_devHandle.value, _interfaceNumber) == 0) {
              // Передаём управление usb, драйверу ядра
              libUsb.libusb_attach_kernel_driver(_devHandle.value, _interfaceNumber);
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
