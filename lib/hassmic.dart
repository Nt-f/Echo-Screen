// The screen app's side of hassmic's contract (echo-dot-assist docs/screen-apps.md): the config, from 127.0.0.1 only
// (hassmic hands it to this app's uid alone), polled every 5 s while in front ("/front": hassmic gives the screen to
// the app while it has nothing of its own to show) and every 30 s while paused ("/back": alive, not to be started).
import 'dart:convert';
import 'dart:io';

class Screen {
  final String name, url;
  const Screen(this.name, this.url);
}

class ScreenConfig {
  final String raw;
  final bool enabled;
  final String ha, token;
  final List<Screen> screens;
  final int defaultScreen, returnSeconds;
  ScreenConfig._(this.raw, this.enabled, this.ha, this.token, this.screens, this.defaultScreen, this.returnSeconds);

  factory ScreenConfig.parse(String raw) {
    final j = jsonDecode(raw) as Map<String, dynamic>;
    final screens = [
      for (final s in (j['screens'] as List? ?? const [])) Screen('${s['name'] ?? ''}', '${s['url'] ?? ''}'),
    ];
    var def = (j['default'] as num? ?? 0).toInt();
    if (def < 0 || def >= screens.length) def = 0;
    return ScreenConfig._(raw, j['enabled'] == true, '${j['ha'] ?? ''}', '${j['token'] ?? ''}', screens, def,
        (j['return'] as num? ?? 0).toInt());
  }
}

class Hassmic {
  static const config = 'http://127.0.0.1:28931/kiosk/config';
  final _client = HttpClient()..connectionTimeout = const Duration(seconds: 2);

  /// the config (null: hassmic not answering, or not to this app); front: the app is in front
  Future<ScreenConfig?> poll({required bool front}) async {
    try {
      final req = await _client.getUrl(Uri.parse('$config/${front ? 'front' : 'back'}'));
      final res = await req.close().timeout(const Duration(seconds: 3));
      final body = await res.transform(utf8.decoder).join();
      if (res.statusCode != 200) return null;
      return ScreenConfig.parse(body);
    } catch (_) {
      return null;
    }
  }
}
