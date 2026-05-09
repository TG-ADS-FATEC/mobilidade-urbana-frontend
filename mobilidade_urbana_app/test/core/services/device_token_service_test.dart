import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilidade_urbana_app/core/services/device_token_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('get() cria um UUID quando não existe token', () async {
    final token = await DeviceTokenService.get();
    expect(token, isNotEmpty);
    expect(token.length, equals(36)); // formato UUID v4
  });

  test('get() retorna o mesmo token em chamadas subsequentes', () async {
    final first = await DeviceTokenService.get();
    final second = await DeviceTokenService.get();
    expect(first, equals(second));
  });

  test('regenerate() gera um token diferente do anterior', () async {
    final original = await DeviceTokenService.get();
    final regenerated = await DeviceTokenService.regenerate();
    expect(regenerated, isNot(equals(original)));
  });

  test('delete() remove o token do storage', () async {
    await DeviceTokenService.get();
    await DeviceTokenService.delete();
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('device_token'), isNull);
  });

  test('saveJwt() + getJwt() fazem roundtrip correto', () async {
    await DeviceTokenService.saveJwt('header.payload.signature');
    expect(await DeviceTokenService.getJwt(), equals('header.payload.signature'));
  });

  test('deleteJwt() remove o JWT', () async {
    await DeviceTokenService.saveJwt('header.payload.signature');
    await DeviceTokenService.deleteJwt();
    expect(await DeviceTokenService.getJwt(), isNull);
  });
}