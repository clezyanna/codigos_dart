import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:contador_de_pessoas/contador_de_pessoas.dart';

void main() {
  const MethodChannel channel = MethodChannel('contador_de_pessoas');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await ContadorDePessoas.platformVersion, '42');
  });
}
