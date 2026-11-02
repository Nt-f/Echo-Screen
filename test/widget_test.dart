import 'package:flutter_test/flutter_test.dart';
import 'package:hassmic_screen/hassmic.dart';

void main() {
  test('the config hassmic hands out', () {
    final c = ScreenConfig.parse('{"enabled":true,"ha":"http://ha:8123","token":"t","default":5,"return":120,'
        '"screens":[{"name":"Home Assistant","url":"http://ha:8123/lovelace"},{"name":"Music","url":"http://ha:8123/m"}]}');
    expect(c.enabled, true);
    expect(c.screens.length, 2);
    expect(c.screens[1].name, 'Music');
    expect(c.defaultScreen, 0);          // out of range: the first
    expect(c.returnSeconds, 120);
  });
}
