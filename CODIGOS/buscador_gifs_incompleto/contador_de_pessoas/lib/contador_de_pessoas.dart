import 'dart:async';

import 'package:flutter/services.dart';

class ContadorDePessoas {
  static const MethodChannel _channel =
      const MethodChannel('contador_de_pessoas');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
